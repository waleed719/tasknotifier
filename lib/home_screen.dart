// File: screens/home_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tasknotifier/create_task_screen.dart';
import 'package:tasknotifier/date_selector.dart';
import 'package:tasknotifier/edit_task_screen.dart';
import 'package:tasknotifier/task.dart';
import 'package:tasknotifier/task_card.dart';
import 'package:tasknotifier/task_storage.dart';
import 'package:tasknotifier/theme_settings_page.dart';
import 'package:tasknotifier/notification_service.dart';

class HomeScreen extends StatefulWidget {
  final List<Task> tasks;
  final Function(Task) onDone;
  final Function(Task) onTap;

  const HomeScreen({
    super.key,
    required this.tasks,
    required this.onDone,
    required this.onTap,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDate = DateTime.now();
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _checkOverdueTasks();
    Timer.periodic(const Duration(minutes: 1), (_) => _checkOverdueTasks());
  }

  void _checkOverdueTasks() {
    NotificationService.instance.checkAndScheduleOverdueTasks(widget.tasks);
  }

  void _markTaskAsDone(Task task) {
    setState(() {
      final index = widget.tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        widget.tasks[index] = task.copyWith(isDone: true);
      }
    });
    NotificationService.instance.markTaskAsDone(task.id);
    TaskStorage.saveTasks(widget.tasks);
  }

  @override
  Widget build(BuildContext context) {
    List<Task> filteredTasks =
        widget.tasks.where((task) {
          final isSameDay = DateUtils.isSameDay(task.time, _selectedDate);

          if (_tabIndex == 0) {
            return !task.isDone && isSameDay;
          } else if (_tabIndex == 1) {
            return !task.isDone && task.time.isAfter(DateTime.now());
          } else {
            return task.isDone;
          }
        }).toList();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTask = await Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => CreateTaskScreen(
                    onTaskCreated: (task) {
                      Navigator.pop(context, task);
                    },
                  ),
            ),
          );

          if (newTask != null && newTask is Task) {
            setState(() {
              widget.tasks.add(newTask);
            });
            await TaskStorage.saveTasks(widget.tasks);
          }
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 6,
        highlightElevation: 12,
        splashColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.12),
        tooltip: 'Add New Task',
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Task Notifier'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ThemeSettingsPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          Text('Calander', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 10),
          SizedBox(
            height: 98,
            child: DateSelector(
              selectedDate: _selectedDate,
              onDateSelected: (date) {
                setState(() {
                  _selectedDate = date;
                });
              },
            ),
          ),
          Text('My Tasks', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 10),
          ToggleButtons(
            isSelected: List.generate(3, (i) => i == _tabIndex),
            onPressed: (index) => setState(() => _tabIndex = index),
            borderRadius: BorderRadius.circular(12),
            selectedColor: Theme.of(context).colorScheme.onPrimary,
            fillColor: Theme.of(context).colorScheme.primary,
            color: Theme.of(context).colorScheme.onSurface,
            borderColor: Theme.of(context).colorScheme.outline,
            selectedBorderColor: Theme.of(context).colorScheme.primary,
            disabledColor: Theme.of(
              context,
            ).colorScheme.onSurface.withOpacity(0.38),
            splashColor: Theme.of(
              context,
            ).colorScheme.primary.withOpacity(0.12),
            highlightColor: Theme.of(
              context,
            ).colorScheme.primary.withOpacity(0.08),
            constraints: const BoxConstraints(minWidth: 80, minHeight: 40),
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'Today',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'Upcoming',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'Completed',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child:
                filteredTasks.isEmpty
                    ? const Center(child: Text('No tasks found'))
                    : ListView.builder(
                      itemCount: filteredTasks.length,
                      itemBuilder:
                          (context, index) => TaskCard(
                            task: filteredTasks[index],
                            onDone: () => _markTaskAsDone(filteredTasks[index]),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => EditTaskScreen(
                                        task: filteredTasks[index],
                                        onTaskUpdated: (updatedTask) {
                                          final taskIndex = widget.tasks
                                              .indexOf(filteredTasks[index]);
                                          if (taskIndex != -1) {
                                            setState(() {
                                              widget.tasks[taskIndex] =
                                                  updatedTask;
                                            });
                                            TaskStorage.saveTasks(widget.tasks);
                                          }
                                        },
                                      ),
                                ),
                              );
                            },
                          ),
                    ),
          ),
        ],
      ),
    );
  }
}
