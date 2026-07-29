import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:factshot/app/app_state.dart';
import 'package:factshot/data/models/article/article_model.dart';
import 'package:factshot/core/theme/liquid_glass_theme.dart';
import 'package:factshot/core/widgets/factshot_background/factshot_background.dart';
import 'package:factshot/core/widgets/pressable_scale/pressable_scale.dart';
import 'package:factshot/core/widgets/glass_message/glass_message.dart';
import 'package:factshot/core/widgets/glass_surface/glass_surface.dart';
import 'package:factshot/core/widgets/glass_button/glass_button.dart';
import 'package:factshot/core/widgets/glass_chip/glass_chip.dart';
import 'package:factshot/core/widgets/glass_icon_button/glass_icon_button.dart';
import 'package:factshot/core/widgets/article_list_tile_card/article_list_tile_card.dart';
import 'package:factshot/core/widgets/empty_state_card/empty_state_card.dart';
import 'package:factshot/core/utils/transition_helper.dart';
import 'package:factshot/core/utils/translations.dart';
import 'package:factshot/core/utils/notification_service.dart';
import 'package:factshot/features/article_detail/article_detail_screen.dart';
import 'package:factshot/features/auth/presentation/screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _savedSearchController = TextEditingController();
  String _savedCategory = 'All';
  String _savedQuery = '';

  final List<String> _categories = const [
    'All',
    'Tech',
    'Science',
    'History',
    'India',
    'World',
  ];

  @override
  void dispose() {
    _savedSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;
    final isHindiApp = state.appLanguage == 'Hindi';

    final bookmarked = mockArticles
        .where((article) => state.bookmarkedIds.contains(article.id))
        .toList();

    final filteredBookmarked = bookmarked.where((article) {
      final matchesCat = _savedCategory == 'All' ||
          article.category.toLowerCase() == _savedCategory.toLowerCase();
      final matchesQuery = _savedQuery.isEmpty ||
          article.title.toLowerCase().contains(_savedQuery.toLowerCase()) ||
          article.summary.toLowerCase().contains(_savedQuery.toLowerCase());
      return matchesCat && matchesQuery;
    }).toList();

    return Scaffold(
      body: FactShotBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Top Header Bar: "Profile" title & Settings Gear Button in Top Corner
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isHindiApp ? 'प्रोफ़ाइल' : 'Profile',
                      style: LiquidGlassTheme.display,
                    ),
                    GlassIconButton(
                      icon: CupertinoIcons.gear_alt_fill,
                      size: 44,
                      iconColor: LiquidGlassTheme.foreground,
                      onTap: () => _showSettingsSheet(context, state),
                    ),
                  ],
                ),
              ),

              // Main Scrollable Content
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
                  children: [
                    // Profile User Card (Guest / Logged In User Info)
                    GlassSurface(
                      radius: LiquidGlassTheme.radius28,
                      padding: const EdgeInsets.all(LiquidGlassTheme.space20),
                      child: PressableScale(
                        onTap: () {
                          if (!state.isLoggedIn) {
                            Navigator.of(context).push(
                              GlassPageRoute(page: const LoginScreen()),
                            );
                          } else {
                            _showEditProfileSheet(context, state);
                          }
                        },
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
                                  Row(
                                    children: [
                                      Text(
                                        state.displayName,
                                        style: LiquidGlassTheme.title,
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: accent.withValues(alpha: 0.15),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: accent.withValues(
                                              alpha: 0.3,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          state.isLoggedIn
                                              ? (isHindiApp ? 'खाता' : 'User')
                                              : (isHindiApp
                                                  ? 'अतिथि'
                                                  : 'Guest'),
                                          style: TextStyle(
                                            color: accent,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    state.isLoggedIn && state.email.isNotEmpty
                                        ? state.email
                                        : (isHindiApp
                                            ? 'लॉगिन करने के लिए टैप करें'
                                            : 'Guest Account • Tap to sign in'),
                                    style: LiquidGlassTheme.caption.copyWith(
                                      color: LiquidGlassTheme.foregroundSoft,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              state.isLoggedIn
                                  ? CupertinoIcons.pencil
                                  : CupertinoIcons.chevron_right,
                              color: LiquidGlassTheme.foregroundSoft,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: LiquidGlassTheme.space24),

                    // ─── SAVED SECTION ──────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              isHindiApp ? 'सहेजे गए लेख' : 'Saved Stories',
                              style: LiquidGlassTheme.title,
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${bookmarked.length}',
                                style: LiquidGlassTheme.caption.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: accent,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (bookmarked.isNotEmpty)
                          GestureDetector(
                            onTap: () => _confirmClearAllSaved(context, state),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: LiquidGlassTheme.error.withValues(
                                  alpha: 0.15,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: LiquidGlassTheme.error.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                              ),
                              child: Text(
                                isHindiApp ? 'सभी हटाएं' : 'Clear All',
                                style: TextStyle(
                                  color: LiquidGlassTheme.error,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: LiquidGlassTheme.space12),

                    if (bookmarked.isNotEmpty) ...[
                      // Search Bar for Saved Stack
                      CupertinoSearchTextField(
                        controller: _savedSearchController,
                        placeholder: isHindiApp
                            ? 'सहेजे गए लेख खोजें...'
                            : 'Search saved stories...',
                        onChanged: (val) {
                          setState(() {
                            _savedQuery = val.trim();
                          });
                        },
                        style: LiquidGlassTheme.body.copyWith(
                          color: LiquidGlassTheme.foreground,
                        ),
                      ),
                      const SizedBox(height: LiquidGlassTheme.space12),

                      // Category Filter Chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: _categories.map((cat) {
                            final isSel = _savedCategory == cat;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: GlassChip(
                                label: cat == 'All'
                                    ? (isHindiApp ? 'सभी' : 'All')
                                    : cat,
                                selected: isSel,
                                onTap: () {
                                  setState(() {
                                    _savedCategory = cat;
                                  });
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: LiquidGlassTheme.space16),
                    ],

                    // Saved Articles Content (Clean List View)
                    if (bookmarked.isEmpty)
                      EmptyStateCard(
                        icon: CupertinoIcons.bookmark,
                        title: isHindiApp
                            ? 'आपकी सहेजी गई सूची खाली है'
                            : 'Your saved stack is empty.',
                        description: isHindiApp
                            ? 'फ़ीड या लेख स्क्रीन से बुकमार्क करें, फिर उन्हें यहाँ देखें।'
                            : 'Bookmark stories from the feed or detail screen to read them anytime.',
                      )
                    else if (filteredBookmarked.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Center(
                          child: Text(
                            isHindiApp
                                ? 'कोई परिणाम नहीं मिला'
                                : 'No matching saved stories found.',
                            style: LiquidGlassTheme.body.copyWith(
                              color: LiquidGlassTheme.foregroundSoft,
                            ),
                          ),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredBookmarked.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: LiquidGlassTheme.space12),
                        itemBuilder: (context, index) {
                          final article = filteredBookmarked[index];
                          return Dismissible(
                            key: ValueKey(article.id),
                            direction: DismissDirection.endToStart,
                            onDismissed: (_) {
                              state.toggleBookmark(article.id);
                              GlassMessage.show(
                                context,
                                'Removed "${article.title}" from saved.',
                              );
                            },
                            background: const _RemoveBackground(),
                            child: ArticleListTileCard(
                              article: article,
                              onTap: () {
                                Navigator.of(context).push(
                                  GlassPageRoute(
                                    page: ArticleDetailScreen(article: article),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Clear All Confirmation Dialog
void _confirmClearAllSaved(BuildContext context, AppState state) {
  final isHindi = state.appLanguage == 'Hindi';
  showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(
        isHindi ? 'सभी सहेजे गए लेख हटाएं?' : 'Clear all saved stories?',
      ),
      content: Text(
        isHindi
            ? 'क्या आप वाकई अपने सभी बुकमार्क हटाना चाहते हैं?'
            : 'This will remove all bookmarked stories from your saved stack.',
      ),
      actions: [
        CupertinoDialogAction(
          child: Text(isHindi ? 'रद्द करें' : 'Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          child: Text(isHindi ? 'हटाएं' : 'Clear All'),
          onPressed: () {
            final ids = List<String>.from(state.bookmarkedIds);
            for (final id in ids) {
              state.toggleBookmark(id);
            }
            Navigator.of(context).pop();
            GlassMessage.show(
              context,
              isHindi ? 'सभी बुकमार्क हटा दिए गए' : 'Cleared all saved stories.',
            );
          },
        ),
      ],
    ),
  );
}

// ─── Settings Bottom Sheet (Opened from top-corner gear button) ────────
void _showSettingsSheet(BuildContext context, AppState state) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.65),
    builder: (context) {
      final isHindiApp = state.appLanguage == 'Hindi';

      return DraggableScrollableSheet(
        initialChildSize: 0.88,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return GlassSurface(
            radius: LiquidGlassTheme.radius28,
            level: GlassLevel.strong,
            padding: const EdgeInsets.all(LiquidGlassTheme.space20),
            child: ListView(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          CupertinoIcons.gear_alt_fill,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          AppTranslations.translate(context, 'settings'),
                          style: LiquidGlassTheme.display.copyWith(fontSize: 26),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(
                        CupertinoIcons.xmark_circle_fill,
                        color: LiquidGlassTheme.foregroundSoft,
                        size: 26,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: LiquidGlassTheme.space20),

                // Account Actions Card
                GlassSurface(
                  radius: LiquidGlassTheme.radius20,
                  padding: const EdgeInsets.all(LiquidGlassTheme.space12),
                  child: Row(
                    children: [
                      Icon(
                        state.isLoggedIn
                            ? CupertinoIcons.person_crop_circle_fill
                            : CupertinoIcons.person_crop_circle_badge_plus,
                        color: Theme.of(context).colorScheme.primary,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.displayName,
                              style: LiquidGlassTheme.bodyStrong,
                            ),
                            Text(
                              state.isLoggedIn
                                  ? state.email
                                  : (isHindiApp
                                      ? 'अतिथि उपयोगकर्ता'
                                      : 'Guest User'),
                              style: LiquidGlassTheme.caption,
                            ),
                          ],
                        ),
                      ),
                      GlassButton(
                        label: state.isLoggedIn
                            ? (isHindiApp ? 'संपादित करें' : 'Edit')
                            : (isHindiApp ? 'लॉगिन' : 'Log In'),
                        isPrimary: !state.isLoggedIn,
                        onTap: () {
                          Navigator.of(context).pop();
                          if (state.isLoggedIn) {
                            _showEditProfileSheet(context, state);
                          } else {
                            Navigator.of(context).push(
                              GlassPageRoute(page: const LoginScreen()),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: LiquidGlassTheme.space24),

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
                      if (state.notificationsEnabled) ...[
                        const _SettingsDivider(),
                        _ToggleTile(
                          icon: CupertinoIcons.sun_max_fill,
                          title: isHindiApp ? 'प्रातःकालीन ब्रीफिंग (8:00 AM)' : 'Morning Briefing (8:00 AM)',
                          subtitle: isHindiApp
                              ? 'सुबह 8 बजे दुनिया की मुख्य खबरों का रिमाइंडर।'
                              : 'Daily 8:00 AM alert: It\'s time to read what is going on in the world!',
                          value: state.morningNotificationEnabled,
                          onChanged: state.setMorningNotificationEnabled,
                          iconColor: const Color(0xFFF59E0B),
                        ),
                        const _SettingsDivider(),
                        _ToggleTile(
                          icon: CupertinoIcons.moon_stars_fill,
                          title: isHindiApp ? 'रात्रिकालीन डाइजेस्ट (9:00 PM)' : 'Night Digest (9:00 PM)',
                          subtitle: isHindiApp
                              ? 'रात 9 बजे आज की शीर्ष कहानियों का सारांश।'
                              : 'Daily 9:00 PM alert: Evening recap of top stories before bedtime.',
                          value: state.nightNotificationEnabled,
                          onChanged: state.setNightNotificationEnabled,
                          iconColor: const Color(0xFF6366F1),
                        ),
                        const _SettingsDivider(),
                        _ActionTile(
                          icon: CupertinoIcons.bell_circle_fill,
                          title: isHindiApp ? 'मोबाइल नोटिफिकेशन भेजें' : 'Send Mobile Notification',
                          valueText: isHindiApp ? 'स्टेटस बार' : 'Status Bar',
                          onTap: () {
                            final isMorning = DateTime.now().hour < 18;
                            final title = isMorning
                                ? (isHindiApp
                                    ? '☀️ प्रातःकालीन समाचार: दुनिया में क्या हो रहा है'
                                    : '☀️ Morning Briefing: What is going on in the world!')
                                : (isHindiApp
                                    ? '🌙 रात्रिकालीन डाइजेस्ट: आज की मुख्य खबरें'
                                    : '🌙 Nightly FactShot: Evening Digest');
                            final body = isMorning
                                ? (isHindiApp
                                    ? 'यह जानने का समय है कि दुनिया में क्या हो रहा है! आज के मुख्य समाचार पढ़ें।'
                                    : 'It\'s time to read what is going on in the world! Today\'s top breakthrough facts.')
                                : (isHindiApp
                                    ? 'सोने से पहले आज की शीर्ष कहानियों और खोजों को 2 मिनट में जानें।'
                                    : 'Catch up on today\'s top discoveries before sleep.');

                            FactShotNotificationService().triggerRealMobileNotification(
                              title: title,
                              body: body,
                            );

                            GlassMessage.show(
                              context,
                              isHindiApp ? 'मोबाइल नोटिफिकेशन भेजा गया!' : 'Mobile notification sent to status bar!',
                            );
                          },
                          iconColor: const Color(0xFF10B981),
                        ),
                      ],
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
                            ? 'वीडियो स्वचालित रूप से प्रारंभ करें।'
                            : 'Start videos automatically when entering detail screen.',
                        value: state.autoplayEnabled,
                        onChanged: state.setAutoplayEnabled,
                        iconColor: const Color(0xFFEF4444),
                      ),
                      const _SettingsDivider(),
                      _ToggleTile(
                        icon: CupertinoIcons.rectangle_grid_1x2,
                        title: isHindiApp
                            ? 'होम फ़ीड व्यू बटन'
                            : 'Home Feed View Buttons',
                        subtitle: isHindiApp
                            ? 'होम फ़ीड में मोड चेंजर बटन (स्लाइड, ग्रिड, लिस्ट) दिखाएं या छिपाएं।'
                            : 'Show or hide mode buttons on the home feed. Slide mode is default for best experience.',
                        value: state.showFeedModeSelector,
                        onChanged: state.setShowFeedModeSelector,
                        iconColor: const Color(0xFF3B82F6),
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
                      _ThemeSelectorTile(
                        state: state,
                        iconColor: const Color(0xFFF59E0B),
                      ),
                      const _SettingsDivider(),
                      _ToggleTile(
                        icon: CupertinoIcons.slider_horizontal_3,
                        title: isHindiApp ? 'ब्लू टॉप बार' : 'Vibrant Blue Top Bar',
                        subtitle: isHindiApp
                            ? 'समीक्षा के लिए टॉप बार बैकग्राउंड को नीले रंग में स्विच करें।'
                            : 'Toggle the top bar background color between vibrant blue and glass for design review.',
                        value: state.useBlueTopBar,
                        onChanged: state.setUseBlueTopBar,
                        iconColor: const Color(0xFF1E88E5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: LiquidGlassTheme.space24),

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
                            ? 'आवाज के तीखेपन को समायोजित करें।'
                            : 'Adjust the highness or lowness of the voice pitch.',
                        value: state.voicePitch,
                        min: 0.5,
                        max: 2.0,
                        onChanged: state.setVoicePitch,
                        iconColor: const Color(0xFF10B981),
                      ),
                      const _SettingsDivider(),
                      _VoiceGenderSelectorTile(
                        state: state,
                        iconColor: const Color(0xFF8B5CF6),
                      ),
                      const _SettingsDivider(),
                      _ToggleTile(
                        icon: CupertinoIcons.app_badge,
                        title: isHindiApp ? 'सिमुलेशन रीडर' : 'Simulated Voice Reader',
                        subtitle: isHindiApp
                            ? 'टाइमर-आधारित पाठ पाठक का उपयोग करें।'
                            : 'Use simulated reader instead of native system speech engine.',
                        value: state.useTtsSimulation,
                        onChanged: state.setUseTtsSimulation,
                        iconColor: const Color(0xFF6366F1),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: LiquidGlassTheme.space24),

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
                            ? 'बटनों पर स्पर्श कंपन सक्षम करें।'
                            : 'Enable subtle tactile vibrations on button taps.',
                        value: state.hapticsEnabled,
                        onChanged: state.setHapticsEnabled,
                        iconColor: const Color(0xFF3B82F6),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: LiquidGlassTheme.space24),

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
                      if (state.isLoggedIn) ...[
                        const _SettingsDivider(),
                        _ActionTile(
                          icon: CupertinoIcons.square_arrow_right_fill,
                          title: AppTranslations.translate(context, 'logout'),
                          destructive: true,
                          onTap: () {
                            state.logout();
                            Navigator.of(context).pop();
                            GlassMessage.show(
                              context,
                              isHindiApp ? 'लॉगआउट किया गया' : 'Logged out',
                            );
                          },
                          iconColor: const Color(0xFFEF4444),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: LiquidGlassTheme.space24),

                // Diagnostics footer
                Center(
                  child: Text(
                    'FactShot v1.0.0 • Liquid Glass Edition',
                    style: LiquidGlassTheme.caption.copyWith(
                      color: LiquidGlassTheme.foregroundSoft,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      );
    },
  );
}

class _RemoveBackground extends StatelessWidget {
  const _RemoveBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(LiquidGlassTheme.radius24),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.transparent,
            LiquidGlassTheme.error.withValues(alpha: 0.24),
          ],
        ),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: LiquidGlassTheme.space20),
      child: Text(
        'Remove',
        style: LiquidGlassTheme.bodyStrong.copyWith(color: Colors.white),
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
    final isMobile = MediaQuery.of(context).size.width < 600;

    final headerRow = Row(
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
      ],
    );

    final control = SizedBox(
      width: isMobile ? double.infinity : null,
      child: CupertinoSlidingSegmentedControl<ThemeMode>(
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
    );

    if (isMobile) {
      return Padding(
        padding: const EdgeInsets.all(LiquidGlassTheme.space12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headerRow,
            const SizedBox(height: 12),
            control,
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(LiquidGlassTheme.space12),
        child: Row(
          children: [
            Expanded(child: headerRow),
            const SizedBox(width: 16),
            control,
          ],
        ),
      );
    }
  }
}

// ─── Voice Gender Selector Tile ───────────────────────────────
class _VoiceGenderSelectorTile extends StatelessWidget {
  const _VoiceGenderSelectorTile({required this.state, required this.iconColor});

  final AppState state;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final isHindi = state.appLanguage == 'Hindi';
    final isMobile = MediaQuery.of(context).size.width < 600;

    final headerRow = Row(
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
              CupertinoIcons.person_2_fill,
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
                isHindi ? 'आवाज का प्रकार' : 'Voice Gender',
                style: LiquidGlassTheme.bodyStrong.copyWith(
                  color: LiquidGlassTheme.foreground,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                isHindi
                    ? 'महिला या पुरुष आवाज प्रोफ़ाइल चुनें'
                    : 'Select Female or Male voice profile for audio narration',
                style: LiquidGlassTheme.caption.copyWith(
                  color: LiquidGlassTheme.foregroundSoft,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    final control = SizedBox(
      width: isMobile ? double.infinity : null,
      child: CupertinoSlidingSegmentedControl<String>(
        groupValue: state.voiceGender,
        thumbColor: Theme.of(
          context,
        ).colorScheme.primary.withValues(alpha: 0.2),
        children: {
          'Female': Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Text(
              isHindi ? 'महिला' : 'Female',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: LiquidGlassTheme.foreground,
              ),
            ),
          ),
          'Male': Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Text(
              isHindi ? 'पुरुष' : 'Male',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: LiquidGlassTheme.foreground,
              ),
            ),
          ),
        },
        onValueChanged: (gender) {
          if (gender != null) {
            HapticFeedback.selectionClick();
            state.setVoiceGender(gender);
          }
        },
      ),
    );

    if (isMobile) {
      return Padding(
        padding: const EdgeInsets.all(LiquidGlassTheme.space12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headerRow,
            const SizedBox(height: 12),
            control,
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(LiquidGlassTheme.space12),
        child: Row(
          children: [
            Expanded(child: headerRow),
            const SizedBox(width: 16),
            control,
          ],
        ),
      );
    }
  }
}

// ─── Font Size Selector Tile ─────────────────────────────────
class _FontSizeSelectorTile extends StatelessWidget {
  const _FontSizeSelectorTile({required this.state, required this.iconColor});

  final AppState state;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final isHindi = state.appLanguage == 'Hindi';
    final isMobile = MediaQuery.of(context).size.width < 600;

    final headerRow = Row(
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
                isHindi
                    ? 'लेख पाठ का आकार समायोजित करें'
                    : 'Adjust reader article text scaling',
                style: LiquidGlassTheme.caption.copyWith(
                  color: LiquidGlassTheme.foregroundSoft,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    final control = SizedBox(
      width: isMobile ? double.infinity : null,
      child: CupertinoSlidingSegmentedControl<double>(
        groupValue: state.fontSizeScale < 0.95
            ? 0.85
            : (state.fontSizeScale > 1.1 ? 1.2 : 1.0),
        thumbColor: Theme.of(
          context,
        ).colorScheme.primary.withValues(alpha: 0.2),
        children: {
          0.85: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Text(
              'S',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: LiquidGlassTheme.foreground,
              ),
            ),
          ),
          1.0: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Text(
              'M',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: LiquidGlassTheme.foreground,
              ),
            ),
          ),
          1.2: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Text(
              'L',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: LiquidGlassTheme.foreground,
              ),
            ),
          ),
        },
        onValueChanged: (scale) {
          if (scale != null) {
            HapticFeedback.selectionClick();
            state.setFontSizeScale(scale);
          }
        },
      ),
    );

    if (isMobile) {
      return Padding(
        padding: const EdgeInsets.all(LiquidGlassTheme.space12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headerRow,
            const SizedBox(height: 12),
            control,
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(LiquidGlassTheme.space12),
        child: Row(
          children: [
            Expanded(child: headerRow),
            const SizedBox(width: 16),
            control,
          ],
        ),
      );
    }
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
                    if (nameController.text.trim().isNotEmpty) {
                      state.setLoggedIn(true);
                    }
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
    final accent = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.all(LiquidGlassTheme.space12),
      child: Column(
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
                style: LiquidGlassTheme.bodyStrong.copyWith(color: accent),
              ),
            ],
          ),
          const SizedBox(height: 8),
          CupertinoSlider(
            value: value,
            min: min,
            max: max,
            activeColor: accent,
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
                    buildOption(
                      'English',
                      'English',
                      state.appLanguage,
                      () {
                        state.setAppLanguage('English');
                        setModalState(() {});
                      },
                    ),
                    const SizedBox(width: 10),
                    buildOption(
                      'हिंदी',
                      'Hindi',
                      state.appLanguage,
                      () {
                        state.setAppLanguage('Hindi');
                        setModalState(() {});
                      },
                    ),
                  ],
                ),

                const SizedBox(height: LiquidGlassTheme.space20),

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
                        state.setContentLanguage('English');
                        setModalState(() {});
                      },
                    ),
                    const SizedBox(width: 8),
                    buildOption(
                      'हिंदी',
                      'Hindi',
                      state.contentLanguage,
                      () {
                        state.setContentLanguage('Hindi');
                        setModalState(() {});
                      },
                    ),
                    const SizedBox(width: 8),
                    buildOption(
                      isHindiApp ? 'दोनों' : 'Both',
                      'Both',
                      state.contentLanguage,
                      () {
                        state.setContentLanguage('Both');
                        setModalState(() {});
                      },
                    ),
                  ],
                ),
                const SizedBox(height: LiquidGlassTheme.space20),
              ],
            ),
          );
        },
      );
    },
  );
}
