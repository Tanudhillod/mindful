import 'package:flutter/material.dart';
import '../widgets/feature_card.dart';
import '../theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Welcome to your wellness journey', style: TextStyle(fontSize: 16, color: AppColors.primaryPurple)),
            const SizedBox(height: 16),
            const Text('Your Mental Wellness Companion', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            const SizedBox(height: 8),
            const Text(
              'A safe space to nurture your mental health with AI-powered support, mood tracking, and personalized coping tools designed just for you.',
              style: TextStyle(fontSize: 18, color: AppColors.textLight),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentTeal, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
              child: const Text('Start Chatting'),
            ),
            const SizedBox(height: 32),
            const Text('How are you feeling today?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Text('Take a moment to check in with yourself'),
            const SizedBox(height: 16),
            // Grid of feature cards
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: const [
                FeatureCard(
                  icon: Icons.chat_bubble_outline,
                  title: 'AI Companion',
                  description: 'Chat with an empathetic AI friend available 24/7',
                  buttonText: 'Start Chat',
                ),
                FeatureCard(
                  icon: Icons.favorite_border,
                  title: 'Mood Tracker',
                  description: 'Track your daily emotions and see patterns over time',
                  buttonText: 'Track Mood',
                ),
                FeatureCard(
                  icon: Icons.shield_outlined,
                  title: 'Coping Tools',
                  description: 'Instant access to breathing exercises and mindfulness',
                  buttonText: 'Get Help Now',
                ),
                FeatureCard(
                  icon: Icons.star_border,
                  title: 'Challenges',
                  description: 'Join wellness challenges and earn achievement badges',
                  buttonText: 'View Challenges',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}