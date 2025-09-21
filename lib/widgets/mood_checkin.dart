import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme.dart';

class MoodCheckIn extends StatefulWidget {
  const MoodCheckIn({super.key});

  @override
  State<MoodCheckIn> createState() => _MoodCheckInState();
}

class _MoodCheckInState extends State<MoodCheckIn> with TickerProviderStateMixin {
  String? selectedMood;
  String? moodNote;
  bool hasCheckedInToday = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  
  final TextEditingController _noteController = TextEditingController();
  
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
    
    _checkTodaysMood();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _checkTodaysMood() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final todayKey = '${today.year}-${today.month}-${today.day}';
    final savedMood = prefs.getString('mood_$todayKey');
    final savedNote = prefs.getString('note_$todayKey');
    
    if (savedMood != null) {
      setState(() {
        selectedMood = savedMood;
        moodNote = savedNote;
        hasCheckedInToday = true;
        _noteController.text = savedNote ?? '';
      });
    }
  }

  Future<void> _saveMood() async {
    if (selectedMood == null) return;
    
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final todayKey = '${today.year}-${today.month}-${today.day}';
    
    await prefs.setString('mood_$todayKey', selectedMood!);
    await prefs.setString('note_$todayKey', _noteController.text);
    await prefs.setString('last_mood_checkin', today.toIso8601String());
    
    // Update streak
    final currentStreak = prefs.getInt('streak_days') ?? 0;
    await prefs.setInt('streak_days', currentStreak + 1);
    
    // Update total check-ins
    final totalCheckins = prefs.getInt('total_checkins') ?? 0;
    await prefs.setInt('total_checkins', totalCheckins + 1);
    
    setState(() {
      hasCheckedInToday = true;
      moodNote = _noteController.text;
    });
    
    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Mood saved! Thank you for checking in.'),
          backgroundColor: AppColors.primaryGreen,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final dateString = '${_getMonthName(today.month)} ${today.day}, ${today.year}';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  hasCheckedInToday ? Icons.check_circle : Icons.favorite_outline,
                  color: hasCheckedInToday ? AppColors.successSoft : AppColors.primaryGreen,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hasCheckedInToday ? 'Today\'s Check-in Complete' : 'Daily Mood Check-in',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        dateString,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            if (hasCheckedInToday) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _getMoodColor(selectedMood!).withOpacity(0.1),
                      _getMoodColor(selectedMood!).withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getMoodColor(selectedMood!).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      _getMoodEmoji(selectedMood!),
                      style: const TextStyle(fontSize: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'You felt ${_getMoodLabel(selectedMood!).toLowerCase()}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: _getMoodColor(selectedMood!),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (moodNote != null && moodNote!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              '"$moodNote"',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textMedium,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          hasCheckedInToday = false;
                          selectedMood = null;
                          moodNote = null;
                          _noteController.clear();
                        });
                      },
                      child: const Text('Update'),
                    ),
                  ],
                ),
              ),
            ] else ...[
              const SizedBox(height: 20),
              Text(
                'How are you feeling right now?',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              
              // Mood selection
              ...moods.map((mood) {
                final isSelected = selectedMood == mood['id'];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
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
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isSelected 
                                ? mood['color'].withOpacity(0.1) 
                                : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected 
                                  ? mood['color'] 
                                  : AppColors.textLight.withOpacity(0.3),
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  mood['emoji'],
                                  style: TextStyle(
                                    fontSize: isSelected ? 28 : 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        mood['label'],
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          color: isSelected 
                                            ? mood['color'] 
                                            : AppColors.textDark,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        mood['description'],
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: AppColors.textMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: mood['color'],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 14,
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
              }).toList(),
              
              if (selectedMood != null) ...[
                const SizedBox(height: 16),
                TextField(
                  controller: _noteController,
                  decoration: const InputDecoration(
                    labelText: 'Add a note (optional)',
                    hintText: 'What\'s on your mind today?',
                    prefixIcon: Icon(Icons.edit_note),
                  ),
                  maxLines: 3,
                  minLines: 1,
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveMood,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.save),
                        const SizedBox(width: 8),
                        Text(
                          'Save Today\'s Mood',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month];
  }

  Color _getMoodColor(String moodId) {
    return moods.firstWhere((mood) => mood['id'] == moodId)['color'];
  }

  String _getMoodEmoji(String moodId) {
    return moods.firstWhere((mood) => mood['id'] == moodId)['emoji'];
  }

  String _getMoodLabel(String moodId) {
    return moods.firstWhere((mood) => mood['id'] == moodId)['label'];
  }
}