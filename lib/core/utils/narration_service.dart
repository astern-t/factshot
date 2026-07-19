import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:factshot/app/app_state.dart';

enum NarrationState { stopped, playing, paused }

class NarrationService extends ChangeNotifier {
  static final NarrationService _instance = NarrationService._internal();
  factory NarrationService() => _instance;

  NarrationService._internal() {
    _initTts();
  }

  late final FlutterTts _flutterTts;
  bool _isTtsAvailable = false;

  NarrationState _state = NarrationState.stopped;
  double _progress = 0.0;
  double _speedMultiplier = 1.0;
  String _currentLangCode = 'en-US';
  String? _currentArticleId;
  String _textToSpeak = '';

  // Simulation timer to drive UI progress (essential for Linux and simulated fallbacks)
  Timer? _simulationTimer;
  int _simulationCharacterIndex = 0;
  int _utteranceStartIndex = 0;
  bool _isInternalUpdating = false;
  bool _expectingNativeCancel = false;

  NarrationState get state => _state;
  bool get isPlaying => _state == NarrationState.playing;
  bool get isPaused => _state == NarrationState.paused;
  bool get isStopped => _state == NarrationState.stopped;
  double get progress => _progress;
  double get speedMultiplier => _speedMultiplier;
  String get currentLangCode => _currentLangCode;
  String? get currentArticleId => _currentArticleId;

  bool get _isNativeTtsActive => _isTtsAvailable && !(AppState.instance?.useTtsSimulation ?? false);

  void _initTts() {
    if (Platform.isLinux) {
      _isTtsAvailable = false;
      return;
    }

    _flutterTts = FlutterTts();

    try {
      _flutterTts.setStartHandler(() {
        _isInternalUpdating = false;
        _expectingNativeCancel = false;
        _state = NarrationState.playing;
        notifyListeners();
      });

      _flutterTts.setCompletionHandler(() {
        if (_isInternalUpdating || _expectingNativeCancel) {
          _expectingNativeCancel = false;
          debugPrint("TTS completion ignored due to internal update or expected cancel");
          return;
        }
        _state = NarrationState.stopped;
        _progress = 1.0;
        _cancelSimulation();
        notifyListeners();
      });

      _flutterTts.setErrorHandler((msg) {
        if (_isInternalUpdating) {
          _isInternalUpdating = false;
          _expectingNativeCancel = false;
          debugPrint("TTS error ignored due to internal update: $msg");
          _fallbackToSimulation();
          return;
        }
        debugPrint("TTS error: $msg");
        _fallbackToSimulation();
      });

      _flutterTts.setCancelHandler(() {
        if (_isInternalUpdating || _expectingNativeCancel) {
          _expectingNativeCancel = false;
          debugPrint("TTS cancel ignored due to internal update or expected cancel");
          return;
        }
        _state = NarrationState.stopped;
        _progress = 0.0;
        _cancelSimulation();
        notifyListeners();
      });

      _flutterTts.setPauseHandler(() {
        _state = NarrationState.paused;
        notifyListeners();
      });

      _flutterTts.setContinueHandler(() {
        _state = NarrationState.playing;
        notifyListeners();
      });

      _flutterTts.setProgressHandler((String text, int start, int end, String word) {
        if (_textToSpeak.isNotEmpty) {
          final absoluteStart = _utteranceStartIndex + start;
          _simulationCharacterIndex = absoluteStart;
          _progress = (absoluteStart / _textToSpeak.length).clamp(0.0, 1.0);
          notifyListeners();
        }
      });

      _isTtsAvailable = true;
    } catch (e) {
      debugPrint("Failed to initialize native TTS: $e. Fallback simulation will be used.");
      _isTtsAvailable = false;
    }
  }

  double _getSpeechRate() {
    if (_speedMultiplier == 0.75) return 0.38;
    if (_speedMultiplier == 1.0) return 0.50;
    if (_speedMultiplier == 1.25) return 0.62;
    if (_speedMultiplier == 1.5) return 0.75;
    if (_speedMultiplier == 2.0) return 0.90;
    return 0.50;
  }

  double get estimatedDurationSeconds {
    if (_textToSpeak.isEmpty) return 0.0;
    final baseCharsPerSec = _currentLangCode.startsWith('hi') ? 12 : 16;
    final charsPerSecond = baseCharsPerSec * _speedMultiplier;
    return _textToSpeak.length / charsPerSecond;
  }

  double get estimatedElapsedSeconds {
    if (_textToSpeak.isEmpty) return 0.0;
    final baseCharsPerSec = _currentLangCode.startsWith('hi') ? 12 : 16;
    final charsPerSecond = baseCharsPerSec * _speedMultiplier;
    return _simulationCharacterIndex / charsPerSecond;
  }

  Future<void> speak({
    required String articleId,
    required String text,
    required String language, // 'English' or 'Hindi' or 'Both'
  }) async {
    if (_currentArticleId == articleId && _state == NarrationState.paused) {
      return resume();
    }

    await stop();

    _currentArticleId = articleId;
    _textToSpeak = text;
    _progress = 0.0;
    _simulationCharacterIndex = 0;
    _utteranceStartIndex = 0;
    _currentLangCode = (language == 'Hindi') ? 'hi-IN' : 'en-US';
    notifyListeners();

    if (Platform.isLinux) {
      try {
        final spdLang = (language == 'Hindi') ? 'hi' : 'en';
        int spdRate = 0;
        if (_speedMultiplier == 0.75) spdRate = -25;
        if (_speedMultiplier == 1.25) spdRate = 25;
        if (_speedMultiplier == 1.5) spdRate = 50;
        if (_speedMultiplier == 2.0) spdRate = 80;

        // Fire process call to run the system Speech Dispatcher (native audio synthesis on Linux)
        await Process.run('spd-say', [
          '-l', spdLang,
          '-r', spdRate.toString(),
          text,
        ]);
        
        _state = NarrationState.playing;
        notifyListeners();
        _startSimulation();
      } catch (e) {
        debugPrint("Error playing narration on Linux: $e");
        _fallbackToSimulation();
      }
      return;
    }

    if (_isNativeTtsActive) {
      try {
        final List<dynamic>? languages = await _flutterTts.getLanguages;
        if (languages != null && languages.isNotEmpty) {
          final targetPrefix = (language == 'Hindi') ? 'hi' : 'en';
          final matched = languages.firstWhere(
            (l) => l.toString().toLowerCase().startsWith(targetPrefix),
            orElse: () => (language == 'Hindi') ? 'hi-IN' : 'en-US',
          );
          _currentLangCode = matched.toString();
        }

        await _flutterTts.setLanguage(_currentLangCode);
        await _flutterTts.setSpeechRate(_getSpeechRate());
        await _flutterTts.setVolume(1.0);
        final pitch = AppState.instance?.voicePitch ?? 1.0;
        await _flutterTts.setPitch(pitch);

        final result = await _flutterTts.speak(text);
        final isSuccess = result == 1 || result == true;
        if (!isSuccess) {
          _fallbackToSimulation();
        } else {
          _state = NarrationState.playing;
          notifyListeners();
        }
      } catch (e) {
        debugPrint("Error calling speak: $e");
        _fallbackToSimulation();
      }
    } else {
      _fallbackToSimulation();
    }
  }

  Future<void> stop() async {
    _cancelSimulation();
    _currentArticleId = null;
    _progress = 0.0;
    _simulationCharacterIndex = 0;
    _utteranceStartIndex = 0;
    _state = NarrationState.stopped;
    _isInternalUpdating = false;
    _expectingNativeCancel = false;
    notifyListeners();

    if (Platform.isLinux) {
      try {
        await Process.run('spd-say', ['-S']);
      } catch (e) {
        debugPrint("Error stopping spd-say: $e");
      }
      return;
    }

    if (_isTtsAvailable) {
      try {
        await _flutterTts.stop();
      } catch (e) {
        debugPrint("Error stopping TTS: $e");
      }
    }
  }

  Future<void> pause() async {
    if (_state != NarrationState.playing) return;

    if (Platform.isLinux) {
      try {
        await Process.run('spd-say', ['-p']);
        _cancelSimulation();
        _state = NarrationState.paused;
        notifyListeners();
      } catch (e) {
        debugPrint("Error pausing spd-say: $e");
      }
      return;
    }

    if (_simulationTimer != null) {
      _simulationTimer?.cancel();
      _state = NarrationState.paused;
      notifyListeners();
      return;
    }

    if (_isNativeTtsActive) {
      try {
        final result = await _flutterTts.pause();
        final isSuccess = result == 1 || result == true;
        if (isSuccess) {
          _state = NarrationState.paused;
          notifyListeners();
        } else {
          await stop();
        }
      } catch (e) {
        debugPrint("Error pausing TTS: $e");
        await stop();
      }
    } else {
      _state = NarrationState.paused;
      notifyListeners();
    }
  }

  Future<void> resume() async {
    if (_state != NarrationState.paused) return;

    if (Platform.isLinux) {
      try {
        await Process.run('spd-say', ['-e']);
        _state = NarrationState.playing;
        notifyListeners();
        _startSimulation(fromIndex: _simulationCharacterIndex);
      } catch (e) {
        debugPrint("Error resuming spd-say: $e");
      }
      return;
    }

    if (_textToSpeak.isNotEmpty && _simulationTimer == null && !_isNativeTtsActive) {
      _startSimulation(fromIndex: _simulationCharacterIndex);
      return;
    }

    if (_isNativeTtsActive) {
      try {
        _isInternalUpdating = true;
        _utteranceStartIndex = _simulationCharacterIndex;
        final pitch = AppState.instance?.voicePitch ?? 1.0;
        await _flutterTts.setPitch(pitch);
        final result = await _flutterTts.speak(_textToSpeak.substring(_simulationCharacterIndex));
        final isSuccess = result == 1 || result == true;
        if (isSuccess) {
          _state = NarrationState.playing;
          notifyListeners();
        } else {
          _isInternalUpdating = false;
          _startSimulation(fromIndex: _simulationCharacterIndex);
        }
      } catch (e) {
        _isInternalUpdating = false;
        debugPrint("Error resuming TTS: $e");
        _startSimulation(fromIndex: _simulationCharacterIndex);
      }
    } else {
      _startSimulation(fromIndex: _simulationCharacterIndex);
    }
  }

  void setSpeed(double multiplier) {
    if (_speedMultiplier == multiplier) return;
    _speedMultiplier = multiplier;
    notifyListeners();

    if (_state == NarrationState.playing) {
      if (Platform.isLinux) {
        _restartSpdSayWithNewRate();
        return;
      }

      if (_isNativeTtsActive) {
        _isInternalUpdating = true;
        _expectingNativeCancel = true;
        _flutterTts.stop().then((_) async {
          await Future.delayed(const Duration(milliseconds: 150));
          final remainingIndex = _simulationCharacterIndex;
          _utteranceStartIndex = remainingIndex;
          if (remainingIndex < _textToSpeak.length) {
            await _flutterTts.setSpeechRate(_getSpeechRate());
            final pitch = AppState.instance?.voicePitch ?? 1.0;
            await _flutterTts.setPitch(pitch);
            await _flutterTts.speak(_textToSpeak.substring(remainingIndex));
          } else {
            _isInternalUpdating = false;
            _expectingNativeCancel = false;
            _progress = 1.0;
            await stop();
          }
        });
      }
      if (_simulationTimer != null) {
        _simulationTimer?.cancel();
        _startSimulation(fromIndex: _simulationCharacterIndex);
      }
    }
  }

  Future<void> seek(double progress) async {
    if (_textToSpeak.isEmpty) return;
    
    final targetProgress = progress.clamp(0.0, 1.0);
    _progress = targetProgress;
    _simulationCharacterIndex = (targetProgress * _textToSpeak.length).toInt();
    notifyListeners();

    if (_state == NarrationState.playing) {
      if (Platform.isLinux) {
        _restartSpdSayWithNewRate();
      } else if (_isNativeTtsActive) {
        _isInternalUpdating = true;
        _expectingNativeCancel = true;
        try {
          await _flutterTts.stop();
          await Future.delayed(const Duration(milliseconds: 150));
          final remainingText = _textToSpeak.substring(_simulationCharacterIndex);
          _utteranceStartIndex = _simulationCharacterIndex;
          if (remainingText.isNotEmpty) {
            await _flutterTts.setLanguage(_currentLangCode);
            await _flutterTts.setSpeechRate(_getSpeechRate());
            final pitch = AppState.instance?.voicePitch ?? 1.0;
            await _flutterTts.setPitch(pitch);
            await _flutterTts.speak(remainingText);
          } else {
            _isInternalUpdating = false;
            _expectingNativeCancel = false;
            _progress = 1.0;
            await stop();
          }
        } catch (e) {
          _isInternalUpdating = false;
          _expectingNativeCancel = false;
          debugPrint("Error seeking native TTS: $e");
        }
      } else {
        _startSimulation(fromIndex: _simulationCharacterIndex);
      }
    } else {
      if (_simulationTimer != null) {
        _cancelSimulation();
      }
    }
  }

  Future<void> skip(int seconds) async {
    if (_textToSpeak.isEmpty) return;
    
    final baseCharsPerSec = _currentLangCode.startsWith('hi') ? 12 : 16;
    final charsPerSecond = baseCharsPerSec * _speedMultiplier;
    final charOffset = (seconds * charsPerSecond).round();
    
    final targetIndex = (_simulationCharacterIndex + charOffset).clamp(0, _textToSpeak.length);
    final targetProgress = targetIndex / _textToSpeak.length;
    
    await seek(targetProgress);
  }

  Future<void> _restartSpdSayWithNewRate() async {
    try {
      await Process.run('spd-say', ['-S']);
      
      final language = _currentLangCode.startsWith('hi') ? 'Hindi' : 'English';
      final spdLang = (language == 'Hindi') ? 'hi' : 'en';
      int spdRate = 0;
      if (_speedMultiplier == 0.75) spdRate = -25;
      if (_speedMultiplier == 1.25) spdRate = 25;
      if (_speedMultiplier == 1.5) spdRate = 50;
      if (_speedMultiplier == 2.0) spdRate = 80;

      final remainingText = _textToSpeak.substring(_simulationCharacterIndex);
      _utteranceStartIndex = _simulationCharacterIndex;
      if (remainingText.isNotEmpty) {
        await Process.run('spd-say', [
          '-l', spdLang,
          '-r', spdRate.toString(),
          remainingText,
        ]);
        _startSimulation(fromIndex: _simulationCharacterIndex);
      }
    } catch (e) {
      debugPrint("Error resetting Linux speed: $e");
    }
  }

  void _fallbackToSimulation() {
    debugPrint("Starting simulated narration fallback.");
    _simulationCharacterIndex = (_progress * _textToSpeak.length).toInt();
    _startSimulation(fromIndex: _simulationCharacterIndex);
  }

  void _startSimulation({int fromIndex = 0}) {
    _cancelSimulation();
    _state = NarrationState.playing;
    _simulationCharacterIndex = fromIndex;
    notifyListeners();

    final baseCharsPerSec = _currentLangCode.startsWith('hi') ? 12 : 16;
    final charsPerSecond = baseCharsPerSec * _speedMultiplier;
    final intervalMs = (1000 / charsPerSecond).round();

    _simulationTimer = Timer.periodic(Duration(milliseconds: intervalMs), (timer) {
      if (_textToSpeak.isEmpty) {
        stop();
        return;
      }

      _simulationCharacterIndex += 1;
      if (_simulationCharacterIndex >= _textToSpeak.length) {
        _progress = 1.0;
        stop();
      } else {
        _progress = _simulationCharacterIndex / _textToSpeak.length;
        notifyListeners();
      }
    });
  }

  void _cancelSimulation() {
    _simulationTimer?.cancel();
    _simulationTimer = null;
  }

  @override
  void dispose() {
    _cancelSimulation();
    if (Platform.isLinux) {
      Process.run('spd-say', ['-S']);
    } else if (_isTtsAvailable) {
      _flutterTts.stop();
    }
    super.dispose();
  }
}
