// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:tasknotifier/task_card.dart';

// class TaskHomeScreen extends StatefulWidget {
//   const TaskHomeScreen({super.key});

//   @override
//   State<TaskHomeScreen> createState() => _TaskHomeScreenState();
// }

// class _TaskHomeScreenState extends State<TaskHomeScreen> {
//   DateTime _selectedDate = DateTime.now();

//   // Dummy tasks list — replace with real filtered tasks
//   final List<Map<String, dynamic>> allTasks = [
//     {
//       'title': 'Team Meeting',
//       'desc': 'Discuss all questions about new projects',
//       'time': '10:00 AM',
//       'date': DateTime.now(),
//       'repeat': 'None',
//     },
//     {
//       'title': 'Call the Doctor',
//       'desc': 'Channel Booking Online',
//       'time': '11:00 AM',
//       'date': DateTime.now().add(Duration(days: 1)),
//       'repeat': 'None',
//     },
//   ];

//   List<Map<String, dynamic>> get filteredTasks {
//     return allTasks
//         .where(
//           (task) =>
//               DateFormat('yyyy-MM-dd').format(task['date']) ==
//               DateFormat('yyyy-MM-dd').format(_selectedDate),
//         )
//         .toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: const Icon(Icons.menu),
//         actions: [const Icon(Icons.notifications), const SizedBox(width: 16)],
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         foregroundColor: Colors.black,
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildHeader(),
//           _buildDateScroller(),
//           const SizedBox(height: 10),
//           Expanded(
//             child: ListView.builder(
//               itemCount: filteredTasks.length,
//               itemBuilder: (context, index) {
//                 return TaskCard(task: filteredTasks[index]);
//               },
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // TODO: Navigate to add task screen
//         },
//         backgroundColor: Colors.redAccent,
//         child: const Icon(Icons.add),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             "MY TASK MANAGER",
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             DateFormat.yMMMMd().format(DateTime.now()),
//             style: const TextStyle(fontSize: 14, color: Colors.grey),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDateScroller() {
//     return SizedBox(
//       height: 70,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: 30,
//         itemBuilder: (context, index) {
//           DateTime date = DateTime.now().add(Duration(days: index));
//           bool isSelected =
//               DateFormat('yyyy-MM-dd').format(date) ==
//               DateFormat('yyyy-MM-dd').format(_selectedDate);
//           return GestureDetector(
//             onTap: () {
//               setState(() {
//                 _selectedDate = date;
//               });
//             },
//             child: Container(
//               margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: isSelected ? Colors.redAccent : Colors.grey[200],
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Column(
//                 children: [
//                   Text(
//                     DateFormat('E').format(date),
//                     style: TextStyle(
//                       color: isSelected ? Colors.white : Colors.black,
//                     ),
//                   ),
//                   const SizedBox(height: 5),
//                   Text(
//                     DateFormat('d').format(date),
//                     style: TextStyle(
//                       color: isSelected ? Colors.white : Colors.black,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
