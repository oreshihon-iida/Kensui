'use strict';

const CACHE_NAME = 'kensui-cache-v1';
const RESOURCES = {
  'index.html': true,
  'main.dart.js': true,
  'flutter_service_worker.js': true,
  'manifest.json': true,
  'icons/': true,
  'assets/': true
};

self.addEventListener('install', function(event) {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then((cache) => {
        return cache.addAll(Object.keys(RESOURCES));
      })
  );
});

self.addEventListener('activate', function(event) {
  event.waitUntil(
    caches.keys().then(function(keyList) {
      return Promise.all(keyList.map(function(key) {
        if (key !== CACHE_NAME) {
          return caches.delete(key);
        }
      }));
    })
  );
});

self.addEventListener('fetch', function(event) {
  event.respondWith(
    caches.match(event.request)
      .then(function(response) {
        if (response) {
          return response;
        }
        return fetch(event.request);
      })
  );
});
