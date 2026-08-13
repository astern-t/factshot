import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class FactShotNotificationService {
  static final FactShotNotificationService _instance =
      FactShotNotificationService._internal();
  factory FactShotNotificationService() => _instance;

  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  FactShotNotificationService._internal() {
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    if (_isInitialized) return;

    try {
      tz.initializeTimeZones();
      try {
        final TimezoneInfo timezone = await FlutterTimezone.getLocalTimezone();
        tz.setLocalLocation(tz.getLocation(timezone.identifier));
      } catch (_) {
        try {
          tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));
        } catch (_) {
          tz.setLocalLocation(tz.UTC);
        }
      }

      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
          );

      const LinuxInitializationSettings linuxSettings =
          LinuxInitializationSettings(defaultActionName: 'Open Factshot');

      const InitializationSettings settings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
        linux: linuxSettings,
      );

      await _localNotificationsPlugin.initialize(
        settings: settings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          debugPrint("Mobile Notification tapped: ${response.payload}");
        },
      );

      if (!kIsWeb && Platform.isAndroid) {
        final androidImpl = _localNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
        await androidImpl?.requestNotificationsPermission();
      }

      _isInitialized = true;
    } catch (e) {
      debugPrint("Error initializing FlutterLocalNotificationsPlugin: $e");
    }
  }

  /// Prompts for notification permission on app launch until granted
  Future<bool> requestPermissionOnLaunch() async {
    await _initNotifications();
    if (kIsWeb) return true;

    try {
      if (Platform.isAndroid) {
        final androidImpl = _localNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
        final isGranted = await androidImpl?.areNotificationsEnabled() ?? false;
        if (!isGranted) {
          final granted = await androidImpl?.requestNotificationsPermission();
          return granted ?? false;
        }
        return true;
      } else if (Platform.isIOS) {
        final iosImpl = _localNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >();
        final granted = await iosImpl?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        return granted ?? false;
      }
    } catch (e) {
      debugPrint("Error requesting notification permissions: $e");
    }
    return true;
  }

  /// Sends an immediate REAL mobile system notification to the phone's status bar / notification tray!
  Future<void> triggerRealMobileNotification({
    required String title,
    required String body,
    int notificationId = 100,
  }) async {
    await _initNotifications();

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'factshot_daily_channel',
          'Daily World News Reminders',
          channelDescription:
              'Sends daily morning & night reminders to read global news',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'Factshot World News Alert',
          icon: '@mipmap/ic_launcher',
        );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(presentAlert: true, presentSound: true),
      linux: LinuxNotificationDetails(),
    );

    try {
      await _localNotificationsPlugin.show(
        id: notificationId,
        title: title,
        body: body,
        notificationDetails: platformDetails,
      );
    } catch (e) {
      debugPrint("Error displaying mobile notification: $e");
    }
  }

  /// Schedules daily morning (8:00 AM) and night (9:00 PM) native mobile notifications
  Future<void> scheduleDailyBriefings({
    required bool morningEnabled,
    required bool nightEnabled,
  }) async {
    await _initNotifications();
    try {
      await _localNotificationsPlugin.cancelAll();
    } catch (_) {}

    if (morningEnabled) {
      await _scheduleDailyAt(
        id: 888,
        hour: 8,
        minute: 0,
        title: "☀️ Morning Briefing: What is going on in the world",
        body:
            "Good morning! It's time to read today's top stories and breakthrough facts.",
      );
    }

    if (nightEnabled) {
      await _scheduleDailyAt(
        id: 999,
        hour: 21,
        minute: 0,
        title: "🌙 Nightly FactShot: Evening Digest",
        body:
            "Wrap up your day in 2 minutes! Catch up on today's top discoveries before sleep.",
      );
    }
  }

  Future<void> _scheduleDailyAt({
    required int id,
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    try {
      final now = tz.TZDateTime.now(tz.local);
      var scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'factshot_daily_channel',
            'Daily World News Reminders',
            channelDescription:
                'Sends daily morning & night reminders to read global news',
            importance: Importance.max,
            priority: Priority.high,
          );

      await _localNotificationsPlugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        notificationDetails: const NotificationDetails(
          android: androidDetails,
          iOS: DarwinNotificationDetails(),
          linux: LinuxNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e) {
      debugPrint("Error scheduling daily briefing: $e");
    }
  }
}
