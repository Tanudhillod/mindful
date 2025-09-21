import 'package:flutter/material.dart';
import '../theme.dart';

class CopingToolCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const CopingToolCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.lightBlue,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primaryPurple),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(description, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}