import 'dart:collection';

import 'package:flutter/material.dart';

enum AccentTheme { blue, amber }

enum GlassMode { dark, tinted }

class AppState extends ChangeNotifier {
  AppState();

  AccentTheme _accentTheme = AccentTheme.blue;
  GlassMode _glassMode = GlassMode.tinted;
  bool _hasCompletedOnboarding = false;
  bool _notificationsEnabled = true;
  bool _offlineReadingEnabled = false;
  final Set<String> _bookmarkedIds = {'art-1', 'art-3'};
  final List<String> _recentSearches = <String>[
    'Gaganyaan-2',
    'Electric Vehicles',
    'Virtual Cinema',
  ];

  AccentTheme get accentTheme => _accentTheme;
  GlassMode get glassMode => _glassMode;
  bool get hasCompletedOnboarding => _hasCompletedOnboarding;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get offlineReadingEnabled => _offlineReadingEnabled;
  bool get isTintedMode => _glassMode == GlassMode.tinted;
  UnmodifiableSetView<String> get bookmarkedIds =>
      UnmodifiableSetView<String>(_bookmarkedIds);
  UnmodifiableListView<String> get recentSearches =>
      UnmodifiableListView<String>(_recentSearches);

  Color get accentColor => switch (_accentTheme) {
    AccentTheme.blue => const Color(0xFF5AB2FF),
    AccentTheme.amber => const Color(0xFFFFB347),
  };

  double get glassOpacity => switch (_glassMode) {
    GlassMode.dark => 0.14,
    GlassMode.tinted => 0.18,
  };

  double get accentTintOpacity => switch (_glassMode) {
    GlassMode.dark => 0.04,
    GlassMode.tinted => 0.09,
  };

  double get blurSigma => 26.0;

  void setAccentTheme(AccentTheme value) {
    if (_accentTheme == value) {
      return;
    }
    _accentTheme = value;
    notifyListeners();
  }

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
