package com.example.tasknotifier

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.PowerManager
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel

class BootReceiver : BroadcastReceiver() {
    companion object {
        const val CHANNEL = "native_alarm"
        const val PREFS_NAME = "task_alarms"
    }
    
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == Intent.ACTION_BOOT_COMPLETED || 
            intent.action == Intent.ACTION_MY_PACKAGE_REPLACED ||
            intent.action == Intent.ACTION_PACKAGE_REPLACED) {
            
            // Acquire wake lock to ensure processing completes
            val powerManager = context.getSystemService(Context.POWER_SERVICE) as PowerManager
            val wakeLock = powerManager.newWakeLock(
                PowerManager.PARTIAL_WAKE_LOCK,
                "TaskNotifier:BootReceiver"
            )
            wakeLock.acquire(30000) // 30 seconds max
            
            try {
                rescheduleAlarms(context)
            } finally {
                wakeLock.release()
            }
        }
    }
    
    private fun rescheduleAlarms(context: Context) {
        try {
            val sharedPrefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            val allEntries = sharedPrefs.all
            val taskIds = mutableSetOf<String>()

            // Extract unique task IDs
            for (key in allEntries.keys) {
                if (key.endsWith("_title")) {
                    taskIds.add(key.substring(0, key.length - 6))
                }
            }

            // Reschedule each alarm
            for (taskId in taskIds) {
                val title = sharedPrefs.getString("${taskId}_title", "") ?: ""
                val desc = sharedPrefs.getString("${taskId}_desc", "") ?: ""
                val timestamp = sharedPrefs.getLong("${taskId}_timestamp", 0)

                if (timestamp > System.currentTimeMillis()) {
                    scheduleAlarm(context, title, desc, timestamp, taskId)
                } else {
                    // Remove expired alarms
                    removeAlarmInfo(context, taskId)
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
    
    private fun scheduleAlarm(context: Context, title: String, desc: String, timestamp: Long, taskId: String): Boolean {
        return try {
            val alarmIntent = Intent(context, AlarmReceiver::class.java).apply {
                putExtra("task_title", title)
                putExtra("task_desc", desc)
                putExtra("task_id", taskId)
                putExtra("timestamp", timestamp)
            }

            val requestCode = taskId.hashCode()
            val pendingIntent = android.app.PendingIntent.getBroadcast(
                context,
                requestCode,
                alarmIntent,
                android.app.PendingIntent.FLAG_IMMUTABLE or android.app.PendingIntent.FLAG_UPDATE_CURRENT
            )

            val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as android.app.AlarmManager
            
            // Use appropriate alarm method based on Android version
            when {
                android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.M -> {
                    alarmManager.setExactAndAllowWhileIdle(
                        android.app.AlarmManager.RTC_WAKEUP,
                        timestamp,
                        pendingIntent
                    )
                }
                android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.KITKAT -> {
                    alarmManager.setExact(
                        android.app.AlarmManager.RTC_WAKEUP,
                        timestamp,
                        pendingIntent
                    )
                }
                else -> {
                    alarmManager.set(
                        android.app.AlarmManager.RTC_WAKEUP,
                        timestamp,
                        pendingIntent
                    )
                }
            }
            true
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }
    
    private fun removeAlarmInfo(context: Context, taskId: String) {
        val sharedPrefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val editor = sharedPrefs.edit()
        editor.remove("${taskId}_title")
        editor.remove("${taskId}_desc")
        editor.remove("${taskId}_timestamp")
        editor.apply()
    }
}