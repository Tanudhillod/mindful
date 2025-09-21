import 'package:flutter/material.dart';
import '../theme.dart';

class ChallengeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String difficulty;
  final String status;
  final double progress;

  const ChallengeCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.difficulty = 'Easy',
    this.status = 'Active',
    this.progress = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primaryPurple.withOpacity(0.2),
              child: Icon(icon, color: AppColors.primaryPurple),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(description),
                  const SizedBox(height: 8),
                  if (progress > 0) LinearProgressIndicator(value: progress, color: AppColors.accentTeal),
                ],
              ),
            ),
            Chip(
              label: Text(difficulty),
              backgroundColor: AppColors.lightBlue,
            ),
            const SizedBox(width: 8),
            Chip(
              label: Text(status),
              backgroundColor: status == 'Completed' ? AppColors.successGreen.withOpacity(0.2) : AppColors.primaryPurple.withOpacity(0.2),
            ),
          ],
        ),
      ),
    );
  }
}