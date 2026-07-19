import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:factshot/app/app_state.dart';
import 'package:factshot/core/theme/liquid_glass_theme.dart';
import 'package:factshot/core/widgets/factshot_background/factshot_background.dart';
import 'package:factshot/core/widgets/glass_surface/glass_surface.dart';
import 'package:factshot/core/widgets/glass_button/glass_button.dart';
import 'package:factshot/core/widgets/pressable_scale/pressable_scale.dart';
import 'package:factshot/core/utils/transition_helper.dart';
import 'package:factshot/features/auth/presentation/screens/login_screen.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen>
    with SingleTickerProviderStateMixin {
  String _tempAppLang = 'English';
  String _tempContentLang = 'English';
  late AnimationController _animController;
  bool _isInit = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      final state = AppScope.of(context);
      _tempAppLang = state.appLanguage;
      _tempContentLang = state.contentLanguage;
      _isInit = true;
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onContinue() {
    HapticFeedback.lightImpact();
    final state = AppScope.of(context);
    state.setAppLanguage(_tempAppLang);
    state.setContentLanguage(_tempContentLang);
    state.setOnboardingComplete();

    Navigator.of(
      context,
    ).pushReplacement(GlassPageRoute(page: const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accent = theme.colorScheme.primary;

    // Local titles based on temporary selection to give instant visual feedback
    final isHindiApp = _tempAppLang == 'Hindi';
    final titleText = isHindiApp ? 'भाषा का चयन करें' : 'Choose Language';
    final subText = isHindiApp
        ? 'ऐप इंटरफ़ेस और समाचार सामग्री के लिए अपनी पसंदीदा भाषाएँ चुनें।'
        : 'Select your preferred languages for app interface and news content.';

    final appLangHeader = isHindiApp ? '१. ऐप की भाषा' : '1. App Language';
    final appLangSub = isHindiApp
        ? 'मेन्यू, बटन और सेटिंग्स के लिए'
        : 'For menus, buttons and settings';

    final contentLangHeader = isHindiApp
        ? '२. समाचार की भाषा'
        : '2. Content Language';
    final contentLangSub = isHindiApp
        ? 'पढ़ने वाले समाचार लेखों के लिए'
        : 'For news articles you read';

    return Scaffold(
      body: FactShotBackground(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: LiquidGlassTheme.space24,
                        vertical: LiquidGlassTheme.space20,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          const SizedBox(height: LiquidGlassTheme.space20),

                          // Animated Headers
                          FadeTransition(
                            opacity: Tween<double>(begin: 0, end: 1).animate(
                              CurvedAnimation(
                                parent: _animController,
                                curve: const Interval(
                                  0.0,
                                  0.4,
                                  curve: Curves.easeOutCubic,
                                ),
                              ),
                            ),
                            child: SlideTransition(
                              position:
                                  Tween<Offset>(
                                    begin: const Offset(0, 0.2),
                                    end: Offset.zero,
                                  ).animate(
                                    CurvedAnimation(
                                      parent: _animController,
                                      curve: const Interval(
                                        0.0,
                                        0.4,
                                        curve: Curves.easeOutCubic,
                                      ),
                                    ),
                                  ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    titleText,
                                    style: LiquidGlassTheme.display.copyWith(
                                      fontSize: 36,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -1.0,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: LiquidGlassTheme.space12,
                                  ),
                                  Text(
                                    subText,
                                    style: LiquidGlassTheme.body.copyWith(
                                      color: LiquidGlassTheme.foregroundMuted,
                                      fontSize: 15,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: LiquidGlassTheme.space32),

                          // --- APP LANGUAGE SECTION ---
                          _buildSectionHeader(
                            header: appLangHeader,
                            subtitle: appLangSub,
                            delayStart: 0.2,
                          ),
                          const SizedBox(height: LiquidGlassTheme.space12),
                          _buildLanguageRow(
                            selectedLang: _tempAppLang,
                            onSelect: (lang) {
                              HapticFeedback.selectionClick();
                              setState(() {
                                _tempAppLang = lang;
                              });
                            },
                            delayStart: 0.3,
                            isDark: isDark,
                            accent: accent,
                          ),

                          const SizedBox(height: LiquidGlassTheme.space32),

                          // --- CONTENT LANGUAGE SECTION ---
                          _buildSectionHeader(
                            header: contentLangHeader,
                            subtitle: contentLangSub,
                            delayStart: 0.4,
                          ),
                          const SizedBox(height: LiquidGlassTheme.space12),
                          _buildLanguageRow(
                            selectedLang: _tempContentLang,
                            onSelect: (lang) {
                              HapticFeedback.selectionClick();
                              setState(() {
                                _tempContentLang = lang;
                              });
                            },
                            delayStart: 0.5,
                            isDark: isDark,
                            accent: accent,
                            isContentLang: true,
                          ),

                          const SizedBox(height: LiquidGlassTheme.space40),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),

              // Continue Button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: LiquidGlassTheme.space24,
                  vertical: LiquidGlassTheme.space20,
                ),
                child: FadeTransition(
                  opacity: Tween<double>(begin: 0, end: 1).animate(
                    CurvedAnimation(
                      parent: _animController,
                      curve: const Interval(
                        0.7,
                        1.0,
                        curve: Curves.easeOutCubic,
                      ),
                    ),
                  ),
                  child: SlideTransition(
                    position:
                        Tween<Offset>(
                          begin: const Offset(0, 0.4),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: _animController,
                            curve: const Interval(
                              0.7,
                              1.0,
                              curve: Curves.easeOutCubic,
                            ),
                          ),
                        ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 64,
                      child: GlassButton(
                        label: isHindiApp ? 'जारी रखें' : 'Continue',
                        isPrimary: true,
                        expanded: true,
                        onTap: _onContinue,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required String header,
    required String subtitle,
    required double delayStart,
  }) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _animController,
          curve: Interval(
            delayStart,
            delayStart + 0.3,
            curve: Curves.easeOutCubic,
          ),
        ),
      ),
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
            .animate(
              CurvedAnimation(
                parent: _animController,
                curve: Interval(
                  delayStart,
                  delayStart + 0.3,
                  curve: Curves.easeOutCubic,
                ),
              ),
            ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              header,
              style: LiquidGlassTheme.bodyStrong.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: LiquidGlassTheme.foreground,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: LiquidGlassTheme.caption.copyWith(
                fontSize: 13,
                color: LiquidGlassTheme.foregroundSoft,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageRow({
    required String selectedLang,
    required ValueChanged<String> onSelect,
    required double delayStart,
    required bool isDark,
    required Color accent,
    bool isContentLang = false,
  }) {
    final languages = [
      _LangData(
        name: 'English',
        nativeName: 'English',
        flag: '🇺🇸',
        accentColor: const Color(0xFF5AB2FF),
      ),
      _LangData(
        name: 'Hindi',
        nativeName: 'हिन्दी',
        flag: '🇮🇳',
        accentColor: const Color(0xFFFF9933),
      ),
      if (isContentLang)
        _LangData(
          name: 'Both',
          nativeName: 'दोनों',
          flag: '🇺🇸🇮🇳',
          accentColor: const Color(0xFF10B981),
        ),
    ];

    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _animController,
          curve: Interval(
            delayStart,
            delayStart + 0.3,
            curve: Curves.easeOutCubic,
          ),
        ),
      ),
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
            .animate(
              CurvedAnimation(
                parent: _animController,
                curve: Interval(
                  delayStart,
                  delayStart + 0.3,
                  curve: Curves.easeOutCubic,
                ),
              ),
            ),
        child: Row(
          children: List.generate(languages.length, (index) {
            final lang = languages[index];
            final isSelected = lang.name == selectedLang;

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? 0 : 8,
                  right: index == languages.length - 1 ? 0 : 8,
                ),
                child: PressableScale(
                  onTap: () => onSelect(lang.name),
                  borderRadius: BorderRadius.circular(24),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: lang.accentColor.withValues(
                                  alpha: isDark ? 0.15 : 0.08,
                                ),
                                blurRadius: 24,
                                spreadRadius: 2,
                                offset: const Offset(0, 8),
                              ),
                            ]
                          : [],
                    ),
                    child: GlassSurface(
                      radius: 24,
                      level: isSelected ? GlassLevel.strong : GlassLevel.subtle,
                      tintColor: isSelected ? lang.accentColor : null,
                      borderColor: isSelected
                          ? lang.accentColor.withValues(alpha: 0.5)
                          : null,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? lang.accentColor.withValues(alpha: 0.15)
                                  : (isDark ? Colors.white : Colors.black)
                                        .withValues(alpha: 0.05),
                            ),
                            child: Center(
                              child: Text(
                                lang.flag,
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            lang.nativeName,
                            style: LiquidGlassTheme.bodyStrong.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: isSelected
                                  ? (isDark ? Colors.white : Colors.black87)
                                  : LiquidGlassTheme.foreground,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            lang.name,
                            style: LiquidGlassTheme.caption.copyWith(
                              fontSize: 12,
                              color: isSelected
                                  ? lang.accentColor
                                  : LiquidGlassTheme.foregroundSoft,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _LangData {
  final String name;
  final String nativeName;
  final String flag;
  final Color accentColor;

  const _LangData({
    required this.name,
    required this.nativeName,
    required this.flag,
    required this.accentColor,
  });
}
