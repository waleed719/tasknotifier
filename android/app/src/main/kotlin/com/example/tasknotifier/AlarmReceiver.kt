package com.example.tasknotifier

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.media.AudioAttributes
import android.media.RingtoneManager
import android.os.Build
import android.os.PowerManager
import android.os.Vibrator
import android.os.VibratorManager
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat

class AlarmReceiver : BroadcastReceiver() {
    companion object {
        const val CHANNEL_ID = "task_channel"
        const val CHANNEL_NAME = "Task Notifications"
        const val OVERDUE_CHANNEL_ID = "overdue_task_channel"
        const val OVERDUE_CHANNEL_NAME = "Overdue Task Notifications"
    }

    override fun onReceive(context: Context, intent: Intent) {
        // Acquire wake lock to ensure processing completes
        val powerManager = context.getSystemService(Context.POWER_SERVICE) as PowerManager
        val wakeLock = powerManager.newWakeLock(
            PowerManager.PARTIAL_WAKE_LOCK,
            "TaskNotifier:AlarmReceiver"
        )
        wakeLock.acquire(10000) // 10 seconds max

        try {
            // Create notification channels
            createNotificationChannels(context)
            
            // Get task details
            val title = intent.getStringExtra("task_title") ?: "Task Reminder"
            val desc = intent.getStringExtra("task_desc") ?: "You have a task due."
            val taskId = intent.getStringExtra("task_id") ?: ""
            val timestamp = intent.getLongExtra("timestamp", 0L)
            
            // Check if task is overdue
            val isOverdue = System.currentTimeMillis() > timestamp
            
            // Create and show notification
            showNotification(context, title, desc, taskId, isOverdue)
            
            // Schedule overdue reminders if task is overdue
            if (isOverdue) {
                scheduleOverdueReminders(context, title, desc, taskId)
            }
            
        } finally {
            wakeLock.release()
        }
    }
    
    private fun createNotificationChannels(context: Context) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            
            // Regular task channel
            val taskChannel = NotificationChannel(
                CHANNEL_ID,
                CHANNEL_NAME,
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = "Shows task reminder notifications"
                enableVibration(true)
                vibrationPattern = longArrayOf(0, 1000, 500, 1000)
                setSound(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM), 
                    AudioAttributes.Builder()
                        .setUsage(AudioAttributes.USAGE_ALARM)
                        .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                        .build())
            }
            
            // Overdue task channel
            val overdueChannel = NotificationChannel(
                OVERDUE_CHANNEL_ID,
                OVERDUE_CHANNEL_NAME,
                NotificationManager.IMPORTANCE_MAX
            ).apply {
                description = "Shows overdue task notifications"
                enableVibration(true)
                vibrationPattern = longArrayOf(0, 1000, 500, 1000, 500, 1000)
                setSound(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM), 
                    AudioAttributes.Builder()
                        .setUsage(AudioAttributes.USAGE_ALARM)
                        .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                        .build())
            }
            
            notificationManager.createNotificationChannel(taskChannel)
            notificationManager.createNotificationChannel(overdueChannel)
        }
    }
    
    private fun showNotification(context: Context, title: String, desc: String, taskId: String, isOverdue: Boolean) {
        val notificationId = taskId.hashCode()
        val channelId = if (isOverdue) OVERDUE_CHANNEL_ID else CHANNEL_ID
        
        // Create intent to open app when notification is tapped
        val appIntent = Intent(context, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
            putExtra("task_id", taskId)
        }
        
        val pendingIntent = PendingIntent.getActivity(
            context,
            notificationId,
            appIntent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )
        
        // Create "Mark as Done" action
        val doneIntent = Intent(context, TaskActionReceiver::class.java).apply {
            action = "MARK_DONE"
            putExtra("task_id", taskId)
        }
        
        val donePendingIntent = PendingIntent.getBroadcast(
            context,
            notificationId + 1000,
            doneIntent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )
        
        // Build notification
        val notificationBuilder = NotificationCompat.Builder(context, channelId)
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .setContentTitle(if (isOverdue) "⏰ OVERDUE: $title" else title)
            .setContentText(desc)
            .setStyle(NotificationCompat.BigTextStyle().bigText(desc))
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setCategory(NotificationCompat.CATEGORY_REMINDER)
            .setAutoCancel(true)
            .setContentIntent(pendingIntent)
            .addAction(android.R.drawable.ic_menu_delete, "Mark as Done", donePendingIntent)
            .setOngoing(isOverdue) // Make overdue notifications persistent
            .setDefaults(NotificationCompat.DEFAULT_ALL)
        
        // Add custom vibration for overdue tasks
        if (isOverdue) {
            notificationBuilder.setVibrate(longArrayOf(0, 1000, 500, 1000, 500, 1000))
        }
        
        // Show notification
        val notificationManager = NotificationManagerCompat.from(context)
        try {
            notificationManager.notify(notificationId, notificationBuilder.build())
            
            // Additional vibration for critical tasks
            if (isOverdue) {
                vibrate(context)
            }
        } catch (e: SecurityException) {
            // Handle case where notification permission is not granted
            e.printStackTrace()
        }
    }
    
    private fun vibrate(context: Context) {
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                val vibratorManager = context.getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as VibratorManager
                val vibrator = vibratorManager.defaultVibrator
                vibrator.vibrate(android.os.VibrationEffect.createWaveform(longArrayOf(0, 1000, 500, 1000), -1))
            } else {
                @Suppress("DEPRECATION")
                val vibrator = context.getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    vibrator.vibrate(android.os.VibrationEffect.createWaveform(longArrayOf(0, 1000, 500, 1000), -1))
                } else {
                    @Suppress("DEPRECATION")
                    vibrator.vibrate(longArrayOf(0, 1000, 500, 1000), -1)
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
    
    private fun scheduleOverdueReminders(context: Context, title: String, desc: String, taskId: String) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as android.app.AlarmManager
        
        // Schedule up to 5 reminder notifications at 5-minute intervals
        for (i in 1..5) {
            val reminderTime = System.currentTimeMillis() + (i * 5 * 60 * 1000) // 5 minutes intervals
            val reminderIntent = Intent(context, AlarmReceiver::class.java).apply {
                putExtra("task_title", "REMINDER $i: $title")
                putExtra("task_desc", "Still overdue: $desc")
                putExtra("task_id", taskId)
                putExtra("timestamp", reminderTime)
            }
            
            val reminderPendingIntent = PendingIntent.getBroadcast(
                context,
                taskId.hashCode() + i,
                reminderIntent,
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
            )
            
            try {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    alarmManager.setExactAndAllowWhileIdle(
                        android.app.AlarmManager.RTC_WAKEUP,
                        reminderTime,
                        reminderPendingIntent
                    )
                } else {
                    alarmManager.setExact(
                        android.app.AlarmManager.RTC_WAKEUP,
                        reminderTime,
                        reminderPendingIntent
                    )
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }
}