// File: today_task_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodayTaskScreen extends StatefulWidget {
  const TodayTaskScreen({super.key});

  @override
  State<TodayTaskScreen> createState() => _TodayTaskScreenState();
}

class _TodayTaskScreenState extends State<TodayTaskScreen> {
  DateTime _selectedDate = DateTime.now();
  final List<Map<String, dynamic>> _tasks = [
    {
      'title': 'Team Meeting',
      'desc': 'Discuss project updates',
      'time': '10:00 AM',
      'category': 'UI/UX',
      'date': DateTime.now(),
    },
    {
      'title': 'Call the Doctor',
      'desc': 'Book appointment',
      'time': '11:00 AM',
      'category': 'Personal',
      'date': DateTime.now().add(const Duration(days: 1)),
    },
  ];

  List<DateTime> _generateNext7Days() {
    return List.generate(7, (i) => DateTime.now().add(Duration(days: i)));
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredTasks =
        _tasks.where((task) => isSameDay(task['date'], _selectedDate)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Task Manager'),
        actions: const [Icon(Icons.notifications_none)],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateScroller(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              DateFormat.yMMMMEEEEd().format(_selectedDate),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                final task = filteredTasks[index];
                return _buildTaskCard(task);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateScroller() {
    return SizedBox(
      height: 80,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children:
            _generateNext7Days().map((date) {
              bool isSelected = isSameDay(date, _selectedDate);
              return GestureDetector(
                onTap: () => setState(() => _selectedDate = date),
                child: Container(
                  width: 60,
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.redAccent : Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(DateFormat.E().format(date)),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat.d().format(date),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.check)),
        title: Text(task['title']),
        subtitle: Text(task['desc']),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(task['time']),
            Text(task['category'], style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
