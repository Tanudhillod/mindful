import 'package:flutter/material.dart';
import '../widgets/coping_tool_card.dart';
import '../theme.dart';

class CopingScreen extends StatelessWidget {
  const CopingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Instant Coping Tools', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Quick, evidence-based techniques to help you feel better in the moment. Choose what feels right for you today.', style: TextStyle(fontSize: 16, color: AppColors.textLight)),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.errorRed)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('I Need Help Now', style: TextStyle(fontSize: 20, color: AppColors.errorRed, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('If you\'re in crisis, reach out for professional help immediately'),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      CopingToolCard(icon: Icons.alarm, title: 'Crisis Hotline', description: '24/7 Support'),
                      const SizedBox(width: 8),
                      CopingToolCard(icon: Icons.chat, title: 'Text Support Chat', description: 'Anonymous Chat'),
                      const SizedBox(width: 8),
                      CopingToolCard(icon: Icons.local_hospital, title: 'Emergency', description: 'Call 911'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Row(
              children: [
                CopingToolCard(icon: Icons.air, title: 'Breathing Exercises', description: 'Calm your nervous system with guided breathing'),
                SizedBox(width: 8),
                CopingToolCard(icon: Icons.book, title: 'Journal Prompts', description: 'CBT-inspired questions for self-reflection'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}