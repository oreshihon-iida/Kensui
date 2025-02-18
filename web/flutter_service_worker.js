'use strict';

const CACHE_VERSION = 'v1';
const STATIC_CACHE = `kensui-static-${CACHE_VERSION}`;
const DYNAMIC_CACHE = `kensui-dynamic-${CACHE_VERSION}`;
const STATIC_RESOURCES = {
  'index.html': true,
  'main.dart.js': true,
  'flutter_service_worker.js': true,
  'manifest.json': true,
  'icons/': true,
  'assets/': true,
  'flutter_bootstrap.js': true
};

// キャッシュの最大サイズ
const CACHE_SIZE_LIMIT = 50;
const CACHE_EXPIRATION = 7 * 24 * 60 * 60 * 1000; // 1週間

// キャッシュの有効期限をチェック
async function trimCache(cacheName) {
  const cache = await caches.open(cacheName);
  const keys = await cache.keys();
  if (keys.length > CACHE_SIZE_LIMIT) {
    await cache.delete(keys[0]);
    await trimCache(cacheName);
  }
}

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(STATIC_CACHE)
      .then((cache) => {
        return cache.addAll(Object.keys(STATIC_RESOURCES));
      })
      .then(() => self.skipWaiting())
  );
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keyList) => {
      return Promise.all(keyList.map((key) => {
        if (key !== STATIC_CACHE && key !== DYNAMIC_CACHE) {
          return caches.delete(key);
        }
      }));
    })
    .then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', (event) => {
  const url = new URL(event.request.url);
  
  // 静的リソースの場合
  if (STATIC_RESOURCES[url.pathname] || 
      url.pathname.startsWith('/icons/') || 
      url.pathname.startsWith('/assets/')) {
    event.respondWith(
      caches.match(event.request)
        .then((response) => response || fetch(event.request))
    );
    return;
  }

  // 動的リソースの場合
  event.respondWith(
    caches.match(event.request)
      .then((response) => {
        if (response) {
          // キャッシュが存在する場合、バックグラウンドで更新
          const fetchPromise = fetch(event.request).then((networkResponse) => {
            caches.open(DYNAMIC_CACHE).then((cache) => {
              cache.put(event.request, networkResponse.clone());
              trimCache(DYNAMIC_CACHE);
            });
            return networkResponse;
          });
          return response;
        }

        // キャッシュが存在しない場合、ネットワークからフェッチしてキャッシュ
        return fetch(event.request)
          .then((networkResponse) => {
            const responseClone = networkResponse.clone();
            caches.open(DYNAMIC_CACHE).then((cache) => {
              cache.put(event.request, responseClone);
              trimCache(DYNAMIC_CACHE);
            });
            return networkResponse;
          });
      })
      .catch(() => {
        // オフライン時のフォールバック
        return new Response('オフラインです。インターネット接続を確認してください。', {
          status: 503,
          statusText: 'Service Unavailable',
          headers: new Headers({
            'Content-Type': 'text/plain;charset=UTF-8'
          })
        });
      })
  );
});
