package com.example.tasknotifier

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.PowerManager
import android.provider.Settings
import android.net.Uri
import android.widget.Toast
import android.content.ComponentName
import android.content.pm.PackageManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "native_alarm"
    private val PREFS_NAME = "task_alarms"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Request all necessary permissions for OEM phones
        requestAllPermissions()

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "setAlarm" -> {
                    try {
                        val title = call.argument<String>("title") ?: ""
                        val desc = call.argument<String>("description") ?: ""
                        val timestamp = call.argument<Long>("timestamp")
                        val taskId = call.argument<String>("taskId") ?: ""

                        if (timestamp == null) {
                            result.error("INVALID_ARGUMENT", "Timestamp cannot be null", null)
                            return@setMethodCallHandler
                        }

                        val success = scheduleAlarm(title, desc, timestamp, taskId)
                        if (success) {
                            // Store alarm info for rescheduling after boot
                            storeAlarmInfo(taskId, title, desc, timestamp)
                            result.success(null)
                        } else {
                            result.error("ALARM_ERROR", "Failed to schedule alarm", null)
                        }
                    } catch (e: Exception) {
                        result.error("EXCEPTION", "Error scheduling alarm: ${e.message}", null)
                    }
                }
                "cancelAlarm" -> {
                    try {
                        val taskId = call.argument<String>("taskId") ?: ""
                        val success = cancelAlarm(taskId)
                        if (success) {
                            removeAlarmInfo(taskId)
                            result.success(null)
                        } else {
                            result.error("CANCEL_ERROR", "Failed to cancel alarm", null)
                        }
                    } catch (e: Exception) {
                        result.error("EXCEPTION", "Error canceling alarm: ${e.message}", null)
                    }
                }
                "rescheduleAlarms" -> {
                    try {
                        rescheduleStoredAlarms()
                        result.success(null)
                    } catch (e: Exception) {
                        result.error("EXCEPTION", "Error rescheduling alarms: ${e.message}", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun scheduleAlarm(title: String, desc: String, timestamp: Long, taskId: String): Boolean {
        return try {
            val intent = Intent(this, AlarmReceiver::class.java).apply {
                putExtra("task_title", title)
                putExtra("task_desc", desc)
                putExtra("task_id", taskId)
                putExtra("timestamp", timestamp)
            }

            // Use taskId hash for unique pending intent
            val requestCode = taskId.hashCode()
            val pendingIntent = PendingIntent.getBroadcast(
                this,
                requestCode,
                intent,
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
            )

            val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
            
            // Check if we can schedule exact alarms (Android 12+)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                if (!alarmManager.canScheduleExactAlarms()) {
                    // Request permission to schedule exact alarms
                    val intent = Intent(Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM)
                    startActivity(intent)
                    return false
                }
            }

            // Use different alarm types based on Android version and OEM
            when {
                Build.VERSION.SDK_INT >= Build.VERSION_CODES.M -> {
                    alarmManager.setExactAndAllowWhileIdle(
                        AlarmManager.RTC_WAKEUP,
                        timestamp,
                        pendingIntent
                    )
                }
                Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT -> {
                    alarmManager.setExact(
                        AlarmManager.RTC_WAKEUP,
                        timestamp,
                        pendingIntent
                    )
                }
                else -> {
                    alarmManager.set(
                        AlarmManager.RTC_WAKEUP,
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

    private fun cancelAlarm(taskId: String): Boolean {
        return try {
            val intent = Intent(this, AlarmReceiver::class.java)
            val requestCode = taskId.hashCode()
            val pendingIntent = PendingIntent.getBroadcast(
                this,
                requestCode,
                intent,
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_NO_CREATE
            )

            pendingIntent?.let {
                val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
                alarmManager.cancel(it)
                it.cancel()
            }
            true
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    private fun requestAllPermissions() {
        // Request battery optimization exemption
        requestBatteryOptimizationExemption()
        
        // Enable boot receiver
        enableBootReceiver()
        
        // Request autostart permission for OEM phones
        requestAutoStartPermission()
        
        // Request notification policy access
        requestNotificationPolicyAccess()
    }

    private fun requestBatteryOptimizationExemption() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val pm = getSystemService(Context.POWER_SERVICE) as PowerManager
            if (!pm.isIgnoringBatteryOptimizations(packageName)) {
                try {
                    val intent = Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS)
                    intent.data = Uri.parse("package:$packageName")
                    startActivity(intent)
                } catch (e: Exception) {
                    // Fallback to general battery optimization settings
                    val intent = Intent(Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS)
                    startActivity(intent)
                }
            }
        }
    }

    private fun enableBootReceiver() {
        val receiver = ComponentName(this, BootReceiver::class.java)
        packageManager.setComponentEnabledSetting(
            receiver,
            PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
            PackageManager.DONT_KILL_APP
        )
    }

    private fun requestAutoStartPermission() {
        // Different OEM manufacturers have different autostart settings
        val intents = listOf(
            // Xiaomi
            Intent().apply {
                component = ComponentName("com.miui.securitycenter", "com.miui.permcenter.autostart.AutoStartManagementActivity")
            },
            // Oppo
            Intent().apply {
                component = ComponentName("com.coloros.safecenter", "com.coloros.safecenter.permission.startup.StartupAppListActivity")
            },
            // Oppo (Alternative)
            Intent().apply {
                component = ComponentName("com.oppo.safe", "com.oppo.safe.permission.startup.StartupAppListActivity")
            },
            // Vivo
            Intent().apply {
                component = ComponentName("com.vivo.permissionmanager", "com.vivo.permissionmanager.activity.BgStartUpManagerActivity")
            },
            // Huawei
            Intent().apply {
                component = ComponentName("com.huawei.systemmanager", "com.huawei.systemmanager.startupmgr.ui.StartupNormalAppListActivity")
            },
            // Samsung
            Intent().apply {
                component = ComponentName("com.samsung.android.lool", "com.samsung.android.sm.battery.ui.BatteryActivity")
            },
            // Honor
            Intent().apply {
                component = ComponentName("com.hihonor.systemmanager", "com.hihonor.systemmanager.startupmgr.ui.StartupNormalAppListActivity")
            },
            // OnePlus
            Intent().apply {
                component = ComponentName("com.oneplus.security", "com.oneplus.security.chainlaunch.view.ChainLaunchAppListActivity")
            },
            // Infinix & Tecno
            Intent().apply {
                component = ComponentName("com.transsion.phonemanager", "com.transsion.phonemanager.module.appmanager.auto.AutoStartActivity")
            }
        )

        // Try to open the first available autostart manager
        for (intent in intents) {
            try {
                if (packageManager.resolveActivity(intent, PackageManager.MATCH_DEFAULT_ONLY) != null) {
                    startActivity(intent)
                    Toast.makeText(this, "Please enable autostart for this app", Toast.LENGTH_LONG).show()
                    break
                }
            } catch (e: Exception) {
                // Continue to next intent
            }
        }
    }

    private fun requestNotificationPolicyAccess() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as android.app.NotificationManager
            val sharedPrefs = getSharedPreferences("user_settings", Context.MODE_PRIVATE)
            val alreadyAsked = sharedPrefs.getBoolean("dnd_permission_asked", false)

            if (!notificationManager.isNotificationPolicyAccessGranted && !alreadyAsked) {
                val intent = Intent(Settings.ACTION_NOTIFICATION_POLICY_ACCESS_SETTINGS)
                startActivity(intent)

                sharedPrefs.edit().putBoolean("dnd_permission_asked", true).apply()
            }
        }
    }

    private fun storeAlarmInfo(taskId: String, title: String, desc: String, timestamp: Long) {
        val sharedPrefs = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val editor = sharedPrefs.edit()
        editor.putString("${taskId}_title", title)
        editor.putString("${taskId}_desc", desc)
        editor.putLong("${taskId}_timestamp", timestamp)
        editor.apply()
    }

    private fun removeAlarmInfo(taskId: String) {
        val sharedPrefs = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val editor = sharedPrefs.edit()
        editor.remove("${taskId}_title")
        editor.remove("${taskId}_desc")
        editor.remove("${taskId}_timestamp")
        editor.apply()
    }

    private fun rescheduleStoredAlarms() {
        val sharedPrefs = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
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
                scheduleAlarm(title, desc, timestamp, taskId)
            } else {
                // Remove expired alarms
                removeAlarmInfo(taskId)
            }
        }
    }
}