// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   tz.initializeTimeZones(); // Important for zonedSchedule
//   runApp(const MyApp());
// }

// @pragma('vm:entry-point')
// void notificationTapBackground(NotificationResponse notificationResponse) {
//   print('notification background callback');
//   if (notificationResponse.payload != null) {
//     print('Notification payload: ${notificationResponse.payload}');
//   }
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Task Manager',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const TaskListScreen(),
//     );
//   }
// }

// class Task {
//   final String id;
//   String name;
//   String description;
//   String? link;
//   DateTime time;
//   String repeat;
//   bool isDone;

//   Task({
//     required this.id,
//     required this.name,
//     required this.description,
//     this.link,
//     required this.time,
//     required this.repeat,
//     this.isDone = false,
//   });

//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'name': name,
//     'description': description,
//     'link': link,
//     'time': time.toIso8601String(),
//     'repeat': repeat,
//     'isDone': isDone,
//   };

//   factory Task.fromJson(Map<String, dynamic> json) => Task(
//     id: json['id'] as String,
//     name: json['name'] as String,
//     description: json['description'] as String,
//     link: json['link'] as String?,
//     time: DateTime.parse(json['time'] as String),
//     repeat: json['repeat'] as String,
//     isDone: json['isDone'] as bool,
//   );

//   Task copyWith({
//     String? id,
//     String? name,
//     String? description,
//     String? link,
//     DateTime? time,
//     String? repeat,
//     bool? isDone,
//   }) {
//     return Task(
//       id: id ?? this.id,
//       name: name ?? this.name,
//       description: description ?? this.description,
//       link: link ?? this.link,
//       time: time ?? this.time,
//       repeat: repeat ?? this.repeat,
//       isDone: isDone ?? this.isDone,
//     );
//   }
// }

// class NotificationService {
//   static final NotificationService _notificationService =
//       NotificationService._internal();
//   factory NotificationService() => _notificationService;
//   NotificationService._internal();

//   final FlutterLocalNotificationsPlugin _notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   Future<void> init() async {
//     try {
//       print('Notification service initializing...');

//       const AndroidInitializationSettings initializationSettingsAndroid =
//           AndroidInitializationSettings('@mipmap/ic_launcher');

//       const DarwinInitializationSettings initializationSettingsIOS =
//           DarwinInitializationSettings(
//             requestAlertPermission: true,
//             requestBadgePermission: true,
//             requestSoundPermission: true,
//           );

//       final InitializationSettings initializationSettings =
//           InitializationSettings(
//             android: initializationSettingsAndroid,
//             iOS: initializationSettingsIOS,
//           );

//       await _notificationsPlugin.initialize(
//         initializationSettings,
//         onDidReceiveNotificationResponse: (NotificationResponse response) {
//           print('Notification clicked with payload: ${response.payload}');
//         },
//         onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
//       );

//       await _requestPermissions();
//       await _createNotificationChannel();

//       print('Notification service initialized successfully');
//     } catch (e) {
//       print('Error initializing notification service: $e');
//       rethrow;
//     }
//   }

//   Future<void> _requestPermissions() async {
//     final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
//         _notificationsPlugin
//             .resolvePlatformSpecificImplementation<
//               AndroidFlutterLocalNotificationsPlugin
//             >();

//     if (androidImplementation != null) {
//       print('Requesting notification permission...');
//       final bool? grantedNotifications =
//           await androidImplementation.requestNotificationsPermission();
//       print('Android notification permission result: $grantedNotifications');

//       final bool? hasPermission =
//           await androidImplementation.areNotificationsEnabled();
//       print('Actually has notification permission: $hasPermission');

//       if (hasPermission != true) {
//         print('❌ CRITICAL: Notification permission not actually granted!');
//         print(
//           'Please manually enable notifications in Settings > Apps > Your App > Notifications',
//         );
//       }

//       final bool? grantedExactAlarms =
//           await androidImplementation.requestExactAlarmsPermission();
//       print('Android exact alarm permission: $grantedExactAlarms');

//       final bool? hasExactAlarmPermission =
//           await androidImplementation.canScheduleExactNotifications();
//       print('Can schedule exact notifications: $hasExactAlarmPermission');

//       if (hasExactAlarmPermission != true) {
//         print('❌ CRITICAL: Exact alarm permission not granted!');
//         print(
//           'Please enable in Settings > Apps > Your App > Set alarms and reminders',
//         );
//       }
//     }

//     final IOSFlutterLocalNotificationsPlugin? iosImplementation =
//         _notificationsPlugin
//             .resolvePlatformSpecificImplementation<
//               IOSFlutterLocalNotificationsPlugin
//             >();

//     if (iosImplementation != null) {
//       final bool? granted = await iosImplementation.requestPermissions(
//         alert: true,
//         badge: true,
//         sound: true,
//       );
//       print('iOS notification permission: $granted');
//     }
//   }

//   Future<void> _createNotificationChannel() async {
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'task_channel',
//       'Task Notifications',
//       description: 'Notifications for your tasks',
//       importance: Importance.max,
//       playSound: true,
//       enableVibration: true,
//       showBadge: true,
//     );

//     final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
//         _notificationsPlugin
//             .resolvePlatformSpecificImplementation<
//               AndroidFlutterLocalNotificationsPlugin
//             >();

//     if (androidImplementation != null) {
//       await androidImplementation.createNotificationChannel(channel);
//       print('Notification channel created successfully');
//     }
//   }

//   Future<void> scheduleNotification(Task task) async {
//     try {
//       final int notificationId = task.id.hashCode;
//       final DateTime now = DateTime.now();
//       DateTime scheduledDateTime = task.time;

//       final NotificationDetails notificationDetails = const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'task_channel',
//           'Task Notifications',
//           channelDescription: 'Notifications for your tasks',
//           importance: Importance.max,
//           priority: Priority.high,
//           playSound: true,
//           enableVibration: true,
//         ),
//         iOS: DarwinNotificationDetails(
//           presentAlert: true,
//           presentBadge: true,
//           presentSound: true,
//           interruptionLevel: InterruptionLevel.active,
//         ),
//       );

//       if (task.repeat == 'none') {
//         if (scheduledDateTime.isBefore(now)) {
//           print('❌ Task time is in the past for non-repeating task.');
//           return;
//         }

//         await _notificationsPlugin.zonedSchedule(
//           notificationId,
//           task.name,
//           task.description,
//           tz.TZDateTime.from(scheduledDateTime, tz.local),
//           notificationDetails,
//           androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,

//           payload: task.id,
//         );
//         print('✅ One-time notification scheduled');
//       } else {
//         RepeatInterval repeatInterval;
//         if (task.repeat == 'daily') {
//           repeatInterval = RepeatInterval.daily;
//         } else if (task.repeat == 'weekly') {
//           repeatInterval = RepeatInterval.weekly;
//         } else {
//           print('❌ Invalid repeat interval');
//           return;
//         }

//         await _notificationsPlugin.periodicallyShow(
//           notificationId,
//           task.name,
//           task.description,
//           repeatInterval,
//           notificationDetails,
//           payload: task.id,
//           androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//         );
//         print('✅ Repeating notification scheduled (${task.repeat})');
//       }

//       await _scheduleTestNotification(task.name);
//     } catch (e, s) {
//       print('❌ Error scheduling notification: $e');
//       print('Stack trace: $s');
//     }
//   }

//   Future<void> test10sNotification() async {
//     final DateTime scheduleTime = DateTime.now().add(
//       const Duration(seconds: 10),
//     );
//     await _notificationsPlugin.zonedSchedule(
//       123,
//       'Hello!',
//       'This will fire in 10 seconds!',
//       tz.TZDateTime.from(scheduleTime, tz.local),
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'task_channel',
//           'Tasks',
//           channelDescription: 'task notification',
//           importance: Importance.max,
//           priority: Priority.high,
//         ),
//       ),
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//       payload: 'test_payload',
//     );
//     print('✅ 10s test notification scheduled.');
//   }

//   Future<void> _scheduleTestNotification(String taskName) async {
//     try {
//       final DateTime testTime = DateTime.now().add(const Duration(seconds: 10));

//       await _notificationsPlugin.zonedSchedule(
//         99999, // Test ID
//         'Test Notification',
//         'If you see this, notifications are working! Task: $taskName',
//         tz.TZDateTime.from(testTime, tz.local),
//         const NotificationDetails(
//           android: AndroidNotificationDetails(
//             'task_channel',
//             'Task Notifications',
//             channelDescription: 'Test notification',
//             importance: Importance.max,
//             priority: Priority.high,
//             playSound: true,
//             enableVibration: true,
//           ),
//           iOS: DarwinNotificationDetails(
//             presentAlert: true,
//             presentBadge: true,
//             presentSound: true,
//           ),
//         ),
//         androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//         payload: 'test_payload',
//       );
//       print('📱 Test notification scheduled for 10 seconds from now');
//     } catch (e) {
//       print('❌ Error scheduling test notification: $e');
//     }
//   }

//   Future<void> showImmediateNotification(String title, String body) async {
//     try {
//       await _notificationsPlugin.show(
//         999,
//         title,
//         body,
//         const NotificationDetails(
//           android: AndroidNotificationDetails(
//             'task_channel',
//             'Task Notifications',
//             channelDescription: 'Immediate notification',
//             importance: Importance.max,
//             priority: Priority.high,
//             playSound: true,
//             enableVibration: true,
//           ),
//           iOS: DarwinNotificationDetails(
//             presentAlert: true,
//             presentBadge: true,
//             presentSound: true,
//           ),
//         ),
//       );
//       print('✅ Immediate notification shown');
//     } catch (e) {
//       print('❌ Error showing immediate notification: $e');
//     }
//   }

//   Future<void> cancelNotification(String taskId) async {
//     try {
//       await _notificationsPlugin.cancel(taskId.hashCode);
//       print('Notification canceled for task ID: $taskId');
//     } catch (e) {
//       print('Error canceling notification: $e');
//     }
//   }

//   Future<void> cancelAllNotifications() async {
//     try {
//       await _notificationsPlugin.cancelAll();
//       print('All notifications canceled');
//     } catch (e) {
//       print('Error canceling all notifications: $e');
//     }
//   }

//   Future<void> listPendingNotifications() async {
//     try {
//       final List<PendingNotificationRequest> pendingNotifications =
//           await _notificationsPlugin.pendingNotificationRequests();

//       print('=== PENDING NOTIFICATIONS ===');
//       if (pendingNotifications.isEmpty) {
//         print('No pending notifications found');
//       } else {
//         for (final notification in pendingNotifications) {
//           print(
//             'ID: ${notification.id}, Title: ${notification.title}, Body: ${notification.body}',
//           );
//         }
//       }
//       print('=============================');
//     } catch (e) {
//       print('Error listing pending notifications: $e');
//     }
//   }
// }

// class TaskListScreen extends StatefulWidget {
//   const TaskListScreen({super.key});

//   @override
//   State<TaskListScreen> createState() => _TaskListScreenState();
// }

// class _TaskListScreenState extends State<TaskListScreen> {
//   List<Task> _tasks = [];
//   final NotificationService _notificationService = NotificationService();
//   late SharedPreferences _prefs;

//   @override
//   void initState() {
//     super.initState();
//     _initializeNotificationsAndLoadTasks();
//   }

//   Future<void> _initializeNotificationsAndLoadTasks() async {
//     try {
//       await _notificationService.init();
//       await _checkPermissionStatus();
//       await _notificationService.showImmediateNotification(
//         'Notification Test',
//         'If you see this, notifications are working!',
//       );
//       print('✅ Notifications initialized successfully');

//       _prefs = await SharedPreferences.getInstance();
//       await _loadTasksFromStorage();
//     } catch (e) {
//       print('❌ Error initializing notifications or loading tasks: $e');
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Setup failed: $e'),
//             backgroundColor: Colors.red,
//             duration: const Duration(seconds: 5),
//           ),
//         );
//       }
//     }
//   }

//   Future<void> _checkPermissionStatus() async {
//     final NotificationService service = NotificationService();
//     final plugin = service._notificationsPlugin;

//     final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
//         plugin
//             .resolvePlatformSpecificImplementation<
//               AndroidFlutterLocalNotificationsPlugin
//             >();

//     if (androidImplementation != null) {
//       final bool? hasNotificationPermission =
//           await androidImplementation.areNotificationsEnabled();
//       final bool? hasExactAlarmPermission =
//           await androidImplementation.canScheduleExactNotifications();

//       print('=== PERMISSION STATUS CHECK ===');
//       print('Has notification permission: $hasNotificationPermission');
//       print('Has exact alarm permission: $hasExactAlarmPermission');

//       if (hasNotificationPermission != true ||
//           hasExactAlarmPermission != true) {
//         if (mounted) {
//           showDialog(
//             context: context,
//             builder:
//                 (context) => AlertDialog(
//                   title: const Text('Permissions Required'),
//                   content: const Text(
//                     'This app needs notification permissions to work properly.\n\n'
//                     'Please go to Settings > Apps > Task Manager > Notifications and enable all permissions.\n\n'
//                     'Also enable "Set alarms and reminders" in Special access.',
//                   ),
//                   actions: [
//                     TextButton(
//                       onPressed: () => Navigator.pop(context),
//                       child: const Text('OK'),
//                     ),
//                   ],
//                 ),
//           );
//         }
//       }
//     }
//   }

//   Future<void> _saveTasksToStorage() async {
//     final String tasksJson = jsonEncode(
//       _tasks.map((task) => task.toJson()).toList(),
//     );
//     await _prefs.setString('tasks', tasksJson);
//     print('Tasks saved to storage.');
//   }

//   Future<void> _loadTasksFromStorage() async {
//     final String? tasksJson = _prefs.getString('tasks');
//     if (tasksJson != null) {
//       final List<dynamic> decodedList = jsonDecode(tasksJson);
//       setState(() {
//         _tasks = decodedList.map((json) => Task.fromJson(json)).toList();
//       });
//       print('Tasks loaded from storage: ${_tasks.length} tasks.');

//       await _notificationService.cancelAllNotifications();
//       print('All previous notifications cancelled before rescheduling.');

//       for (var task in _tasks) {
//         if (!task.isDone) {
//           await _notificationService.scheduleNotification(task);
//         }
//       }
//       await _notificationService.listPendingNotifications();
//     } else {
//       print('No tasks found in storage.');
//     }
//   }

//   void _addTask(Task task) {
//     setState(() {
//       int existingIndex = _tasks.indexWhere((t) => t.id == task.id);
//       if (existingIndex != -1) {
//         _notificationService.cancelNotification(task.id);
//         _tasks[existingIndex] = task;
//       } else {
//         _tasks.add(task);
//       }
//     });
//     _notificationService.scheduleNotification(task);
//     _saveTasksToStorage();
//   }

//   void _markTaskAsDone(Task task) {
//     setState(() {
//       task.isDone = true;
//     });
//     _notificationService.cancelNotification(task.id);

//     if (task.repeat != 'none') {
//       DateTime newTime = task.time;
//       if (task.repeat == 'daily') {
//         newTime = newTime.add(const Duration(days: 1));
//       } else if (task.repeat == 'weekly') {
//         newTime = newTime.add(const Duration(days: 7));
//       }

//       final newTask = Task(
//         id: '${task.id}_${newTime.millisecondsSinceEpoch}',
//         name: task.name,
//         description: task.description,
//         link: task.link,
//         time: newTime,
//         repeat: task.repeat,
//         isDone: false,
//       );
//       _addTask(newTask);
//     }
//     _saveTasksToStorage();
//   }

//   void _deleteTask(Task task) {
//     setState(() {
//       _tasks.removeWhere((t) => t.id == task.id);
//     });
//     _notificationService.cancelNotification(task.id);
//     _saveTasksToStorage();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Task Manager'),
//         iconTheme: const IconThemeData(color: Colors.black),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.bug_report),
//             onPressed: () async {
//               await _notificationService.listPendingNotifications();
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.notification_add),
//             onPressed: () async {
//               await _notificationService.showImmediateNotification(
//                 'Test Notification',
//                 'This is a test notification triggered manually',
//               );
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.clear_all),
//             onPressed: () async {
//               setState(() {
//                 _tasks.clear();
//               });
//               await _notificationService.cancelAllNotifications();
//               await _saveTasksToStorage();
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text('All tasks and notifications cleared!'),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body:
//           _tasks.isEmpty
//               ? Column(
//                 children: [
//                   const Center(
//                     child: Text(
//                       'No tasks yet! Add a new task using the + button.',
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () async {
//                       await NotificationService().test10sNotification();
//                     },
//                     child: const Text('Test 10s Notification'),
//                   ),
//                 ],
//               )
//               : ListView.builder(
//                 itemCount: _tasks.length,
//                 itemBuilder: (context, index) {
//                   final task = _tasks[index];
//                   return Dismissible(
//                     key: Key(task.id),
//                     direction: DismissDirection.endToStart,
//                     background: Container(
//                       color: Colors.red,
//                       alignment: Alignment.centerRight,
//                       padding: const EdgeInsets.symmetric(horizontal: 20),
//                       child: const Icon(Icons.delete, color: Colors.white),
//                     ),
//                     onDismissed: (direction) {
//                       _deleteTask(task);
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('${task.name} deleted')),
//                       );
//                     },
//                     child: ListTile(
//                       title: Text(
//                         task.name,
//                         style: TextStyle(
//                           decoration:
//                               task.isDone ? TextDecoration.lineThrough : null,
//                           color: task.isDone ? Colors.grey : Colors.black,
//                         ),
//                       ),
//                       subtitle: Text(
//                         '${task.description}\n${DateFormat('MMM d, HH:mm').format(task.time)}'
//                         '\nRepeat: ${task.repeat == 'none' ? 'None' : task.repeat}',
//                         style: TextStyle(
//                           decoration:
//                               task.isDone ? TextDecoration.lineThrough : null,
//                           color: task.isDone ? Colors.grey : Colors.black54,
//                         ),
//                       ),
//                       trailing:
//                           task.isDone
//                               ? const Icon(
//                                 Icons.check_circle,
//                                 color: Colors.green,
//                               )
//                               : ElevatedButton(
//                                 onPressed: () => _markTaskAsDone(task),
//                                 child: const Text('Done'),
//                               ),
//                       onTap: () async {
//                         final updatedTask = await Navigator.push<Task>(
//                           context,
//                           MaterialPageRoute(
//                             builder:
//                                 (context) => TaskCreationScreen(
//                                   onTaskCreated: _addTask,
//                                   existingTask: task,
//                                 ),
//                           ),
//                         );
//                         if (updatedTask != null && updatedTask.id == task.id) {
//                           _addTask(updatedTask);
//                         }
//                       },
//                     ),
//                   );
//                 },
//               ),
//       floatingActionButton: FloatingActionButton(
//         onPressed:
//             () => Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder:
//                     (context) => TaskCreationScreen(onTaskCreated: _addTask),
//               ),
//             ),
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

// class TaskCreationScreen extends StatefulWidget {
//   final Function(Task) onTaskCreated;
//   final Task? existingTask;

//   const TaskCreationScreen({
//     super.key,
//     required this.onTaskCreated,
//     this.existingTask,
//   });

//   @override
//   State<TaskCreationScreen> createState() => _TaskCreationScreenState();
// }

// class _TaskCreationScreenState extends State<TaskCreationScreen> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _nameController;
//   late TextEditingController _descriptionController;
//   late TextEditingController _linkController;
//   late DateTime _selectedTime;
//   late String _repeat;

//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController(
//       text: widget.existingTask?.name ?? '',
//     );
//     _descriptionController = TextEditingController(
//       text: widget.existingTask?.description ?? '',
//     );
//     _linkController = TextEditingController(
//       text: widget.existingTask?.link ?? '',
//     );

//     if (widget.existingTask != null) {
//       _selectedTime = widget.existingTask!.time;
//     } else {
//       _selectedTime = DateTime.now().add(const Duration(minutes: 1));
//       _selectedTime = _selectedTime.copyWith(second: 0, millisecond: 0);
//     }

//     _repeat = widget.existingTask?.repeat ?? 'none';
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _descriptionController.dispose();
//     _linkController.dispose();
//     super.dispose();
//   }

//   Future<void> _selectTime(BuildContext context) async {
//     final DateTime initialDatePickerDate =
//         _selectedTime.isBefore(DateTime.now()) ? DateTime.now() : _selectedTime;

//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: initialDatePickerDate,
//       firstDate: DateTime.now().subtract(const Duration(days: 365)),
//       lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
//     );

//     if (pickedDate != null && mounted) {
//       final TimeOfDay? pickedTime = await showTimePicker(
//         context: context,
//         initialTime: TimeOfDay.fromDateTime(_selectedTime),
//       );

//       if (pickedTime != null) {
//         setState(() {
//           _selectedTime = DateTime(
//             pickedDate.year,
//             pickedDate.month,
//             pickedDate.day,
//             pickedTime.hour,
//             pickedTime.minute,
//           );

//           if (_selectedTime.isBefore(DateTime.now()) && _repeat == 'none') {
//             _selectedTime = _selectedTime.add(const Duration(days: 1));
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text(
//                   'Selected time was in the past, moved to tomorrow.',
//                 ),
//               ),
//             );
//           }
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.existingTask == null ? 'Create Task' : 'Edit Task'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 TextFormField(
//                   controller: _nameController,
//                   decoration: const InputDecoration(labelText: 'Task Name'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter a task name';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _descriptionController,
//                   decoration: const InputDecoration(labelText: 'Description'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter a description';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _linkController,
//                   decoration: const InputDecoration(
//                     labelText: 'Link (optional)',
//                   ),
//                   keyboardType: TextInputType.url,
//                 ),
//                 const SizedBox(height: 16),
//                 ListTile(
//                   title: Text(
//                     'Time: ${DateFormat('MMM d, HH:mm').format(_selectedTime)}',
//                   ),
//                   subtitle:
//                       _selectedTime.isAfter(DateTime.now())
//                           ? Text(
//                             'In ${_selectedTime.difference(DateTime.now()).inMinutes} minutes',
//                           )
//                           : Text(
//                             'Time is in the past or now',
//                             style: TextStyle(color: Colors.red),
//                           ),
//                   trailing: const Icon(Icons.calendar_today),
//                   onTap: () => _selectTime(context),
//                 ),
//                 const SizedBox(height: 16),
//                 DropdownButtonFormField<String>(
//                   value: _repeat,
//                   decoration: const InputDecoration(labelText: 'Repeat'),
//                   items: const [
//                     DropdownMenuItem(value: 'none', child: Text('None')),
//                     DropdownMenuItem(value: 'daily', child: Text('Daily')),
//                     DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
//                   ],
//                   onChanged: (value) {
//                     setState(() {
//                       _repeat = value!;
//                       if (_repeat == 'none' &&
//                           _selectedTime.isBefore(DateTime.now())) {
//                         _selectedTime = _selectedTime.add(
//                           const Duration(days: 1),
//                         );
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text(
//                               'Time was in the past for non-repeating, moved to tomorrow.',
//                             ),
//                           ),
//                         );
//                       }
//                     });
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     if (_formKey.currentState!.validate()) {
//                       final newTask = Task(
//                         id:
//                             widget.existingTask?.id ??
//                             DateTime.now().millisecondsSinceEpoch.toString(),
//                         name: _nameController.text,
//                         description: _descriptionController.text,
//                         link:
//                             _linkController.text.isEmpty
//                                 ? null
//                                 : _linkController.text,
//                         time: _selectedTime,
//                         repeat: _repeat,
//                         isDone: widget.existingTask?.isDone ?? false,
//                       );
//                       widget.onTaskCreated(newTask);
//                       Navigator.pop(context, newTask);
//                     }
//                   },
//                   child: Text(
//                     widget.existingTask == null ? 'Create Task' : 'Save Task',
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
