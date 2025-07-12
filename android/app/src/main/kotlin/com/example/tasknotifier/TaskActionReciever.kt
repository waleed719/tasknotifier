package com.example.tasknotifier

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import androidx.core.app.NotificationManagerCompat

class TaskActionReceiver : BroadcastReceiver() {
    
    override fun onReceive(context: Context, intent: Intent) {
        val taskId = intent.getStringExtra("task_id") ?: return
        
        when (intent.action) {
            "MARK_DONE" -> {
                // Cancel the notification
                val notificationId = taskId.hashCode()
                val notificationManager = NotificationManagerCompat.from(context)
                notificationManager.cancel(notificationId)
                
                // Cancel any pending reminder alarms
                cancelReminderAlarms(context, taskId)
                
                // You can also send a broadcast to your Flutter app to update the task status
                val broadcastIntent = Intent("com.example.tasknotifier.TASK_MARKED_DONE")
                broadcastIntent.putExtra("task_id", taskId)
                context.sendBroadcast(broadcastIntent)
            }
        }
    }
    
    private fun cancelReminderAlarms(context: Context, taskId: String) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as android.app.AlarmManager
        
        // Cancel all reminder alarms for this task
        for (i in 1..5) {
            val reminderIntent = Intent(context, AlarmReceiver::class.java)
            val reminderPendingIntent = android.app.PendingIntent.getBroadcast(
                context,
                taskId.hashCode() + i,
                reminderIntent,
                android.app.PendingIntent.FLAG_IMMUTABLE or android.app.PendingIntent.FLAG_NO_CREATE
            )
            
            reminderPendingIntent?.let {
                alarmManager.cancel(it)
                it.cancel()
            }
        }
    }
}