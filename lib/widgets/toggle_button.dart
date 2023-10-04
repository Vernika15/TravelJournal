import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data_manager/theme_data_manager.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeDataManager>(context);

    return Switch(
      value: themeProvider.themeMode == ThemeMode.dark,
      onChanged: (_) {
        themeProvider.toggleTheme();
      },
    );
  }
}
