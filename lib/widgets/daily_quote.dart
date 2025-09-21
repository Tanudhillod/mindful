import 'package:flutter/material.dart';
import '../theme.dart';

class DailyQuote extends StatefulWidget {
  const DailyQuote({super.key});

  @override
  State<DailyQuote> createState() => _DailyQuoteState();
}

class _DailyQuoteState extends State<DailyQuote> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, String>> quotes = [
    {
      'text': 'You are stronger than you think, braver than you believe, and more loved than you know.',
      'author': 'Mental Health Reminder'
    },
    {
      'text': 'It\'s okay to not be okay. What matters is that you\'re taking steps to care for yourself.',
      'author': 'Self-Care Wisdom'
    },
    {
      'text': 'Your mental health is just as important as your physical health. Both deserve attention and care.',
      'author': 'Wellness Truth'
    },
    {
      'text': 'Every small step forward is progress. Celebrate your efforts, no matter how small they seem.',
      'author': 'Progress Reminder'
    },
    {
      'text': 'You don\'t have to be perfect. You just have to be willing to try and keep growing.',
      'author': 'Growth Mindset'
    },
    {
      'text': 'Asking for help is not a sign of weakness. It\'s a sign of strength and self-awareness.',
      'author': 'Strength in Support'
    },
    {
      'text': 'Your feelings are valid. Your struggles are real. Your healing is possible.',
      'author': 'Validation & Hope'
    },
    {
      'text': 'Be patient with yourself. Healing is not linear, and that\'s completely normal.',
      'author': 'Patience in Healing'
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get today's quote based on the day of year to ensure consistency
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    final todaysQuote = quotes[dayOfYear % quotes.length];

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.accentLavender.withOpacity(0.2),
              AppColors.accentPeach.withOpacity(0.2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.accentLavender.withOpacity(0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.accentLavender.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.format_quote,
                    color: AppColors.accentLavender,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Daily Inspiration',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            Text(
              '"${todaysQuote['text']}"',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textDark,
                fontStyle: FontStyle.italic,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            
            Row(
              children: [
                const Spacer(),
                Text(
                  '— ${todaysQuote['author']}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textMedium,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Share button
            Row(
              children: [
                const Spacer(),
                OutlinedButton.icon(
                  onPressed: () {
                    _shareQuote(todaysQuote);
                  },
                  icon: Icon(
                    Icons.share_outlined,
                    size: 16,
                    color: AppColors.accentLavender,
                  ),
                  label: Text(
                    'Share',
                    style: TextStyle(color: AppColors.accentLavender),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.accentLavender),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _shareQuote(Map<String, String> quote) {
    // In a real app, you'd use the share_plus package
    // For now, we'll just show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Quote shared: "${quote['text']}"'),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.accentLavender,
      ),
    );
  }
}