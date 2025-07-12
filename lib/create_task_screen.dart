import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tasknotifier/notification_service.dart';
import 'package:tasknotifier/task.dart';

class CreateTaskScreen extends StatefulWidget {
  final Function(Task) onTaskCreated;

  const CreateTaskScreen({super.key, required this.onTaskCreated});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = const TimeOfDay(hour: 10, minute: 0);
  String _repeat = 'none';
  bool _hasAlarm = false;

  final List<String> _repeatOptions = ['none', 'daily', 'weekly'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create New Task"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField("Task Name", _titleController),
              const SizedBox(height: 12),
              _buildTextField("Description", _descController, maxLines: 3),
              const SizedBox(height: 12),
              _buildTextField("Optional Link (URL)", _linkController),
              const SizedBox(height: 12),
              _buildDatePicker(),
              const SizedBox(height: 12),
              _buildTimePicker(),
              const SizedBox(height: 12),
              _buildRepeatDropdown(),
              const SizedBox(height: 24),
              SwitchListTile(
                title: const Text('Set Alarm'),
                value: _hasAlarm,
                onChanged: (val) {
                  setState(() => _hasAlarm = val);
                },
              ),

              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final DateTime combinedDateTime = DateTime(
                      _selectedDate.year,
                      _selectedDate.month,
                      _selectedDate.day,
                      _startTime.hour,
                      _startTime.minute,
                    );

                    final task = Task(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: _titleController.text,
                      description: _descController.text,
                      link:
                          _linkController.text.isEmpty
                              ? null
                              : _linkController.text,
                      time: combinedDateTime,
                      repeat: _repeat,
                      isDone: false,
                      hasAlarm: _hasAlarm,
                    );

                    widget.onTaskCreated(task);
                    await NotificationService().scheduleNotification(task);
                    // Navigator.pop(context);
                  }
                },
                child: const Text("Create New Task"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    bool isOptionalUrl = false,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (isOptionalUrl) {
          if (value != null && value.isNotEmpty) {
            // Auto-prepend https:// if missing
            if (!value.startsWith("http://") && !value.startsWith("https://")) {
              controller.text = "https://$value";
            }

            final uri = Uri.tryParse(controller.text);
            if (uri == null ||
                !(uri.hasScheme &&
                    (uri.scheme == 'http' || uri.scheme == 'https'))) {
              return "Enter a valid URL starting with http:// or https://";
            }
          }
          return null; // Accept empty
        }

        return value == null || value.isEmpty ? "Please enter $label." : null;
      },
    );
  }

  Widget _buildDatePicker() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.calendar_today),
      title: Text(DateFormat.yMMMMd().format(_selectedDate)),
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          setState(() => _selectedDate = picked);
        }
      },
    );
  }

  Widget _buildTimePicker() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.access_time),
      title: Text("Time: ${_startTime.format(context)}"),
      onTap: () async {
        TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: _startTime,
        );
        if (picked != null) {
          setState(() => _startTime = picked);
        }
      },
    );
  }

  Widget _buildRepeatDropdown() {
    return DropdownButtonFormField<String>(
      value: _repeat,
      decoration: const InputDecoration(labelText: 'Repeat'),
      items:
          _repeatOptions
              .map(
                (value) => DropdownMenuItem(value: value, child: Text(value)),
              )
              .toList(),
      onChanged: (value) => setState(() => _repeat = value!),
    );
  }
}
