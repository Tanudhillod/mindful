import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme.dart';
import 'onboarding/welcome_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userNickname = '';
  String userAvatar = '🌱';
  String preferredLanguage = '';
  int streakDays = 0;
  int totalCheckins = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userNickname = prefs.getString('user_nickname') ?? 'Friend';
      userAvatar = prefs.getString('user_avatar') ?? '🌱';
      preferredLanguage = prefs.getString('preferred_language') ?? 'en';
      streakDays = prefs.getInt('streak_days') ?? 0;
      totalCheckins = prefs.getInt('total_checkins') ?? 0;
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
            // Profile Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(
                          color: AppColors.primaryGreen,
                          width: 3,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          userAvatar,
                          style: const TextStyle(fontSize: 36),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      userNickname,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Anonymous Mindful User',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Stats Row
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    '🔥',
                    '$streakDays Days',
                    'Current Streak',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    context,
                    '📝',
                    '$totalCheckins',
                    'Total Check-ins',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Settings Section
            Text(
              'Settings',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.textDark,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildSettingsItem(
              context,
              Icons.language_outlined,
              'Language',
              _getLanguageName(preferredLanguage),
              () {
                // TODO: Open language selection
              },
            ),
            
            _buildSettingsItem(
              context,
              Icons.notifications_outlined,
              'Notifications',
              'Daily reminders',
              () {
                // TODO: Open notifications settings
              },
            ),
            
            _buildSettingsItem(
              context,
              Icons.security_outlined,
              'Privacy',
              'Manage your data',
              () {
                _showPrivacyDialog();
              },
            ),
            
            _buildSettingsItem(
              context,
              Icons.help_outline,
              'Help & Support',
              'Get help or report issues',
              () {
                // TODO: Open help screen
              },
            ),
            
            _buildSettingsItem(
              context,
              Icons.info_outline,
              'About',
              'App version & credits',
              () {
                _showAboutDialog();
              },
            ),
            
            const SizedBox(height: 32),
            
            // Emergency Resources
            Card(
              color: AppColors.errorSoft.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
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
                          'Emergency Resources',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.errorSoft,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'If you\'re having thoughts of self-harm or suicide, please reach out for immediate help.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textMedium,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Open emergency resources
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.errorSoft,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('View Crisis Resources'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            // Reset App Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _showResetDialog,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.errorSoft,
                  side: const BorderSide(color: AppColors.errorSoft),
                ),
                child: const Text('Reset App Data'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String emoji, String value, String label) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.textDark,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textMedium,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primaryGreen),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.textDark,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textMedium,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'hi': return 'Hindi';
      case 'ta': return 'Tamil';
      case 'te': return 'Telugu';
      case 'mr': return 'Marathi';
      case 'bn': return 'Bengali';
      case 'gu': return 'Gujarati';
      case 'kn': return 'Kannada';
      case 'ml': return 'Malayalam';
      case 'pa': return 'Punjabi';
      default: return 'English';
    }
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy & Security'),
        content: const Text(
          'Your privacy is our top priority:\n\n'
          '• All data is stored anonymously\n'
          '• No personal information is collected\n'
          '• Conversations are encrypted\n'
          '• You can delete all data anytime\n'
          '• No data is shared with third parties',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Mindful'),
        content: const Text(
          'Mindful v1.0.0\n\n'
          'An AI-powered mental wellness companion for Indian youth.\n\n'
          'Built with privacy, empathy, and cultural sensitivity at its core.\n\n'
          'Powered by Google Cloud AI',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset App Data'),
        content: const Text(
          'This will permanently delete all your data including mood history, preferences, and progress. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _resetAppData();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.errorSoft),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  Future<void> _resetAppData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    if (!mounted) return;
    
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      (route) => false,
    );
  }
}