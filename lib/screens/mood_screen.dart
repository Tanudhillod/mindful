import 'package:flutter/material.dart';
import '../widgets/mood_checkin.dart';
import '../widgets/mood_trends.dart';
import '../theme.dart';

class MoodScreen extends StatelessWidget {
  const MoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Track your daily emotions and discover patterns in your mental wellness journey', style: TextStyle(fontSize: 16, color: AppColors.textLight)),
            const SizedBox(height: 24),
            const MoodCheckIn(),
            const SizedBox(height: 32),
            const MoodTrends(),
          ],
        ),
      ),
    );
  }
}