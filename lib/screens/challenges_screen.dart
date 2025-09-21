import 'package:flutter/material.dart';
import '../widgets/challenge_card.dart';
import '../theme.dart';

class ChallengesScreen extends StatelessWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Wellness Challenges', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Build healthy habits through gamified challenges designed to support your mental wellness journey', style: TextStyle(fontSize: 16, color: AppColors.textLight)),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _statCard('1', 'Completed', Icons.check_circle_outline)),
                const SizedBox(width: 8),
                Expanded(child: _statCard('2', 'Active', Icons.play_circle_outline)),
                const SizedBox(width: 8),
                Expanded(child: _statCard('2', 'Badges', Icons.badge)),
                const SizedBox(width: 8),
                Expanded(child: _statCard('247', 'Points', Icons.star_outline)),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Available Challenges', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const ChallengeCard(
              icon: Icons.nightlight_round,
              title: '7-Day Sleep Hygiene Challenge',
              description: 'Establish healthy sleep habits with consistent bedtime routines',
              difficulty: 'Easy',
              status: 'Active',
            ),
            const SizedBox(height: 16),
            const Text('Your Achievements', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            // Example badges
            Wrap(
              spacing: 16,
              children: [
                _badge('Grateful Heart'),
                _badge('Early Bird'),
                _badge('Mindful Moment'),
                _badge('Consistency King'),
                _badge('Self-Love Champion'),
                _badge('Zen Master'),
              ],
            ),
            const SizedBox(height: 16),
            const ChallengeCard(
              icon: Icons.favorite,
              title: 'Gratitude Practice',
              description: 'Write down 3 things you\'re grateful for each day',
              difficulty: 'Easy',
              status: 'Completed',
              progress: 1.0,
            ),
            const SizedBox(height: 16),
            const Text('Keep Growing!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Text('Every small step you take matters. You\'re building the foundation for lasting wellness.'),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String value, String label, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.primaryPurple, size: 20),
            const SizedBox(height: 4),
            Text(
              value, 
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 10),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge(String title) {
    return Chip(
      label: Text(title),
      avatar: const Icon(Icons.star, color: Colors.yellow),
      backgroundColor: AppColors.lightBlue,
    );
  }
}