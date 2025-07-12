import 'package:flutter/services.dart';

class NativeAlarmService {
  static const MethodChannel _channel = MethodChannel('native_alarm');

  static Future<void> scheduleNativeAlarm({
    required String title,
    required String description,
    required DateTime time,
  }) async {
    await _channel.invokeMethod('setAlarm', {
      "title": title,
      "description": description,
      "timestamp": time.millisecondsSinceEpoch,
    });
  }
}
