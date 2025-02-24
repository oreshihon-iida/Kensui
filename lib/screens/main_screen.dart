import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../navigation/app_navigation_state.dart';
import '../widgets/bottom_navigation.dart';
import 'home_screen.dart';
import 'calendar_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppNavigationState(),
      child: Consumer<AppNavigationState>(
        builder: (context, navigationState, _) {
          return Scaffold(
            body: IndexedStack(
              index: navigationState.currentIndex,
              children: const [
                HomeScreen(),
                CalendarScreen(),
                ProfileScreen(),
              ],
            ),
            bottomNavigationBar: AppBottomNavigation(
              currentIndex: navigationState.currentIndex,
              onTap: (index) => navigationState.setIndex(index),
            ),
          );
        },
      ),
    );
  }
}
