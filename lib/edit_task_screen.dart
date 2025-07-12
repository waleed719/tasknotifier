import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tasknotifier/notification_service.dart';
import 'package:tasknotifier/task.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;
  final Function(Task) onTaskUpdated;

  const EditTaskScreen({
    super.key,
    required this.task,
    required this.onTaskUpdated,
  });

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _linkController;

  late DateTime _selectedDate;
  late TimeOfDay _startTime;
  late String _repeat;
  bool _hasAlarm = false;

  final List<String> _repeatOptions = ['none', 'daily', 'weekly'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.name);
    _descController = TextEditingController(text: widget.task.description);
    _linkController = TextEditingController(text: widget.task.link ?? '');

    _selectedDate = widget.task.time;
    _startTime = TimeOfDay(
      hour: widget.task.time.hour,
      minute: widget.task.time.minute,
    );
    _repeat = widget.task.repeat;
    _hasAlarm = widget.task.hasAlarm; // <-- ✅ this line is needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Task"), centerTitle: true),
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
              _buildTextField(
                "Optional Link (URL)",
                _linkController,
                isOptionalUrl: true,
              ),
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
                    final updatedDateTime = DateTime(
                      _selectedDate.year,
                      _selectedDate.month,
                      _selectedDate.day,
                      _startTime.hour,
                      _startTime.minute,
                    );

                    final updatedTask = widget.task.copyWith(
                      name: _titleController.text,
                      description: _descController.text,
                      link:
                          _linkController.text.isEmpty
                              ? null
                              : _linkController.text,
                      time: updatedDateTime,
                      repeat: _repeat,
                      hasAlarm: _hasAlarm, // ✅ Add this line
                    );

                    try {
                      widget.onTaskUpdated(updatedTask);
                      await NotificationService().scheduleNotification(
                        updatedTask,
                      );
                    } catch (e) {
                      print("Error during task update or notification: $e");
                    }

                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                },

                child: const Text("Save Changes"),
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
