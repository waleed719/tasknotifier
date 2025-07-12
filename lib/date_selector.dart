// File: widgets/date_selector.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateSelector extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const DateSelector({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;

    final today = DateTime.now();
    final start = today.subtract(const Duration(days: 3));
    final days = List.generate(14, (index) => start.add(Duration(days: index)));

    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: days.length,
        itemBuilder: (context, index) {
          final date = days[index];
          final isSelected = _isSameDate(date, selectedDate);
          final isToday = _isSameDate(date, today);

          return GestureDetector(
            onTap: () => onDateSelected(date),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getBackgroundColor(
                  context,
                  isSelected,
                  isToday,
                  isDarkMode,
                ),
                borderRadius: BorderRadius.circular(12),
                border: _getBorder(context, isSelected, isToday),
                boxShadow: _getBoxShadow(context, isSelected, isDarkMode),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat.E().format(date), // e.g., Mon
                    style:
                        theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: _getTextColor(context, isSelected, isToday),
                        ) ??
                        TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: _getTextColor(context, isSelected, isToday),
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat.d().format(date), // e.g., 24
                    style:
                        theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _getTextColor(context, isSelected, isToday),
                        ) ??
                        TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _getTextColor(context, isSelected, isToday),
                        ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getBackgroundColor(
    BuildContext context,
    bool isSelected,
    bool isToday,
    bool isDarkMode,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    if (isSelected) {
      return colorScheme.primary;
    }

    if (isToday) {
      // More subtle today indication that works better in both themes
      return isDarkMode
          ? colorScheme.primary.withOpacity(0.15)
          : colorScheme.primary.withOpacity(0.08);
    }

    // Use appropriate surface colors for theme
    return isDarkMode
        ? colorScheme.surface.withOpacity(0.8)
        : colorScheme.surface;
  }

  Color _getTextColor(BuildContext context, bool isSelected, bool isToday) {
    final colorScheme = Theme.of(context).colorScheme;

    if (isSelected) {
      return colorScheme.onPrimary;
    }

    if (isToday) {
      return colorScheme.primary;
    }

    // Use theme-appropriate text colors
    return colorScheme.onSurface;
  }

  Border? _getBorder(BuildContext context, bool isSelected, bool isToday) {
    final colorScheme = Theme.of(context).colorScheme;

    if (isToday && !isSelected) {
      return Border.all(
        color: colorScheme.primary.withOpacity(0.6),
        width: 1.5,
      );
    }

    return null;
  }

  List<BoxShadow>? _getBoxShadow(
    BuildContext context,
    bool isSelected,
    bool isDarkMode,
  ) {
    if (!isSelected) return null;

    final colorScheme = Theme.of(context).colorScheme;

    return [
      BoxShadow(
        color: colorScheme.primary.withOpacity(isDarkMode ? 0.4 : 0.25),
        blurRadius: isDarkMode ? 12 : 8,
        offset: const Offset(0, 4),
        spreadRadius: isDarkMode ? 1 : 0,
      ),
    ];
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
