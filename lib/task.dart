// File: models/task.dart
class Task {
  final String id;
  String name;
  String description;
  String? link;
  DateTime time;
  String repeat;
  bool isDone;
  final bool hasAlarm;

  Task({
    required this.id,
    required this.name,
    required this.description,
    this.link,
    required this.time,
    required this.repeat,
    this.isDone = false,
    this.hasAlarm = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'link': link,
    'time': time.toIso8601String(),
    'repeat': repeat,
    'isDone': isDone,
    'hasAlarm': hasAlarm,
  };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    link: json['link'] as String?,
    time: DateTime.parse(json['time'] as String),
    repeat: json['repeat'] as String,
    isDone: json['isDone'] as bool,
    hasAlarm: json['hasAlarm'] ?? false,
  );

  Task copyWith({
    String? id,
    String? name,
    String? description,
    String? link,
    DateTime? time,
    String? repeat,
    bool? isDone,
    bool? hasAlarm,
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      link: link ?? this.link,
      time: time ?? this.time,
      repeat: repeat ?? this.repeat,
      isDone: isDone ?? this.isDone,
      hasAlarm: hasAlarm ?? this.hasAlarm,
    );
  }
}
