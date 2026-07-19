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

              // Profile Card — shows actual user name
              GlassSurface(
                radius: LiquidGlassTheme.radius28,
                padding: const EdgeInsets.all(LiquidGlassTheme.space20),
                child: PressableScale(
                  onTap: () => _showEditProfileSheet(context, state),
                  borderRadius: BorderRadius.circular(
                    LiquidGlassTheme.radius28,
                  ),
                  child: Row(
                    children: [
                      // Avatar with user initial
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              accent.withValues(alpha: 0.8),
                              accent.withValues(alpha: 0.4),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            state.displayName.isNotEmpty
                                ? state.displayName[0].toUpperCase()
                                : 'G',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: LiquidGlassTheme.space16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.displayName,
                              style: LiquidGlassTheme.title,
                            ),
                            if (state.email.isNotEmpty) ...[
                              const SizedBox(height: LiquidGlassTheme.space8),
                              Text(
                                state.email,
                                style: LiquidGlassTheme.caption.copyWith(
                                  color: LiquidGlassTheme.foregroundSoft,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Icon(
                        CupertinoIcons.pencil,
                        color: LiquidGlassTheme.foregroundSoft,
                        size: 18,
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
                    _ToggleTile(
                      icon: CupertinoIcons.play_circle_fill,
                      title: isHindiApp ? 'वीडियो ऑटोप्ले' : 'Autoplay Videos',
                      subtitle: isHindiApp
                          ? 'विवरण स्क्रीन में प्रवेश करने पर वीडियो स्वचालित रूप से प्रारंभ करें।'
                          : 'Start videos automatically when entering the detail screen.',
                      value: state.autoplayEnabled,
                      onChanged: state.setAutoplayEnabled,
                      iconColor: const Color(0xFFEF4444),
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
                    // Theme selector — System / Light / Dark
                    _ThemeSelectorTile(
                      state: state,
                      iconColor: const Color(0xFFF59E0B),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: LiquidGlassTheme.space32),

              // VOICE SETTINGS SECTION
              Text(
                isHindiApp ? 'आवाज सेटिंग्स' : 'VOICE SETTINGS',
                style: LiquidGlassTheme.overline,
              ),
              const SizedBox(height: LiquidGlassTheme.space12),
              GlassSurface(
                radius: LiquidGlassTheme.radius28,
                padding: const EdgeInsets.all(LiquidGlassTheme.space8),
                child: Column(
                  children: [
                    _SliderTile(
                      icon: CupertinoIcons.music_mic,
                      title: isHindiApp ? 'आवाज की पिच' : 'Speech Pitch',
                      subtitle: isHindiApp
                          ? 'आवाज के तीखेपन या भारीपन को समायोजित करें।'
                          : 'Adjust the highness or lowness of the voice pitch.',
                      value: state.voicePitch,
                      min: 0.5,
                      max: 2.0,
                      onChanged: state.setVoicePitch,
                      iconColor: const Color(0xFF10B981),
                    ),
                    const _SettingsDivider(),
                    _ToggleTile(
                      icon: CupertinoIcons.app_badge,
                      title: isHindiApp ? 'सिमुलेशन रीडर' : 'Simulated Voice Reader',
                      subtitle: isHindiApp
                          ? 'देशी भाषण संश्लेषण की जगह टाइमर-आधारित पाठ पाठक का उपयोग करें।'
                          : 'Use simulated reader instead of native system speech engine.',
                      value: state.useTtsSimulation,
                      onChanged: state.setUseTtsSimulation,
                      iconColor: const Color(0xFF6366F1),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: LiquidGlassTheme.space32),

              // ACCESSIBILITY SECTION
              Text(
                isHindiApp ? 'सुलभता नियंत्रण' : 'ACCESSIBILITY CONTROLS',
                style: LiquidGlassTheme.overline,
              ),
              const SizedBox(height: LiquidGlassTheme.space12),
              GlassSurface(
                radius: LiquidGlassTheme.radius28,
                padding: const EdgeInsets.all(LiquidGlassTheme.space8),
                child: Column(
                  children: [
                    _FontSizeSelectorTile(
                      state: state,
                      iconColor: const Color(0xFFEC4899),
                    ),
                    const _SettingsDivider(),
                    _ToggleTile(
                      icon: CupertinoIcons.waveform,
                      title: isHindiApp ? 'स्पर्श प्रतिक्रिया' : 'Haptic Feedback',
                      subtitle: isHindiApp
                          ? 'बटनों और स्लाइडर्स पर सूक्ष्म स्पर्श कंपन सक्षम करें।'
                          : 'Enable subtle tactile vibrations on button and slider taps.',
                      value: state.hapticsEnabled,
                      onChanged: state.setHapticsEnabled,
                      iconColor: const Color(0xFF3B82F6),
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
                        state.logout();
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

              // Diagnostics footer
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

// ─── Theme Selector Tile ─────────────────────────────────────
class _ThemeSelectorTile extends StatelessWidget {
  const _ThemeSelectorTile({required this.state, required this.iconColor});

  final AppState state;
  final Color iconColor;

  IconData get _icon {
    switch (state.themeMode) {
      case ThemeMode.system:
        return CupertinoIcons.device_phone_portrait;
      case ThemeMode.light:
        return CupertinoIcons.sun_max_fill;
      case ThemeMode.dark:
        return CupertinoIcons.moon_fill;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isHindi = state.appLanguage == 'Hindi';

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
            child: Center(child: Icon(_icon, color: iconColor, size: 20)),
          ),
          const SizedBox(width: LiquidGlassTheme.space16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isHindi ? 'थीम' : 'Theme',
                  style: LiquidGlassTheme.bodyStrong.copyWith(
                    color: LiquidGlassTheme.foreground,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isHindi
                      ? 'डिवाइस थीम के अनुसार स्वचालित'
                      : 'Follows device theme automatically',
                  style: LiquidGlassTheme.caption.copyWith(
                    color: LiquidGlassTheme.foregroundSoft,
                  ),
                ),
              ],
            ),
          ),
          // Segmented control for System / Light / Dark
          CupertinoSlidingSegmentedControl<ThemeMode>(
            groupValue: state.themeMode,
            thumbColor: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.2),
            children: {
              ThemeMode.system: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Icon(
                  CupertinoIcons.device_phone_portrait,
                  size: 16,
                  color: LiquidGlassTheme.foreground,
                ),
              ),
              ThemeMode.light: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Icon(
                  CupertinoIcons.sun_max_fill,
                  size: 16,
                  color: LiquidGlassTheme.foreground,
                ),
              ),
              ThemeMode.dark: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Icon(
                  CupertinoIcons.moon_fill,
                  size: 16,
                  color: LiquidGlassTheme.foreground,
                ),
              ),
            },
            onValueChanged: (mode) {
              if (mode != null) {
                HapticFeedback.selectionClick();
                state.setThemeMode(mode);
              }
            },
          ),
        ],
      ),
    );
  }
}

// ─── Edit Profile Bottom Sheet ───────────────────────────────
void _showEditProfileSheet(BuildContext context, AppState state) {
  final nameController = TextEditingController(text: state.displayName);
  final emailController = TextEditingController(text: state.email);
  final isHindi = state.appLanguage == 'Hindi';

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.6),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: GlassSurface(
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
                  Text(
                    isHindi ? 'प्रोफ़ाइल संपादित करें' : 'Edit Profile',
                    style: LiquidGlassTheme.title,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      CupertinoIcons.xmark_circle_fill,
                      color: LiquidGlassTheme.foregroundSoft,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: LiquidGlassTheme.space20),
              Text(
                isHindi ? 'नाम' : 'Display Name',
                style: LiquidGlassTheme.caption.copyWith(
                  color: LiquidGlassTheme.foregroundSoft,
                ),
              ),
              const SizedBox(height: 8),
              CupertinoTextField(
                controller: nameController,
                placeholder: isHindi ? 'अपना नाम दर्ज करें' : 'Enter your name',
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: LiquidGlassTheme.backgroundSecondary,
                  borderRadius: BorderRadius.circular(14),
                ),
                style: LiquidGlassTheme.body.copyWith(
                  color: LiquidGlassTheme.foreground,
                ),
              ),
              const SizedBox(height: LiquidGlassTheme.space16),
              Text(
                isHindi ? 'ईमेल' : 'Email',
                style: LiquidGlassTheme.caption.copyWith(
                  color: LiquidGlassTheme.foregroundSoft,
                ),
              ),
              const SizedBox(height: 8),
              CupertinoTextField(
                controller: emailController,
                placeholder: isHindi
                    ? 'अपना ईमेल दर्ज करें'
                    : 'Enter your email',
                keyboardType: TextInputType.emailAddress,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: LiquidGlassTheme.backgroundSecondary,
                  borderRadius: BorderRadius.circular(14),
                ),
                style: LiquidGlassTheme.body.copyWith(
                  color: LiquidGlassTheme.foreground,
                ),
              ),
              const SizedBox(height: LiquidGlassTheme.space24),
              SizedBox(
                width: double.infinity,
                child: CupertinoButton.filled(
                  borderRadius: BorderRadius.circular(16),
                  onPressed: () {
                    state.setDisplayName(nameController.text);
                    state.setEmail(emailController.text);
                    Navigator.of(context).pop();
                    GlassMessage.show(
                      context,
                      isHindi ? 'प्रोफ़ाइल अपडेट किया गया' : 'Profile updated',
                    );
                  },
                  child: Text(isHindi ? 'सहेजें' : 'Save'),
                ),
              ),
              const SizedBox(height: LiquidGlassTheme.space12),
            ],
          ),
        ),
      );
    },
  );
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
                    const SizedBox(width: 8),
                    buildOption('हिन्दी', 'Hindi', state.contentLanguage, () {
                      HapticFeedback.selectionClick();
                      state.setContentLanguage('Hindi');
                      setModalState(() {});
                    }),
                    const SizedBox(width: 8),
                    buildOption(
                      isHindiApp ? 'दोनों' : 'Both',
                      'Both',
                      state.contentLanguage,
                      () {
                        HapticFeedback.selectionClick();
                        state.setContentLanguage('Both');
                        setModalState(() {});
                      },
                    ),
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

class _SliderTile extends StatelessWidget {
  const _SliderTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    required this.iconColor,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.all(LiquidGlassTheme.space12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
              Text(
                '${value.toStringAsFixed(1)}x',
                style: LiquidGlassTheme.bodyStrong.copyWith(
                  color: accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 54),
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: accent,
                inactiveTrackColor: LiquidGlassTheme.outline,
                thumbColor: accent,
                overlayColor: accent.withValues(alpha: 0.2),
                trackHeight: 4,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
              ),
              child: Slider(
                value: value,
                min: min,
                max: max,
                onChanged: (val) {
                  if (AppState.instance?.hapticsEnabled ?? true) {
                    HapticFeedback.selectionClick();
                  }
                  onChanged(val);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FontSizeSelectorTile extends StatelessWidget {
  const _FontSizeSelectorTile({required this.state, required this.iconColor});

  final AppState state;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final isHindi = state.appLanguage == 'Hindi';

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
            child: Center(
              child: Icon(
                CupertinoIcons.textformat_size,
                color: iconColor,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: LiquidGlassTheme.space16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isHindi ? 'फ़ॉन्ट आकार' : 'Text Size',
                  style: LiquidGlassTheme.bodyStrong.copyWith(
                    color: LiquidGlassTheme.foreground,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isHindi ? 'ऐप की मुख्य पाठ फ़ॉन्ट आकार' : 'Scale text sizes inside the application',
                  style: LiquidGlassTheme.caption.copyWith(
                    color: LiquidGlassTheme.foregroundSoft,
                  ),
                ),
              ],
            ),
          ),
          CupertinoSlidingSegmentedControl<double>(
            groupValue: state.fontSizeScale,
            thumbColor: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.2),
            children: {
              0.85: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Text(
                  isHindi ? 'छोटा' : 'S',
                  style: LiquidGlassTheme.bodyStrong.copyWith(fontSize: 12),
                ),
              ),
              1.0: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Text(
                  isHindi ? 'मध्यम' : 'M',
                  style: LiquidGlassTheme.bodyStrong.copyWith(fontSize: 14),
                ),
              ),
              1.15: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Text(
                  isHindi ? 'बड़ा' : 'L',
                  style: LiquidGlassTheme.bodyStrong.copyWith(fontSize: 16),
                ),
              ),
              1.3: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Text(
                  isHindi ? 'विशाल' : 'XL',
                  style: LiquidGlassTheme.bodyStrong.copyWith(fontSize: 18),
                ),
              ),
            },
            onValueChanged: (val) {
              if (val != null) {
                if (state.hapticsEnabled) {
                  HapticFeedback.selectionClick();
                }
                state.setFontSizeScale(val);
              }
            },
          ),
        ],
      ),
    );
  }
}
