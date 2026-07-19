import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:factshot/app/app_state.dart';
import 'package:factshot/core/theme/liquid_glass_theme.dart';
import 'package:factshot/core/utils/transition_helper.dart';
import 'package:factshot/core/widgets/glass_message/glass_message.dart';
import 'package:factshot/core/widgets/pressable_scale/pressable_scale.dart';
import 'package:factshot/core/widgets/glass_text_field/glass_text_field.dart';
import 'package:factshot/core/widgets/glass_button/glass_button.dart';
import 'package:factshot/core/utils/translations.dart';
import 'package:factshot/features/shell/home_shell.dart';
import '../widgets/login_background.dart';
import '../widgets/welcome_header.dart';
import '../widgets/google_login_card.dart';
import '../widgets/apple_login_card.dart';
import '../widgets/guest_login_card.dart';
import '../widgets/privacy_footer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  bool _isLoading = false;
  bool _isLogin = true;
  bool _obscurePassword = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _mobileController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _submitLogin(String provider) async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 1600));

    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });

    final state = AppScope.of(context);
    state.setOnboardingComplete();
    state.setLoggedIn(true);
    if (provider == 'Guest Mode') {
      state.setDisplayName('Guest');
      state.setEmail('');
    } else if (provider == 'Email/Password' || provider == 'Email/Password Registration') {
      if (_isLogin) {
        state.setDisplayName(_emailController.text.split('@').first);
        state.setEmail(_emailController.text);
      } else {
        state.setDisplayName(_nameController.text);
        state.setEmail(_emailController.text);
      }
    } else {
      state.setDisplayName('$provider User');
      state.setEmail('${provider.toLowerCase()}@factshot.app');
    }

    GlassMessage.show(context, 'Signed in via $provider');

    Navigator.of(
      context,
    ).pushReplacement(GlassPageRoute(page: const MainNavigation()));
  }

  void _onFormSubmit() {
    if (_isLogin) {
      if (_emailController.text.trim().isEmpty ||
          _passwordController.text.trim().isEmpty) {
        GlassMessage.show(
          context,
          AppTranslations.translate(context, 'enter_credentials'),
        );
        return;
      }
      _submitLogin('Email/Password');
    } else {
      if (_nameController.text.trim().isEmpty ||
          _mobileController.text.trim().isEmpty ||
          _emailController.text.trim().isEmpty ||
          _passwordController.text.trim().isEmpty) {
        GlassMessage.show(
          context,
          AppTranslations.translate(context, 'filling_fields'),
        );
        return;
      }
      _submitLogin('Email/Password Registration');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return Scaffold(
      body: LoginBackground(
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: LiquidGlassTheme.space24,
                          vertical: LiquidGlassTheme.space32,
                        ),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            // Spacing adjusted for screen keyboard avoidance
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.08,
                            ),

                            // Welcome Header (Brand Logo + Left Aligned Title + Interactive Subtitle)
                            _StaggeredFadeUp(
                              controller: _animController,
                              delayFraction: 0.1,
                              child: WelcomeHeader(
                                isLogin: _isLogin,
                                onToggleMode: () {
                                  setState(() {
                                    _isLogin = !_isLogin;
                                    _obscurePassword = true;
                                    _emailController.clear();
                                    _passwordController.clear();
                                    _nameController.clear();
                                    _mobileController.clear();
                                  });
                                },
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Dynamic Form Layout
                            _StaggeredFadeUp(
                              controller: _animController,
                              delayFraction: 0.2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (!_isLogin) ...[
                                    // Name Field for registration
                                    GlassTextField(
                                      controller: _nameController,
                                      hintText: AppTranslations.translate(
                                        context,
                                        'name',
                                      ),
                                      prefixIcon: Icon(
                                        CupertinoIcons.person,
                                        size: 20,
                                        color: LiquidGlassTheme.foregroundSoft,
                                      ),
                                    ),
                                    const SizedBox(height: 16),

                                    // Mobile Field for registration
                                    GlassTextField(
                                      controller: _mobileController,
                                      hintText: AppTranslations.translate(
                                        context,
                                        'mobile',
                                      ),
                                      keyboardType: TextInputType.phone,
                                      prefixIcon: Icon(
                                        CupertinoIcons.phone,
                                        size: 20,
                                        color: LiquidGlassTheme.foregroundSoft,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                  ],

                                  // Email Field (Used in both login and register)
                                  GlassTextField(
                                    controller: _emailController,
                                    hintText: AppTranslations.translate(
                                      context,
                                      'email',
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    prefixIcon: Icon(
                                      CupertinoIcons.mail,
                                      size: 20,
                                      color: LiquidGlassTheme.foregroundSoft,
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Password Field (Used in both login and register)
                                  GlassTextField(
                                    controller: _passwordController,
                                    hintText: AppTranslations.translate(
                                      context,
                                      'password',
                                    ),
                                    obscureText: _obscurePassword,
                                    prefixIcon: Icon(
                                      CupertinoIcons.lock,
                                      size: 20,
                                      color: LiquidGlassTheme.foregroundSoft,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? CupertinoIcons.eye_slash
                                            : CupertinoIcons.eye,
                                        size: 20,
                                        color: LiquidGlassTheme.foregroundSoft,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  // Action Submit Button
                                  SizedBox(
                                    width: double.infinity,
                                    height: 56,
                                    child: GlassButton(
                                      label: _isLogin
                                          ? AppTranslations.translate(
                                              context,
                                              'login',
                                            )
                                          : AppTranslations.translate(
                                              context,
                                              'register',
                                            ),
                                      isPrimary: true,
                                      expanded: true,
                                      onTap: _onFormSubmit,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 28),

                            // Divider "Or continue with" / "या इनके साथ जारी रखें"
                            _StaggeredFadeUp(
                              controller: _animController,
                              delayFraction: 0.3,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      color: LiquidGlassTheme.outline
                                          .withValues(alpha: 0.5),
                                      thickness: 1,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: Text(
                                      AppTranslations.translate(
                                        context,
                                        'or_continue_with',
                                      ),
                                      style: LiquidGlassTheme.caption.copyWith(
                                        color: LiquidGlassTheme.foregroundSoft,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      color: LiquidGlassTheme.outline
                                          .withValues(alpha: 0.5),
                                      thickness: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Social Login Option Cards
                            _StaggeredFadeUp(
                              controller: _animController,
                              delayFraction: 0.35,
                              child: isIOS
                                  ? Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: GoogleLoginCard(
                                                onTap: () =>
                                                    _submitLogin('Google'),
                                                disabled: _isLoading,
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: AppleLoginCard(
                                                onTap: () =>
                                                    _submitLogin('Apple'),
                                                disabled: _isLoading,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: GuestLoginCard(
                                                onTap: () =>
                                                    _submitLogin('Guest Mode'),
                                                disabled: _isLoading,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        Expanded(
                                          child: GoogleLoginCard(
                                            onTap: () => _submitLogin('Google'),
                                            disabled: _isLoading,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: GuestLoginCard(
                                            onTap: () =>
                                                _submitLogin('Guest Mode'),
                                            disabled: _isLoading,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),

                            const SizedBox(height: 48),

                            // Bottom Navigation Footer
                            _StaggeredFadeUp(
                              controller: _animController,
                              delayFraction: 0.45,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Bottom Left Circular Back Button
                                  PressableScale(
                                    onTap: () {
                                      HapticFeedback.lightImpact();
                                      Navigator.of(context).pop();
                                    },
                                    borderRadius: BorderRadius.circular(28),
                                    child: Container(
                                      width: 56,
                                      height: 56,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white.withValues(
                                          alpha: 0.08,
                                        ),
                                        border: Border.all(
                                          color: Colors.white.withValues(
                                            alpha: 0.05,
                                          ),
                                          width: 1,
                                        ),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.arrow_back,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Bottom Right Muted Privacy Footer
                                  const Flexible(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 16.0),
                                      child: PrivacyFooter(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StaggeredFadeUp extends StatelessWidget {
  const _StaggeredFadeUp({
    required this.controller,
    required this.delayFraction,
    required this.child,
  });

  final AnimationController controller;
  final double delayFraction;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final start = delayFraction.clamp(0.0, 0.9);
    final end = (start + 0.4).clamp(0.0, 1.0);

    final animation = CurvedAnimation(
      parent: controller,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: Offset(0, (1 - animation.value) * 24),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
