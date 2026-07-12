import 'package:flutter/material.dart';
import 'app/app_state.dart';
import 'theme/liquid_glass_theme.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const FactShotApp());
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
        return AppScope(
          state: _appState,
          child: MaterialApp(
            title: 'FactShot',
            debugShowCheckedModeBanner: false,
            theme: LiquidGlassTheme.theme(_appState.accentColor),
            home: const SplashScreen(),
          ),
        );
      },
    );
  }
}
