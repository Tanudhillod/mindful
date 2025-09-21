import 'package:flutter/material.dart';
import '../theme.dart';

class MoodCheckIn extends StatefulWidget {
  const MoodCheckIn({super.key});

  @override
  State<MoodCheckIn> createState() => _MoodCheckInState();
}

class _MoodCheckInState extends State<MoodCheckIn> {
  double _moodValue = 3.0; // Neutral default

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Daily Check-in', style: TextStyle(fontSize: 20, color: AppColors.primaryPurple)),
            const Text('How are you feeling today? (September 21, 2025)'),
            const SizedBox(height: 16),
            Slider(
              value: _moodValue,
              min: 1,
              max: 5,
              divisions: 4,
              activeColor: AppColors.primaryPurple,
              onChanged: (value) => setState(() => _moodValue = value),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Very Low'),
                Text('Great'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(Icons.sentiment_very_dissatisfied, color: Colors.red, size: 32),
                const Icon(Icons.sentiment_dissatisfied, color: Colors.orange, size: 32),
                const Icon(Icons.sentiment_neutral, color: Colors.yellow, size: 32),
                const Icon(Icons.sentiment_satisfied, color: Colors.lightGreen, size: 32),
                const Icon(Icons.sentiment_very_satisfied, color: Colors.green, size: 32),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentTeal),
              child: const Text('Save Today\'s Mood'),
            ),
          ],
        ),
      ),
    );
  }
}