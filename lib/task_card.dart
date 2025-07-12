// File: widgets/task_card.darts
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tasknotifier/task.dart';
import 'package:url_launcher/url_launcher.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onDone;
  final VoidCallback onTap;

  const TaskCard({
    super.key,
    required this.task,
    required this.onDone,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isOverdue = task.time.isBefore(DateTime.now()) && !task.isDone;
    final timeFormatted = DateFormat('h:mm a').format(task.time);

    Future<void> launchLink(String url) async {
      final Uri uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        print('Could not launch $uri');
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: task.isDone ? Colors.grey[200] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              task.isDone ? Icons.check_circle : Icons.access_time,
              color:
                  task.isDone
                      ? Colors.green
                      : (isOverdue ? Colors.red : Colors.deepPurple),
              size: 28,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      decoration:
                          task.isDone ? TextDecoration.lineThrough : null,
                      color: task.isDone ? Colors.grey : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    task.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: task.isDone ? Colors.grey : Colors.black54,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${DateFormat('MMM d').format(task.time)}, $timeFormatted',
                        style: TextStyle(
                          fontSize: 12,
                          color: isOverdue ? Colors.red : Colors.grey[700],
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (task.repeat != 'none')
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            task.repeat.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            if (!task.isDone)
              IconButton(
                icon: const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                ),
                onPressed: onDone,
              ),
            if (task.link != null && task.link!.isNotEmpty)
              IconButton(
                icon: Icon(Icons.link),
                onPressed: () => launchLink(task.link!),
                // onPressed: () async {
                //   final link = task.link;
                //   if (link != null && link.isNotEmpty) {
                //     final uri = Uri.parse(link);
                //     if (await canLaunchUrl(uri)) {
                //       await launchUrl(
                //         uri,
                //         mode: LaunchMode.externalApplication,
                //       );
                //     } else {
                //       print('Could not launch $link');
                //       ScaffoldMessenger.of(context).showSnackBar(
                //         SnackBar(content: Text('Could not open link')),
                //       );
                //     }
                //   }
                // },
              ),
          ],
        ),
      ),
    );
  }
}
