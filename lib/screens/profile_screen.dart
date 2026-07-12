import 'package:flutter/material.dart';

import '../app/app_state.dart';
import '../theme/liquid_glass_theme.dart';
import '../widgets/factshot_background.dart';
import '../widgets/factshot_controls.dart';
import '../widgets/factshot_feedback.dart';
import '../widgets/glass_surface.dart';
import '../widgets/transition_helper.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final accent = Theme.of(context).colorScheme.primary;
    return Scaffold(
      body: FactShotBackground(
        child: SafeArea(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
            children: [
              Text('Settings', style: LiquidGlassTheme.display),
              const SizedBox(height: LiquidGlassTheme.space20),
              GlassSurface(
                radius: LiquidGlassTheme.radius28,
                padding: const EdgeInsets.all(LiquidGlassTheme.space20),
                child: PressableScale(
                  onTap: () => GlassMessage.show(
                    context,
                    'Profile editing is mocked, but the control is intentionally live.',
                  ),
                  borderRadius: BorderRadius.circular(
                    LiquidGlassTheme.radius28,
                  ),
                  child: Row(
                    children: [
                      GlassSurface(
                        width: 64,
                        height: 64,
                        radius: LiquidGlassTheme.radius24,
                        level: GlassLevel.strong,
                        child: const Icon(
                          Icons.person_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: LiquidGlassTheme.space16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Alex Mercer', style: LiquidGlassTheme.title),
                            const SizedBox(height: LiquidGlassTheme.space8),
                            Text(
                              'Premium briefings • Session sync active',
                              style: LiquidGlassTheme.caption,
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_outward_rounded,
                        color: Colors.white38,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: LiquidGlassTheme.space24),
              Text('APPEARANCE', style: LiquidGlassTheme.overline),
              const SizedBox(height: LiquidGlassTheme.space12),
              GlassSurface(
                radius: LiquidGlassTheme.radius28,
                padding: const EdgeInsets.all(LiquidGlassTheme.space20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Accent tint', style: LiquidGlassTheme.bodyStrong),
                    const SizedBox(height: LiquidGlassTheme.space12),
                    Row(
                      children: [
                        Expanded(
                          child: _TintOption(
                            label: 'Blue',
                            color: const Color(0xFF5AB2FF),
                            active: state.accentTheme == AccentTheme.blue,
                            onTap: () => state.setAccentTheme(AccentTheme.blue),
                          ),
                        ),
                        const SizedBox(width: LiquidGlassTheme.space12),
                        Expanded(
                          child: _TintOption(
                            label: 'Amber',
                            color: const Color(0xFFFFB347),
                            active: state.accentTheme == AccentTheme.amber,
                            onTap: () =>
                                state.setAccentTheme(AccentTheme.amber),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: LiquidGlassTheme.space24),
                    Text('Material mood', style: LiquidGlassTheme.bodyStrong),
                    const SizedBox(height: LiquidGlassTheme.space12),
                    Row(
                      children: [
                        Expanded(
                          child: GlassButton(
                            label: 'Dark',
                            expanded: true,
                            isPrimary: state.glassMode == GlassMode.dark,
                            onTap: () => state.setGlassMode(GlassMode.dark),
                          ),
                        ),
                        const SizedBox(width: LiquidGlassTheme.space12),
                        Expanded(
                          child: GlassButton(
                            label: 'Tinted',
                            expanded: true,
                            isPrimary: state.glassMode == GlassMode.tinted,
                            onTap: () => state.setGlassMode(GlassMode.tinted),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: LiquidGlassTheme.space12),
                    Text(
                      state.glassMode == GlassMode.dark
                          ? 'Dark keeps the glass clearer and lower-tint across the entire app.'
                          : 'Tinted injects more accent color and density across surfaces app-wide.',
                      style: LiquidGlassTheme.caption,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: LiquidGlassTheme.space24),
              Text('PREFERENCES', style: LiquidGlassTheme.overline),
              const SizedBox(height: LiquidGlassTheme.space12),
              GlassSurface(
                radius: LiquidGlassTheme.radius28,
                padding: const EdgeInsets.all(LiquidGlassTheme.space8),
                child: Column(
                  children: [
                    _ToggleTile(
                      icon: Icons.notifications_active_rounded,
                      title: 'Push notifications',
                      subtitle: 'Mock alert cadence for the daily brief.',
                      value: state.notificationsEnabled,
                      onChanged: state.setNotificationsEnabled,
                    ),
                    const Divider(),
                    _ToggleTile(
                      icon: Icons.offline_bolt_rounded,
                      title: 'Offline reading',
                      subtitle:
                          'Keep saved stories accessible in this prototype session.',
                      value: state.offlineReadingEnabled,
                      onChanged: state.setOfflineReadingEnabled,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: LiquidGlassTheme.space24),
              Text('ACCOUNT', style: LiquidGlassTheme.overline),
              const SizedBox(height: LiquidGlassTheme.space12),
              GlassSurface(
                radius: LiquidGlassTheme.radius28,
                padding: const EdgeInsets.all(LiquidGlassTheme.space8),
                child: Column(
                  children: [
                    _ActionTile(
                      icon: Icons.chat_bubble_outline_rounded,
                      title: 'Send feedback',
                      onTap: () => GlassMessage.show(
                        context,
                        'Feedback captured for the next design pass.',
                      ),
                    ),
                    const Divider(),
                    _ActionTile(
                      icon: Icons.logout_rounded,
                      title: 'Log out',
                      destructive: true,
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          GlassPageRoute(page: const LoginScreen()),
                          (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: LiquidGlassTheme.space24),
              GlassSurface(
                radius: LiquidGlassTheme.radius24,
                level: GlassLevel.subtle,
                padding: const EdgeInsets.all(LiquidGlassTheme.space16),
                child: Text(
                  'Current material: ${state.glassMode.name} • Accent: ${state.accentTheme.name} • Bookmark count: ${state.bookmarkedIds.length}',
                  style: LiquidGlassTheme.caption.copyWith(color: accent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TintOption extends StatelessWidget {
  const _TintOption({
    required this.label,
    required this.color,
    required this.active,
    required this.onTap,
  });

  final String label;
  final Color color;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GlassSurface(
      radius: LiquidGlassTheme.radius20,
      level: active ? GlassLevel.strong : GlassLevel.subtle,
      tintColor: color,
      child: PressableScale(
        onTap: onTap,
        borderRadius: BorderRadius.circular(LiquidGlassTheme.radius20),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: LiquidGlassTheme.space16,
            vertical: LiquidGlassTheme.space16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(shape: BoxShape.circle, color: color),
              ),
              const SizedBox(width: LiquidGlassTheme.space8),
              Text(label, style: LiquidGlassTheme.bodyStrong),
            ],
          ),
        ),
      ),
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
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.all(LiquidGlassTheme.space12),
      child: Row(
        children: [
          GlassSurface(
            width: 44,
            height: 44,
            radius: LiquidGlassTheme.radius16,
            level: GlassLevel.subtle,
            child: Icon(icon, color: accent, size: 20),
          ),
          const SizedBox(width: LiquidGlassTheme.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: LiquidGlassTheme.bodyStrong),
                const SizedBox(height: 4),
                Text(subtitle, style: LiquidGlassTheme.caption),
              ],
            ),
          ),
          Switch(value: value, activeThumbColor: accent, onChanged: onChanged),
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
    this.destructive = false,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final color = destructive ? LiquidGlassTheme.error : Colors.white;
    return PressableScale(
      onTap: onTap,
      borderRadius: BorderRadius.circular(LiquidGlassTheme.radius20),
      child: Padding(
        padding: const EdgeInsets.all(LiquidGlassTheme.space16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: LiquidGlassTheme.space12),
            Expanded(
              child: Text(
                title,
                style: LiquidGlassTheme.bodyStrong.copyWith(color: color),
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white24),
          ],
        ),
      ),
    );
  }
}
