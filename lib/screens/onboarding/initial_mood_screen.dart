import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme.dart';
import '../main_screen.dart';

class InitialMoodScreen extends StatefulWidget {
  const InitialMoodScreen({super.key});

  @override
  State<InitialMoodScreen> createState() => _InitialMoodScreenState();
}

class _InitialMoodScreenState extends State<InitialMoodScreen> 
    with TickerProviderStateMixin {
  String? selectedMood;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  
  final List<Map<String, dynamic>> moods = [
    {
      'id': 'excellent',
      'emoji': '😊',
      'label': 'Excellent',
      'color': AppColors.moodExcellent,
      'description': 'Feeling amazing and energetic'
    },
    {
      'id': 'good',
      'emoji': '🙂',
      'label': 'Good',
      'color': AppColors.moodGood,
      'description': 'Generally positive and content'
    },
    {
      'id': 'okay',
      'emoji': '😐',
      'label': 'Okay',
      'color': AppColors.moodOkay,
      'description': 'Neutral, neither good nor bad'
    },
    {
      'id': 'poor',
      'emoji': '😔',
      'label': 'Poor',
      'color': AppColors.moodPoor,
      'description': 'Feeling down or stressed'
    },
    {
      'id': 'terrible',
      'emoji': '😢',
      'label': 'Terrible',
      'color': AppColors.moodTerrible,
      'description': 'Having a really tough time'
    },
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('How are you feeling?'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Let\'s start with a mood check-in',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This helps us understand how to best support you today. Your mood will remain completely private.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textMedium,
                ),
              ),
              const SizedBox(height: 40),
              
              Expanded(
                child: ListView.builder(
                  itemCount: moods.length,
                  itemBuilder: (context, index) {
                    final mood = moods[index];
                    final isSelected = selectedMood == mood['id'];
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedMood = mood['id'];
                          });
                        },
                        child: AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: isSelected ? _pulseAnimation.value : 1.0,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: isSelected 
                                    ? mood['color'].withOpacity(0.1) 
                                    : Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected 
                                      ? mood['color'] 
                                      : AppColors.textLight.withOpacity(0.3),
                                    width: isSelected ? 3 : 1,
                                  ),
                                  boxShadow: [
                                    if (isSelected)
                                      BoxShadow(
                                        color: mood['color'].withOpacity(0.2),
                                        blurRadius: 12,
                                        offset: const Offset(0, 6),
                                      ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      mood['emoji'],
                                      style: TextStyle(
                                        fontSize: isSelected ? 36 : 32,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            mood['label'],
                                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                              color: isSelected 
                                                ? mood['color'] 
                                                : AppColors.textDark,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            mood['description'],
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                              color: AppColors.textMedium,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (isSelected)
                                      Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: mood['color'],
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: selectedMood != null ? _completeOnboarding : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedMood != null 
                      ? AppColors.primaryGreen 
                      : AppColors.textLight.withOpacity(0.3),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: selectedMood != null ? 4 : 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Complete Setup',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.check_circle_outline, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _completeOnboarding() async {
    if (selectedMood != null) {
      // Save initial mood and complete onboarding
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('initial_mood', selectedMood!);
      await prefs.setBool('completed_onboarding', true);
      await prefs.setString('last_mood_checkin', DateTime.now().toIso8601String());
      
      if (!mounted) return;
      
      // Navigate to main app
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MainScreen()),
        (route) => false,
      );
    }
  }
}