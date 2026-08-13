import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:factshot/app/app_state.dart';
import 'package:factshot/core/theme/liquid_glass_theme.dart';
import 'package:factshot/features/onboarding/onboarding_screen.dart';
import 'package:factshot/features/auth/presentation/screens/login_screen.dart';
import 'package:factshot/features/shell/home_shell.dart';

/// Custom scroll behavior that enables drag-scrolling for all device types,
/// including mouse dragging, stylus, trackpad, and touch.
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  const MyCustomScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.trackpad,
      };
}

/// [FactShotApp] is the root widget of the application.
/// It maintains the global configuration state (color accents, blur parameters, and bookmarked articles)
/// and builds the MaterialApp configured for Liquid Glass design.
class FactShotApp extends StatefulWidget {
  const FactShotApp({super.key});

  @override
  State<FactShotApp> createState() => _FactShotAppState();
}

class _FactShotAppState extends State<FactShotApp> {
  late final AppState _appState;

  @override
  void initState() {
    super.initState();
    _appState = AppState();
  }

  @override
  void dispose() {
    _appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _appState,
      builder: (context, child) {
        Widget homeWidget;
        if (!_appState.isInitialized) {
          homeWidget = const Scaffold(
            backgroundColor: Color(0xFF000000),
            body: Center(
              child: CupertinoActivityIndicator(color: Colors.white),
            ),
          );
        } else {
          if (!_appState.hasCompletedOnboarding) {
            homeWidget = const OnboardingScreen();
          } else if (!_appState.isLoggedIn) {
            homeWidget = const LoginScreen();
          } else {
            homeWidget = const MainNavigation();
          }
        }

        return AppScope(
          state: _appState,
          child: MaterialApp(
            title: 'FactShot',
            debugShowCheckedModeBanner: false,
            scrollBehavior: const MyCustomScrollBehavior(),
            theme: LiquidGlassTheme.theme(_appState.accentColor, false),
            darkTheme: LiquidGlassTheme.theme(_appState.accentColor, true),
            themeMode: _appState.themeMode,
            home: homeWidget,
          ),
        );
      },
    );
  }
}
