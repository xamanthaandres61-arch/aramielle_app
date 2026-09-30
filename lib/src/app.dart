import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/services/app_state_provider.dart';
import 'core/widgets/aramielle_logo_header.dart';
import 'features/landing/landing_screen.dart';
import 'features/navigation/main_navigation_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppStateProvider(),
      child: Consumer<AppStateProvider>(
        builder: (context, appState, child) {
          Widget homeScreen;

          if (!appState.isSessionLoaded) {
            // Smooth splash loading screen while checking saved local session
            homeScreen = const Scaffold(
              backgroundColor: Color(0xFF1A1A1A),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AramielleLogoHeader(height: 80),
                    SizedBox(height: 24),
                    CircularProgressIndicator(color: Color(0xFFFFC900)),
                  ],
                ),
              ),
            );
          } else if (appState.isLoggedIn) {
            homeScreen = const MainNavigationScreen();
          } else {
            homeScreen = const LandingScreen();
          }

          return MaterialApp(
            title: 'Aramielle Restaurant',
            debugShowCheckedModeBanner: false,
            themeMode: appState.themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            home: homeScreen,
          );
        },
      ),
    );
  }
}
