import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum GlassMode { dark, tinted }

enum FeedMode { grid, slide, book, list }

class AppState extends ChangeNotifier {
  static final ValueNotifier<int> slideChangeNotifier = ValueNotifier<int>(0);
  static AppState? _instance;
  static AppState? get instance => _instance;

  SharedPreferences? _prefs;

  AppState() {
    _instance = this;
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();

    final themeIndex = _prefs?.getInt('themeMode');
    if (themeIndex != null &&
        themeIndex >= 0 &&
        themeIndex < ThemeMode.values.length) {
      _themeMode = ThemeMode.values[themeIndex];
    }

    _hasCompletedOnboarding = _prefs?.getBool('onboardingComplete') ?? false;
    _isLoggedIn = _prefs?.getBool('isLoggedIn') ?? false;
    _autoplayEnabled = _prefs?.getBool('autoplayEnabled') ?? true;
    _appLanguage = _prefs?.getString('appLanguage') ?? 'English';
    _contentLanguage = _prefs?.getString('contentLanguage') ?? 'English';
    _displayName = _prefs?.getString('displayName') ?? 'Guest';
    _email = _prefs?.getString('email') ?? '';

    final feedModeIndex = _prefs?.getInt('feedMode');
    if (feedModeIndex != null &&
        feedModeIndex >= 0 &&
        feedModeIndex < FeedMode.values.length) {
      _feedMode = FeedMode.values[feedModeIndex];
    }

    _voicePitch = _prefs?.getDouble('voicePitch') ?? 1.0;
    _voiceGender = _prefs?.getString('voiceGender') ?? 'Female';

    double defaultScale = 1.0;
    try {
      final views = WidgetsBinding.instance.platformDispatcher.views;
      if (views.isNotEmpty) {
        final view = views.first;
        final size = view.physicalSize / view.devicePixelRatio;
        if (size.width < 600) {
          defaultScale = 0.85;
        }
      }
    } catch (_) {}

    _fontSizeScale = _prefs?.getDouble('fontSizeScale') ?? defaultScale;
    _hapticsEnabled = _prefs?.getBool('hapticsEnabled') ?? true;
    _useTtsSimulation = _prefs?.getBool('useTtsSimulation') ?? false;
    _useBlueTopBar = _prefs?.getBool('useBlueTopBar') ?? false;
    _showFeedModeSelector = _prefs?.getBool('showFeedModeSelector') ?? true;
    _savedViewMode = _prefs?.getString('savedViewMode') ?? 'list';
    _voiceGender = _prefs?.getString('voiceGender') ?? 'Female';
    _morningNotificationEnabled =
        _prefs?.getBool('morningNotificationEnabled') ?? true;
    _morningTime = _prefs?.getString('morningTime') ?? '08:00 AM';
    _nightNotificationEnabled =
        _prefs?.getBool('nightNotificationEnabled') ?? true;
    _nightTime = _prefs?.getString('nightTime') ?? '09:00 PM';

    _isInitialized = true;
    notifyListeners();
  }

  GlassMode _glassMode = GlassMode.tinted;
  bool _isInitialized = false;
  bool _hasCompletedOnboarding = false;
  bool _isLoggedIn = false;
  String _selectedLanguage = 'English';
  String _appLanguage = 'English';
  String _contentLanguage = 'English';
  String _displayName = 'Guest';
  String _email = '';
  ThemeMode _themeMode = ThemeMode.system;
  FeedMode _feedMode = FeedMode.slide;
  bool _notificationsEnabled = true;
  bool _offlineReadingEnabled = false;
  bool _autoplayEnabled = true;

  // Voice & Accessibility Settings
  double _voicePitch = 1.0;
  String _voiceGender = 'Female';
  double _fontSizeScale = 1.0;
  bool _hapticsEnabled = true;
  bool _useTtsSimulation = false;
  bool _useBlueTopBar = false;
  bool _showFeedModeSelector = true;
  String _savedViewMode = 'list';
  bool _morningNotificationEnabled = true;
  String _morningTime = '08:00 AM';
  bool _nightNotificationEnabled = true;
  String _nightTime = '09:00 PM';

  final Set<String> _bookmarkedIds = {'art-1', 'art-3'};
  final List<String> _recentSearches = <String>[
    'Gaganyaan-2',
    'Electric Vehicles',
    'Virtual Cinema',
  ];

  GlassMode get glassMode => _glassMode;
  bool get isInitialized => _isInitialized;
  bool get hasCompletedOnboarding => _hasCompletedOnboarding;
  bool get isLoggedIn => _isLoggedIn;
  String get selectedLanguage => _selectedLanguage;
  String get appLanguage => _appLanguage;
  String get contentLanguage => _contentLanguage;
  String get displayName => _displayName;
  String get email => _email;
  ThemeMode get themeMode => _themeMode;
  FeedMode get feedMode => _feedMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isSystemTheme => _themeMode == ThemeMode.system;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get offlineReadingEnabled => _offlineReadingEnabled;
  bool get autoplayEnabled => _autoplayEnabled;
  bool get isTintedMode => _glassMode == GlassMode.tinted;

  // Voice & Accessibility Getters
  double get voicePitch => _voicePitch;
  String get voiceGender => _voiceGender;
  double get fontSizeScale => _fontSizeScale;
  bool get hapticsEnabled => _hapticsEnabled;
  bool get useTtsSimulation => _useTtsSimulation;
  bool get useBlueTopBar => _useBlueTopBar;
  bool get showFeedModeSelector => _showFeedModeSelector;
  String get savedViewMode => _savedViewMode;
  bool get morningNotificationEnabled => _morningNotificationEnabled;
  String get morningTime => _morningTime;
  bool get nightNotificationEnabled => _nightNotificationEnabled;
  String get nightTime => _nightTime;

  UnmodifiableSetView<String> get bookmarkedIds =>
      UnmodifiableSetView<String>(_bookmarkedIds);
  UnmodifiableListView<String> get recentSearches =>
      UnmodifiableListView<String>(_recentSearches);

  Color get accentColor => const Color(0xFF5AB2FF);

  double get glassOpacity => switch (_glassMode) {
    GlassMode.dark => 0.14,
    GlassMode.tinted => 0.18,
  };

  double get accentTintOpacity => switch (_glassMode) {
    GlassMode.dark => 0.04,
    GlassMode.tinted => 0.09,
  };

  double get blurSigma => 26.0;

  void setGlassMode(GlassMode value) {
    if (_glassMode == value) {
      return;
    }
    _glassMode = value;
    notifyListeners();
  }

  void setFeedMode(FeedMode value) {
    if (_feedMode == value) {
      return;
    }
    _feedMode = value;
    _prefs?.setInt('feedMode', value.index);
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _displayName = 'Guest';
    _email = '';
    _prefs?.setBool('isLoggedIn', false);
    _prefs?.setString('displayName', 'Guest');
    _prefs?.setString('email', '');
    notifyListeners();
  }

  void setLoggedIn(bool value) {
    if (_isLoggedIn == value) {
      return;
    }
    _isLoggedIn = value;
    _prefs?.setBool('isLoggedIn', value);
    notifyListeners();
  }

  void setOnboardingComplete() {
    if (_hasCompletedOnboarding) {
      return;
    }
    _hasCompletedOnboarding = true;
    _prefs?.setBool('onboardingComplete', true);
    notifyListeners();
  }

  void setAppLanguage(String value) {
    if (_appLanguage == value) {
      return;
    }
    _appLanguage = value;
    _prefs?.setString('appLanguage', value);
    notifyListeners();
  }

  void setContentLanguage(String value) {
    if (_contentLanguage == value) {
      return;
    }
    _contentLanguage = value;
    _prefs?.setString('contentLanguage', value);
    notifyListeners();
  }

  void setSelectedLanguage(String value) {
    if (_selectedLanguage == value) {
      return;
    }
    _selectedLanguage = value;
    _appLanguage = value;
    _contentLanguage = value;
    _prefs?.setString('appLanguage', value);
    _prefs?.setString('contentLanguage', value);
    notifyListeners();
  }

  void setUseBlueTopBar(bool value) {
    if (_useBlueTopBar == value) {
      return;
    }
    _useBlueTopBar = value;
    _prefs?.setBool('useBlueTopBar', value);
    notifyListeners();
  }

  void setShowFeedModeSelector(bool value) {
    if (_showFeedModeSelector == value) {
      return;
    }
    _showFeedModeSelector = value;
    _prefs?.setBool('showFeedModeSelector', value);
    notifyListeners();
  }

  void setSavedViewMode(String value) {
    if (_savedViewMode == value) {
      return;
    }
    _savedViewMode = value;
    _prefs?.setString('savedViewMode', value);
    notifyListeners();
  }

  void setMorningNotificationEnabled(bool value) {
    if (_morningNotificationEnabled == value) return;
    _morningNotificationEnabled = value;
    _prefs?.setBool('morningNotificationEnabled', value);
    notifyListeners();
  }

  void setMorningTime(String value) {
    if (_morningTime == value) return;
    _morningTime = value;
    _prefs?.setString('morningTime', value);
    notifyListeners();
  }

  void setNightNotificationEnabled(bool value) {
    if (_nightNotificationEnabled == value) return;
    _nightNotificationEnabled = value;
    _prefs?.setBool('nightNotificationEnabled', value);
    notifyListeners();
  }

  void setNightTime(String value) {
    if (_nightTime == value) return;
    _nightTime = value;
    _prefs?.setString('nightTime', value);
    notifyListeners();
  }

  void setThemeMode(ThemeMode value) {
    if (_themeMode == value) {
      return;
    }
    _themeMode = value;
    _prefs?.setInt('themeMode', value.index);
    notifyListeners();
  }

  void toggleBookmark(String articleId) {
    if (_bookmarkedIds.contains(articleId)) {
      _bookmarkedIds.remove(articleId);
    } else {
      _bookmarkedIds.add(articleId);
    }
    notifyListeners();
  }

  bool isBookmarked(String articleId) => _bookmarkedIds.contains(articleId);

  void addRecentSearch(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return;
    }
    _recentSearches.remove(trimmed);
    _recentSearches.insert(0, trimmed);
    if (_recentSearches.length > 5) {
      _recentSearches.removeLast();
    }
    notifyListeners();
  }

  void clearRecentSearches() {
    if (_recentSearches.isEmpty) {
      return;
    }
    _recentSearches.clear();
    notifyListeners();
  }

  void setNotificationsEnabled(bool value) {
    if (_notificationsEnabled == value) {
      return;
    }
    _notificationsEnabled = value;
    notifyListeners();
  }

  void setOfflineReadingEnabled(bool value) {
    if (_offlineReadingEnabled == value) {
      return;
    }
    _offlineReadingEnabled = value;
    notifyListeners();
  }

  void setAutoplayEnabled(bool value) {
    if (_autoplayEnabled == value) {
      return;
    }
    _autoplayEnabled = value;
    _prefs?.setBool('autoplayEnabled', value);
    notifyListeners();
  }

  void setDisplayName(String value) {
    final trimmed = value.trim();
    if (_displayName == trimmed || trimmed.isEmpty) {
      return;
    }
    _displayName = trimmed;
    _prefs?.setString('displayName', trimmed);
    notifyListeners();
  }

  void setEmail(String value) {
    final trimmed = value.trim();
    if (_email == trimmed) {
      return;
    }
    _email = trimmed;
    _prefs?.setString('email', trimmed);
    notifyListeners();
  }

  void setVoicePitch(double value) {
    if (_voicePitch == value) {
      return;
    }
    _voicePitch = value;
    _prefs?.setDouble('voicePitch', value);
    notifyListeners();
  }

  void setVoiceGender(String value) {
    if (_voiceGender == value) {
      return;
    }
    _voiceGender = value;
    _prefs?.setString('voiceGender', value);
    notifyListeners();
  }

  void setFontSizeScale(double value) {
    if (_fontSizeScale == value) {
      return;
    }
    _fontSizeScale = value;
    _prefs?.setDouble('fontSizeScale', value);
    notifyListeners();
  }

  void setHapticsEnabled(bool value) {
    if (_hapticsEnabled == value) {
      return;
    }
    _hapticsEnabled = value;
    _prefs?.setBool('hapticsEnabled', value);
    notifyListeners();
  }

  void setUseTtsSimulation(bool value) {
    if (_useTtsSimulation == value) {
      return;
    }
    _useTtsSimulation = value;
    _prefs?.setBool('useTtsSimulation', value);
    notifyListeners();
  }
}

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
    : super(notifier: state);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope not found in context');
    return scope!.notifier!;
  }
}
