import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/feature_card.dart';
import '../widgets/resource_card.dart';
import '../widgets/daily_quote.dart';
import '../theme.dart';
import 'chat_screen.dart';
import 'mood_screen.dart';
import 'coping_screen.dart';
import 'challenges_screen.dart';
import 'resources_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userNickname = 'Friend';
  String userAvatar = '🌱';
  int streakDays = 0;
  String? todaysMood;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final todayKey = '${today.year}-${today.month}-${today.day}';
    
    setState(() {
      userNickname = prefs.getString('user_nickname') ?? 'Friend';
      userAvatar = prefs.getString('user_avatar') ?? '🌱';
      streakDays = prefs.getInt('streak_days') ?? 0;
      todaysMood = prefs.getString('mood_$todayKey');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryGreen.withOpacity(0.1),
                    AppColors.primaryBlue.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primaryGreen.withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        userAvatar,
                        style: const TextStyle(fontSize: 32),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome back, $userNickname!',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: AppColors.textDark,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Your mental wellness journey continues',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Quick stats
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickStat(
                          context,
                          '🔥',
                          '$streakDays days',
                          'Check-in streak',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildQuickStat(
                          context,
                          _getTodaysMoodEmoji(),
                          todaysMood != null ? 'Checked in' : 'Pending',
                          'Today\'s mood',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Daily Quote
            const DailyQuote(),
            const SizedBox(height: 24),
            
            // Quick Actions
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.textDark,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            // Primary actions row
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    context,
                    'Start Chatting',
                    'Talk to your AI companion',
                    Icons.chat_bubble_outline,
                    AppColors.primaryGreen,
                    () => _navigateToTab(1),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionCard(
                    context,
                    todaysMood != null ? 'Update Mood' : 'Check-in',
                    todaysMood != null ? 'Update today\'s mood' : 'How are you feeling?',
                    Icons.favorite_outline,
                    AppColors.accentPeach,
                    () => _navigateToTab(2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Feature Grid
            Text(
              'Wellness Tools',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.textDark,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            LayoutBuilder(
              builder: (context, constraints) {
                double width = constraints.maxWidth;
                int crossAxisCount = width > 600 ? 3 : 2;
                double childAspectRatio = width > 600 ? 0.9 : 0.85;
                
                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: childAspectRatio,
                  children: [
                    FeatureCard(
                      icon: Icons.shield_outlined,
                      title: 'Coping Tools',
                      description: 'Breathing exercises, mindfulness, and instant relief techniques',
                      buttonText: 'Get Help Now',
                      onTap: () => _navigateToTab(3),
                    ),
                    FeatureCard(
                      icon: Icons.star_border,
                      title: 'Challenges',
                      description: 'Join wellness challenges and build healthy habits',
                      buttonText: 'View Goals',
                      onTap: () => _navigateToTab(4),
                    ),
                    FeatureCard(
                      icon: Icons.library_books_outlined,
                      title: 'Learn & Heal',
                      description: 'Articles, videos, and guided exercises for mental wellness',
                      buttonText: 'Explore Now',
                      onTap: () => _navigateToResources(),
                    ),
                    FeatureCard(
                      icon: Icons.people_outline,
                      title: 'Find Support',
                      description: 'Connect with mental health professionals in your area',
                      buttonText: 'Find Help',
                      onTap: () => _showComingSoon('Professional Support Directory'),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            
            // Recommended Resources
            Text(
              'Recommended for You',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.textDark,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Personalized content based on your mood patterns',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textMedium,
              ),
            ),
            const SizedBox(height: 16),
            
            SizedBox(
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ResourceCard(
                    title: 'Breathing for Anxiety',
                    description: '5-minute guided breathing exercise',
                    category: 'Mindfulness',
                    duration: '5 min',
                    imageUrl: null, // We'll use icons for now
                    onTap: () => _showComingSoon('Breathing Exercises'),
                  ),
                  const SizedBox(width: 16),
                  ResourceCard(
                    title: 'Exam Stress Relief',
                    description: 'Practical tips for managing academic pressure',
                    category: 'Study Help',
                    duration: '8 min read',
                    imageUrl: null,
                    onTap: () => _showComingSoon('Study Stress Articles'),
                  ),
                  const SizedBox(width: 16),
                  ResourceCard(
                    title: 'Sleep Better Tonight',
                    description: 'Evening routine for quality sleep',
                    category: 'Sleep',
                    duration: '10 min',
                    imageUrl: null,
                    onTap: () => _showComingSoon('Sleep Guidance'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Emergency Resources
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.errorSoft.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.errorSoft.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.emergency,
                        color: AppColors.errorSoft,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Need Immediate Help?',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.errorSoft,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'If you\'re having thoughts of self-harm or suicide, please reach out for professional help immediately.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textMedium,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _showComingSoon('Crisis Resources'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.errorSoft,
                            side: BorderSide(color: AppColors.errorSoft),
                          ),
                          child: const Text('Crisis Resources'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _showComingSoon('Emergency Call'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.errorSoft,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Call Helpline'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStat(BuildContext context, String emoji, String value, String label) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryGreen.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textDark,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTodaysMoodEmoji() {
    if (todaysMood == null) return '❓';
    switch (todaysMood) {
      case 'excellent': return '😊';
      case 'good': return '🙂';
      case 'okay': return '😐';
      case 'poor': return '😔';
      case 'terrible': return '😢';
      default: return '❓';
    }
  }

  void _navigateToTab(int tabIndex) {
    // In a real app, you'd use a tab controller or navigation
    print('Navigate to tab $tabIndex');
  }

  void _navigateToResources() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ResourcesScreen(),
      ),
    );
  }

  void _showComingSoon(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Coming Soon!'),
        content: Text('$feature will be available in a future update.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}