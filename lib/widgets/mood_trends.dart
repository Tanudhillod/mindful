import 'package:flutter/material.dart';
import '../theme.dart';

class MoodTrends extends StatelessWidget {
  const MoodTrends({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Mood Trends', style: TextStyle(fontSize: 20, color: AppColors.accentTeal)),
            const Text('Your mood over the past week'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppColors.successGreen.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sentiment_satisfied, color: Colors.green),
                  SizedBox(width: 8),
                  Text('Weekly Average: Good'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text('Recent Entries'),
            const ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Jan 15'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.sentiment_satisfied, color: Colors.green),
                  Text('Good'),
                ],
              ),
            ),
            const ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Jan 14'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.sentiment_neutral, color: Colors.yellow),
                  Text('Neutral'),
                ],
              ),
            ),
            // Add more as needed
          ],
        ),
      ),
    );
  }
}