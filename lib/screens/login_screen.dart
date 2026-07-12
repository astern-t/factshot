import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/liquid_glass_theme.dart';
import '../widgets/factshot_background.dart';
import '../widgets/factshot_controls.dart';
import '../widgets/factshot_feedback.dart';
import '../widgets/glass_surface.dart';
import '../widgets/transition_helper.dart';
import 'main_navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit({bool guest = false}) async {
    FocusScope.of(context).unfocus();
    if (!guest) {
      final value = _emailController.text.trim();
      final emailValid = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value);
      if (!emailValid) {
        GlassMessage.show(context, 'Enter a valid email to continue.');
        return;
      }
    }
    setState(() {
      _isLoading = true;
    });
    await Future<void>.delayed(const Duration(milliseconds: 950));
    if (!mounted) {
      return;
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(
      context,
    ).pushReplacement(GlassPageRoute(page: const MainNavigation()));
  }

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    return Scaffold(
      body: FactShotBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(LiquidGlassTheme.space20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                GlassSurface(
                  radius: LiquidGlassTheme.radius28,
                  padding: const EdgeInsets.all(LiquidGlassTheme.space24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GlassSurface(
                        width: 56,
                        height: 56,
                        radius: LiquidGlassTheme.radius20,
                        level: GlassLevel.strong,
                        child: Icon(
                          Icons.bolt_rounded,
                          color: accent,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: LiquidGlassTheme.space24),
                      Text(
                        'Sign in to shape your brief.',
                        style: LiquidGlassTheme.headline,
                      ),
                      const SizedBox(height: LiquidGlassTheme.space12),
                      Text(
                        'Mock login only, but the experience should still feel deliberate: validate input, stage the transition, and enter with state intact.',
                        style: LiquidGlassTheme.body,
                      ),
                      const SizedBox(height: LiquidGlassTheme.space24),
                      GlassTextField(
                        controller: _emailController,
                        hintText: 'name@company.com',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(
                          Icons.mail_outline_rounded,
                          color: Colors.white54,
                        ),
                        onSubmitted: (_) => _submit(),
                      ),
                      const SizedBox(height: LiquidGlassTheme.space16),
                      GlassButton(
                        label: 'Continue',
                        icon: Icons.arrow_forward_rounded,
                        expanded: true,
                        isPrimary: true,
                        isLoading: _isLoading,
                        onTap: _submit,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: LiquidGlassTheme.space16),
                Row(
                  children: [
                    Expanded(
                      child: GlassButton(
                        label: 'Google',
                        icon: Icons.g_mobiledata_rounded,
                        expanded: true,
                        onTap: _isLoading ? null : () => _submit(guest: true),
                      ),
                    ),
                    const SizedBox(width: LiquidGlassTheme.space12),
                    Expanded(
                      child: GlassButton(
                        label: 'Guest',
                        icon: Icons.person_outline_rounded,
                        expanded: true,
                        onTap: _isLoading ? null : () => _submit(guest: true),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  'By continuing, you agree to a prototype experience with mock content only.',
                  style: LiquidGlassTheme.caption,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
