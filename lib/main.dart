import 'package:flutter/material.dart';
import 'package:tasknotifier/app_themes.dart';
import 'package:tasknotifier/edit_task_screen.dart';
import 'package:tasknotifier/home_screen.dart';
import 'package:tasknotifier/notification_service.dart';
import 'package:tasknotifier/task.dart';
import 'package:tasknotifier/task_storage.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.instance.init(); // Initialize notification service
  final List<Task> initialTasks = await TaskStorage.loadTasks();

  runApp(
    ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => ThemeNotifier(),
      child: MyApp(initialTasks: initialTasks),
    ),
  );
}

class MyApp extends StatefulWidget {
  final List<Task> initialTasks;

  const MyApp({super.key, required this.initialTasks});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Task> tasks = [];
  @override
  void initState() {
    super.initState();
    TaskStorage.loadTasks().then((loadedTasks) {
      setState(() {
        tasks = loadedTasks;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeNotifier.currentTheme,
      home: HomeScreen(
        tasks: tasks,
        onDone: (task) {
          setState(() {
            task.isDone = true;
          });
          TaskStorage.saveTasks(tasks);
        },
        onTap: (task) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => EditTaskScreen(
                    task: task,
                    onTaskUpdated: (updatedTask) {
                      final index = tasks.indexOf(task);
                      if (index != -1) {
                        setState(() {
                          tasks[index] = updatedTask;
                        });
                        TaskStorage.saveTasks(tasks);
                      }
                    },
                  ),
            ),
          );
        },
      ),
    );
  }
}
