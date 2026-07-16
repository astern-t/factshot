import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum GlassMode { dark, tinted }

class AppState extends ChangeNotifier {
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
    if (themeIndex != null && themeIndex >= 0 && themeIndex < ThemeMode.values.length) {
      _themeMode = ThemeMode.values[themeIndex];
    }
    
    _hasCompletedOnboarding = _prefs?.getBool('onboardingComplete') ?? false;
    _appLanguage = _prefs?.getString('appLanguage') ?? 'English';
    _contentLanguage = _prefs?.getString('contentLanguage') ?? 'English';
    notifyListeners();
  }

  GlassMode _glassMode = GlassMode.tinted;
  bool _hasCompletedOnboarding = false;
  String _selectedLanguage = 'English';
  String _appLanguage = 'English';
  String _contentLanguage = 'English';
  ThemeMode _themeMode = ThemeMode.system;
  bool _notificationsEnabled = true;
  bool _offlineReadingEnabled = false;
  final Set<String> _bookmarkedIds = {'art-1', 'art-3'};
  final List<String> _recentSearches = <String>[
    'Gaganyaan-2',
    'Electric Vehicles',
    'Virtual Cinema',
  ];

  GlassMode get glassMode => _glassMode;
  bool get hasCompletedOnboarding => _hasCompletedOnboarding;
  String get selectedLanguage => _selectedLanguage;
  String get appLanguage => _appLanguage;
  String get contentLanguage => _contentLanguage;
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get offlineReadingEnabled => _offlineReadingEnabled;
  bool get isTintedMode => _glassMode == GlassMode.tinted;
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
