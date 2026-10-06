import 'package:flutter/material.dart';
import 'core/constants/app_colors.dart';
import 'features/dashboard/presentation/career_dashboard.dart';

void main() {
  runApp(const SkillPathAI());
}

class SkillPathAI extends StatelessWidget {
  const SkillPathAI({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SkillPath AI',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: kNavy,
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(
          seedColor: kPurple,
          brightness: Brightness.dark,
        ),
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
        ),
      ),
      home: const CareerDashboard(),
    );
  }
}
