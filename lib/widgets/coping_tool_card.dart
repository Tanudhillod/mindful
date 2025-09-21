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
    return Expanded(
      child: Card(
        color: AppColors.lightBlue,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppColors.primaryPurple, size: 24),
              const SizedBox(height: 4),
              Text(
                title, 
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                description, 
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}