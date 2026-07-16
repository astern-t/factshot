import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:factshot/app/app_state.dart';
import 'package:factshot/core/theme/liquid_glass_theme.dart';
import 'package:factshot/core/widgets/factshot_background/factshot_background.dart';
import 'package:factshot/core/widgets/pressable_scale/pressable_scale.dart';
import 'package:factshot/core/widgets/glass_message/glass_message.dart';
import 'package:factshot/core/widgets/glass_surface/glass_surface.dart';
import 'package:factshot/core/utils/transition_helper.dart';
import 'package:factshot/core/utils/translations.dart';
import 'package:factshot/features/auth/presentation/screens/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;

    final isHindiApp = state.appLanguage == 'Hindi';

    return Scaffold(
      body: FactShotBackground(
        child: SafeArea(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
            children: [
              // Screen Title
              Text(
                AppTranslations.translate(context, 'settings'),
                style: LiquidGlassTheme.display,
              ),
              const SizedBox(height: LiquidGlassTheme.space24),

              // Redesigned Premium Profile Card
              GlassSurface(
                radius: LiquidGlassTheme.radius28,
                padding: const EdgeInsets.all(LiquidGlassTheme.space20),
                child: PressableScale(
                  onTap: () => GlassMessage.show(
                    context,
                    AppTranslations.translate(context, 'edit_profile'),
                  ),
                  borderRadius: BorderRadius.circular(
                    LiquidGlassTheme.radius28,
                  ),
                  child: Row(
                    children: [
                      // Premium circular avatar with glass border
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: const NetworkImage(
                            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=200',
                          ),
                          backgroundColor: LiquidGlassTheme.backgroundSecondary,
                        ),
                      ),
                      const SizedBox(width: LiquidGlassTheme.space16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Alex Mercer',
                                  style: LiquidGlassTheme.title,
                                ),
                                const SizedBox(width: LiquidGlassTheme.space8),
                                // Pro Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: accent.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'PRO',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: accent,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: LiquidGlassTheme.space8),
                            Text(
                              'alex.mercer@factshot.io',
                              style: LiquidGlassTheme.caption.copyWith(
                                color: LiquidGlassTheme.foregroundSoft,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        CupertinoIcons.chevron_right,
                        color: LiquidGlassTheme.foregroundSoft,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: LiquidGlassTheme.space32),

              // PREFERENCES SECTION
              Text(
                AppTranslations.translate(context, 'preferences'),
                style: LiquidGlassTheme.overline,
              ),
              const SizedBox(height: LiquidGlassTheme.space12),
              GlassSurface(
                radius: LiquidGlassTheme.radius28,
                padding: const EdgeInsets.all(LiquidGlassTheme.space8),
                child: Column(
                  children: [
                    _ToggleTile(
                      icon: CupertinoIcons.bell_fill,
                      title: AppTranslations.translate(
                        context,
                        'push_notifications',
                      ),
                      subtitle: AppTranslations.translate(
                        context,
                        'push_notifications_sub',
                      ),
                      value: state.notificationsEnabled,
                      onChanged: state.setNotificationsEnabled,
                      iconColor: const Color(0xFF8B5CF6),
                    ),
                    const _SettingsDivider(),
                    _ToggleTile(
                      icon: CupertinoIcons.bolt_fill,
                      title: AppTranslations.translate(
                        context,
                        'offline_reading',
                      ),
                      subtitle: AppTranslations.translate(
                        context,
                        'offline_reading_sub',
                      ),
                      value: state.offlineReadingEnabled,
                      onChanged: state.setOfflineReadingEnabled,
                      iconColor: const Color(0xFF0D9488),
                    ),
                    const _SettingsDivider(),
                    _ActionTile(
                      icon: CupertinoIcons.globe,
                      title: isHindiApp ? 'भाषा सेटिंग्स' : 'Language Settings',
                      valueText:
                          '${state.appLanguage} • ${state.contentLanguage}',
                      onTap: () => _showLanguagePicker(context, state),
                      iconColor: const Color(0xFF3B82F6),
                    ),
                    const _SettingsDivider(),
                    _ToggleTile(
                      icon: state.isDarkMode
                          ? CupertinoIcons.moon_fill
                          : CupertinoIcons.sun_max_fill,
                      title: AppTranslations.translate(context, 'day_mode'),
                      subtitle: AppTranslations.translate(
                        context,
                        'day_mode_sub',
                      ),
                      value: !state.isDarkMode,
                      onChanged: (val) {
                        state.setThemeMode(
                          val ? ThemeMode.light : ThemeMode.dark,
                        );
                      },
                      iconColor: const Color(0xFFF59E0B),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: LiquidGlassTheme.space32),

              // ACCOUNT SECTION
              Text(
                AppTranslations.translate(context, 'account'),
                style: LiquidGlassTheme.overline,
              ),
              const SizedBox(height: LiquidGlassTheme.space12),
              GlassSurface(
                radius: LiquidGlassTheme.radius28,
                padding: const EdgeInsets.all(LiquidGlassTheme.space8),
                child: Column(
                  children: [
                    _ActionTile(
                      icon: CupertinoIcons.bubble_left_fill,
                      title: AppTranslations.translate(context, 'feedback'),
                      onTap: () => GlassMessage.show(
                        context,
                        AppTranslations.translate(context, 'feedback_success'),
                      ),
                      iconColor: const Color(0xFFEC4899),
                    ),
                    const _SettingsDivider(),
                    _ActionTile(
                      icon: CupertinoIcons.square_arrow_right_fill,
                      title: AppTranslations.translate(context, 'logout'),
                      destructive: true,
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          GlassPageRoute(page: const LoginScreen()),
                          (route) => false,
                        );
                      },
                      iconColor: const Color(0xFFEF4444),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: LiquidGlassTheme.space32),

              // Redesigned Diagnostics footer
              Center(
                child: Text(
                  'FactShot v1.0.0 • Material: ${state.glassMode.name.toUpperCase()} • Theme: BLUE',
                  style: LiquidGlassTheme.caption.copyWith(
                    color: LiquidGlassTheme.foregroundSoft,
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

class _SettingsDivider extends StatelessWidget {
  const _SettingsDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: LiquidGlassTheme.space16),
      child: Divider(color: LiquidGlassTheme.outline, height: 1, thickness: 1),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  const _ToggleTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.iconColor,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.all(LiquidGlassTheme.space12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: Icon(icon, color: iconColor, size: 20)),
          ),
          const SizedBox(width: LiquidGlassTheme.space16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: LiquidGlassTheme.bodyStrong.copyWith(
                    color: LiquidGlassTheme.foreground,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: LiquidGlassTheme.caption.copyWith(
                    color: LiquidGlassTheme.foregroundSoft,
                  ),
                ),
              ],
            ),
          ),
          CupertinoSwitch(
            value: value,
            activeTrackColor: accent,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.valueText,
    required this.iconColor,
    this.destructive = false,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final String? valueText;
  final Color iconColor;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final color = destructive
        ? LiquidGlassTheme.error
        : LiquidGlassTheme.foreground;

    return PressableScale(
      onTap: onTap,
      borderRadius: BorderRadius.circular(LiquidGlassTheme.radius20),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: LiquidGlassTheme.space12,
          horizontal: LiquidGlassTheme.space16,
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(child: Icon(icon, color: iconColor, size: 20)),
            ),
            const SizedBox(width: LiquidGlassTheme.space16),
            Expanded(
              child: Text(
                title,
                style: LiquidGlassTheme.bodyStrong.copyWith(color: color),
              ),
            ),
            if (valueText != null) ...[
              Text(
                valueText!,
                style: LiquidGlassTheme.body.copyWith(
                  color: LiquidGlassTheme.foregroundSoft,
                ),
              ),
              const SizedBox(width: LiquidGlassTheme.space8),
            ],
            Icon(
              CupertinoIcons.chevron_right,
              color: LiquidGlassTheme.foregroundSoft,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}

void _showLanguagePicker(BuildContext context, AppState state) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.6),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          final theme = Theme.of(context);
          final accent = theme.colorScheme.primary;
          final isDark = theme.brightness == Brightness.dark;

          final isHindiApp = state.appLanguage == 'Hindi';
          final titleText = isHindiApp ? 'भाषा सेटिंग्स' : 'Language Settings';

          final appHeader = isHindiApp
              ? 'ऐप की भाषा (Interface)'
              : 'App Language (Interface)';
          final contentHeader = isHindiApp
              ? 'सामग्री की भाषा (Content)'
              : 'Content Language (Articles)';

          Widget buildOption(
            String label,
            String codeVal,
            String currentVal,
            VoidCallback onTap,
          ) {
            final isSel = currentVal == codeVal;
            return Expanded(
              child: PressableScale(
                onTap: onTap,
                borderRadius: BorderRadius.circular(16),
                child: GlassSurface(
                  radius: 16,
                  level: isSel ? GlassLevel.strong : GlassLevel.subtle,
                  tintColor: isSel ? accent : null,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),
                  child: Center(
                    child: Text(
                      label,
                      style: LiquidGlassTheme.bodyStrong.copyWith(
                        color: isSel
                            ? (isDark ? Colors.white : Colors.black87)
                            : LiquidGlassTheme.foreground,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }

          return GlassSurface(
            radius: LiquidGlassTheme.radius28,
            level: GlassLevel.strong,
            padding: const EdgeInsets.symmetric(
              horizontal: LiquidGlassTheme.space20,
              vertical: LiquidGlassTheme.space24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(titleText, style: LiquidGlassTheme.title),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(
                        CupertinoIcons.xmark_circle_fill,
                        color: LiquidGlassTheme.foregroundSoft,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: LiquidGlassTheme.space16),
                const Divider(),
                const SizedBox(height: LiquidGlassTheme.space16),

                // App Language Row
                Text(
                  appHeader,
                  style: LiquidGlassTheme.bodyStrong.copyWith(fontSize: 15),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    buildOption('English', 'English', state.appLanguage, () {
                      HapticFeedback.selectionClick();
                      state.setAppLanguage('English');
                      setModalState(() {});
                    }),
                    const SizedBox(width: 12),
                    buildOption('हिन्दी', 'Hindi', state.appLanguage, () {
                      HapticFeedback.selectionClick();
                      state.setAppLanguage('Hindi');
                      setModalState(() {});
                    }),
                  ],
                ),

                const SizedBox(height: LiquidGlassTheme.space24),

                // Content Language Row
                Text(
                  contentHeader,
                  style: LiquidGlassTheme.bodyStrong.copyWith(fontSize: 15),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    buildOption(
                      'English',
                      'English',
                      state.contentLanguage,
                      () {
                        HapticFeedback.selectionClick();
                        state.setContentLanguage('English');
                        setModalState(() {});
                      },
                    ),
                    const SizedBox(width: 12),
                    buildOption('हिन्दी', 'Hindi', state.contentLanguage, () {
                      HapticFeedback.selectionClick();
                      state.setContentLanguage('Hindi');
                      setModalState(() {});
                    }),
                  ],
                ),
                const SizedBox(height: LiquidGlassTheme.space24),
              ],
            ),
          );
        },
      );
    },
  );
}
