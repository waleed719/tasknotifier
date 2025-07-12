import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasknotifier/app_themes.dart';

class ThemeSettingsPage extends StatelessWidget {
  const ThemeSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Choose Theme"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Your Preferred Theme",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              "Choose a theme that matches your style and preferences",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _themeItems.length,
                itemBuilder: (context, index) {
                  final themeItem = _themeItems[index];
                  final isSelected = _isThemeSelected(themeNotifier, index);

                  return GestureDetector(
                    onTap: () {
                      themeNotifier.switchThemeByIndex(index);
                      _showThemeChangedSnackbar(context, themeItem.name);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color:
                              isSelected
                                  ? Theme.of(context).primaryColor
                                  : Colors.transparent,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Card(
                        margin: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            // Theme preview container
                            Expanded(
                              flex: 3,
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color:
                                      themeItem.theme.scaffoldBackgroundColor,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    // App bar preview
                                    Positioned(
                                      top: 8,
                                      left: 8,
                                      right: 8,
                                      child: Container(
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color:
                                              themeItem
                                                  .theme
                                                  .appBarTheme
                                                  .backgroundColor,
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Card preview
                                    Positioned(
                                      top: 40,
                                      left: 8,
                                      right: 8,
                                      child: Container(
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color:
                                              themeItem.theme.cardTheme.color,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.1,
                                              ),
                                              blurRadius: 2,
                                              offset: const Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Button preview
                                    Positioned(
                                      bottom: 8,
                                      left: 8,
                                      right: 8,
                                      child: Container(
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color:
                                              themeItem
                                                  .theme
                                                  .elevatedButtonTheme
                                                  .style
                                                  ?.backgroundColor
                                                  ?.resolve({}) ??
                                              themeItem.theme.primaryColor,
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Selection indicator
                                    if (isSelected)
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).primaryColor,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 12,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            // Theme name and description
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AutoSizeText(
                                      themeItem.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                      minFontSize: 10,
                                      maxLines: 1,
                                      overflow: TextOverflow.visible,
                                    ),
                                    const SizedBox(height: 4),
                                    AutoSizeText(
                                      themeItem.description,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                      minFontSize: 8,
                                      maxLines: 2,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isThemeSelected(ThemeNotifier notifier, int index) {
    return notifier.currentThemeIndex == index;
  }

  void _showThemeChangedSnackbar(BuildContext context, String themeName) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Theme changed to $themeName'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

class ThemeItem {
  final String name;
  final String description;
  final ThemeData theme;

  const ThemeItem({
    required this.name,
    required this.description,
    required this.theme,
  });
}

final List<ThemeItem> _themeItems = [
  ThemeItem(
    name: "Corporate Blue",
    description: "Professional business theme",
    theme: AppThemes.corporateBlue,
  ),
  ThemeItem(
    name: "Emerald Professional",
    description: "Modern green corporate look",
    theme: AppThemes.emeraldProfessional,
  ),
  ThemeItem(
    name: "Midnight Professional",
    description: "Dark theme with purple accents",
    theme: AppThemes.midnightProfessional,
  ),
  ThemeItem(
    name: "Rose Gold Executive",
    description: "Elegant luxury theme",
    theme: AppThemes.roseGoldExecutive,
  ),
  ThemeItem(
    name: "Slate Professional",
    description: "Clean monochrome design",
    theme: AppThemes.slateProfessional,
  ),
  ThemeItem(
    name: "Ocean Professional",
    description: "Calming blue-green theme",
    theme: AppThemes.oceanProfessional,
  ),
  ThemeItem(
    name: "Amber Professional",
    description: "Warm and welcoming",
    theme: AppThemes.amberProfessional,
  ),
  ThemeItem(
    name: "Indigo Executive",
    description: "Deep and sophisticated",
    theme: AppThemes.indigoExecutive,
  ),
  ThemeItem(
    name: "Charcoal Professional",
    description: "Dark sophisticated theme",
    theme: AppThemes.charcoalProfessional,
  ),
  ThemeItem(
    name: "Teal Professional",
    description: "Fresh and modern",
    theme: AppThemes.tealProfessional,
  ),
];
