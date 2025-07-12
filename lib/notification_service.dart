// File: services/notification_service.dart
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tasknotifier/native_alarm_service.dart';
import 'package:tasknotifier/task.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  static final NotificationService instance = NotificationService._internal();
  factory NotificationService() => instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final ValueNotifier<Set<String>> overdueTaskIds = ValueNotifier<Set<String>>(
    {},
  );

  Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) async {
        final payload = response.payload;
        print('Notification tapped: $payload');
      },
    );

    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestExactAlarmsPermission();

    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  NotificationDetails _buildNotificationDetails(Task task) {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'task_channel',
        'Task Notifications',
        channelDescription: 'Regular task notifications',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
      ),
      iOS: DarwinNotificationDetails(
        sound: 'default.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  Future<void> scheduleNotification(Task task) async {
    final int id = task.id.hashCode;
    final DateTime now = DateTime.now();
    DateTime scheduleTime = task.time;
    final NotificationDetails details = _buildNotificationDetails(task);

    // NEW: Schedule Native Android Alarm
    await NativeAlarmService.scheduleNativeAlarm(
      title: task.name,
      description: task.description,
      time: task.time,
    );

    if (task.repeat == 'none') {
      if (scheduleTime.isBefore(now)) {
        await _scheduleOverdueNotification(task);
        return;
      }

      await notificationsPlugin.zonedSchedule(
        id,
        task.name,
        task.description,
        tz.TZDateTime.from(scheduleTime, tz.local),
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: task.id,
      );
    } else {
      RepeatInterval interval =
          task.repeat == 'daily' ? RepeatInterval.daily : RepeatInterval.weekly;

      await notificationsPlugin.periodicallyShow(
        id,
        task.name,
        task.description,
        interval,
        details,
        payload: task.id,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    }
  }

  Future<void> _scheduleOverdueNotification(Task task) async {
    overdueTaskIds.value = {...overdueTaskIds.value, task.id};

    await notificationsPlugin.show(
      task.id.hashCode,
      '⏰ ${task.name}',
      'This task is overdue: ${task.description}',
      _buildNotificationDetails(task),
      payload: task.id,
    );

    await _scheduleRecurringOverdueNotifications(task);
  }

  Future<void> _scheduleRecurringOverdueNotifications(Task task) async {
    for (int i = 1; i <= 12; i++) {
      await notificationsPlugin.cancel(task.id.hashCode + i);
    }

    for (int i = 1; i <= 12; i++) {
      final scheduleTime = DateTime.now().add(Duration(minutes: i * 5));

      await notificationsPlugin.zonedSchedule(
        task.id.hashCode + i,
        '⏰ ${task.name} (Reminder $i)',
        'This task is still overdue: ${task.description}',
        tz.TZDateTime.from(scheduleTime, tz.local),
        _buildNotificationDetails(task),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: task.id,
      );
    }
  }

  Future<void> markTaskAsDone(String taskId) async {
    overdueTaskIds.value = {...overdueTaskIds.value..remove(taskId)};
    await cancelTaskNotifications(taskId);
  }

  Future<void> cancelTaskNotifications(String taskId) async {
    await notificationsPlugin.cancel(taskId.hashCode);
    for (int i = 1; i <= 12; i++) {
      await notificationsPlugin.cancel(taskId.hashCode + i);
    }
  }

  Future<void> cancelNotification(String taskId) async {
    await cancelTaskNotifications(taskId);
  }

  Future<void> cancelAll() async {
    overdueTaskIds.value = {};
    await notificationsPlugin.cancelAll();
  }

  Future<void> checkAndScheduleOverdueTasks(List<Task> tasks) async {
    final now = DateTime.now();

    for (final task in tasks) {
      if (!task.isDone && task.time.isBefore(now)) {
        if (!overdueTaskIds.value.contains(task.id)) {
          await _scheduleOverdueNotification(task);
        }
      } else if (task.isDone && overdueTaskIds.value.contains(task.id)) {
        await markTaskAsDone(task.id);
      }
    }
  }

  Future<void> listPending() async {
    final pending = await notificationsPlugin.pendingNotificationRequests();
    print('Pending notifications: ${pending.length}');
    for (var n in pending) {
      print('ID: ${n.id}, Title: ${n.title}');
    }
  }

  Future<void> listActive() async {
    final active = await notificationsPlugin.getActiveNotifications();
    print('Active notifications: ${active.length}');
    for (var n in active) {
      print('ID: ${n.id}, Title: ${n.title}');
    }
  }
}
