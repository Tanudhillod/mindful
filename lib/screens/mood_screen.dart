import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import '../widgets/mood_checkin.dart';
import '../widgets/mood_trends.dart';
import '../widgets/mood_insights.dart';
import '../theme.dart';

class MoodScreen extends StatefulWidget {
  const MoodScreen({super.key});

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  Map<DateTime, String> _moodData = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadMoodData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadMoodData() async {
    final prefs = await SharedPreferences.getInstance();
    final moodDataString = prefs.getString('mood_data') ?? '{}';
    
    // In a real app, you'd parse JSON data here
    // For now, we'll simulate some mood data
    setState(() {
      _moodData = _generateSampleMoodData();
    });
  }

  Map<DateTime, String> _generateSampleMoodData() {
    final Map<DateTime, String> sampleData = {};
    final now = DateTime.now();
    
    for (int i = 0; i < 30; i++) {
      final date = now.subtract(Duration(days: i));
      final moods = ['excellent', 'good', 'okay', 'poor', 'terrible'];
      sampleData[DateTime(date.year, date.month, date.day)] = 
          moods[i % moods.length];
    }
    
    return sampleData;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tab bar
        Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: AppColors.primaryGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.white,
            unselectedLabelColor: AppColors.textMedium,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
            tabs: const [
              Tab(text: 'Check-in'),
              Tab(text: 'Calendar'),
              Tab(text: 'Insights'),
            ],
          ),
        ),
        
        // Tab views
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Check-in tab
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'How are you feeling today?',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Take a moment to check in with yourself. Your mood patterns help us provide better support.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textMedium,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const MoodCheckIn(),
                      const SizedBox(height: 32),
                      const MoodTrends(),
                    ],
                  ),
                ),
              ),
              
              // Calendar tab
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mood Calendar',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'View your mood patterns over time',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textMedium,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Mood legend
                      _buildMoodLegend(),
                      const SizedBox(height: 16),
                      
                      // Calendar
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: TableCalendar<String>(
                            firstDay: DateTime.utc(2020, 1, 1),
                            lastDay: DateTime.utc(2030, 12, 31),
                            focusedDay: _focusedDay,
                            selectedDayPredicate: (day) {
                              return isSameDay(_selectedDay, day);
                            },
                            eventLoader: (day) {
                              final normalizedDay = DateTime(day.year, day.month, day.day);
                              return _moodData[normalizedDay] != null ? [_moodData[normalizedDay]!] : [];
                            },
                            calendarBuilders: CalendarBuilders(
                              defaultBuilder: (context, date, _) {
                                return _buildCalendarDay(date, _moodData[DateTime(date.year, date.month, date.day)]);
                              },
                              todayBuilder: (context, date, _) {
                                return _buildCalendarDay(date, _moodData[DateTime(date.year, date.month, date.day)], isToday: true);
                              },
                              selectedBuilder: (context, date, _) {
                                return _buildCalendarDay(date, _moodData[DateTime(date.year, date.month, date.day)], isSelected: true);
                              },
                            ),
                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                _selectedDay = selectedDay;
                                _focusedDay = focusedDay;
                              });
                            },
                            calendarStyle: CalendarStyle(
                              outsideDaysVisible: false,
                              weekendTextStyle: TextStyle(color: AppColors.textMedium),
                              holidayTextStyle: TextStyle(color: AppColors.errorSoft),
                            ),
                            headerStyle: HeaderStyle(
                              formatButtonVisible: false,
                              titleCentered: true,
                              decoration: BoxDecoration(
                                color: AppColors.primaryGreen.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              titleTextStyle: TextStyle(
                                color: AppColors.primaryGreen,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      // Selected day info
                      if (_moodData[DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day)] != null) ...[
                        const SizedBox(height: 16),
                        _buildSelectedDayInfo(),
                      ],
                    ],
                  ),
                ),
              ),
              
              // Insights tab
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Mood Insights',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'AI-generated insights based on your mood patterns',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textMedium,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const MoodInsights(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMoodLegend() {
    final moods = [
      {'id': 'excellent', 'emoji': '😊', 'label': 'Excellent', 'color': AppColors.moodExcellent},
      {'id': 'good', 'emoji': '🙂', 'label': 'Good', 'color': AppColors.moodGood},
      {'id': 'okay', 'emoji': '😐', 'label': 'Okay', 'color': AppColors.moodOkay},
      {'id': 'poor', 'emoji': '😔', 'label': 'Poor', 'color': AppColors.moodPoor},
      {'id': 'terrible', 'emoji': '😢', 'label': 'Terrible', 'color': AppColors.moodTerrible},
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mood Legend',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textDark,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: moods.map((mood) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: mood['color'] as Color,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${mood['emoji']} ${mood['label']}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textMedium,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarDay(DateTime date, String? mood, {bool isToday = false, bool isSelected = false}) {
    Color backgroundColor = Colors.transparent;
    Color borderColor = Colors.transparent;
    
    if (mood != null) {
      switch (mood) {
        case 'excellent':
          backgroundColor = AppColors.moodExcellent.withOpacity(0.7);
          break;
        case 'good':
          backgroundColor = AppColors.moodGood.withOpacity(0.7);
          break;
        case 'okay':
          backgroundColor = AppColors.moodOkay.withOpacity(0.7);
          break;
        case 'poor':
          backgroundColor = AppColors.moodPoor.withOpacity(0.7);
          break;
        case 'terrible':
          backgroundColor = AppColors.moodTerrible.withOpacity(0.7);
          break;
      }
    }
    
    if (isToday) {
      borderColor = AppColors.primaryGreen;
    } else if (isSelected) {
      borderColor = AppColors.primaryBlue;
    }

    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: borderColor,
          width: isToday || isSelected ? 2 : 0,
        ),
      ),
      child: Center(
        child: Text(
          '${date.day}',
          style: TextStyle(
            color: mood != null ? Colors.white : AppColors.textDark,
            fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedDayInfo() {
    final mood = _moodData[DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day)];
    
    if (mood == null) return const SizedBox.shrink();

    final moodInfo = {
      'excellent': {'emoji': '😊', 'label': 'Excellent', 'color': AppColors.moodExcellent},
      'good': {'emoji': '🙂', 'label': 'Good', 'color': AppColors.moodGood},
      'okay': {'emoji': '😐', 'label': 'Okay', 'color': AppColors.moodOkay},
      'poor': {'emoji': '😔', 'label': 'Poor', 'color': AppColors.moodPoor},
      'terrible': {'emoji': '😢', 'label': 'Terrible', 'color': AppColors.moodTerrible},
    }[mood];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selected Day: ${_selectedDay.day}/${_selectedDay.month}/${_selectedDay.year}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textDark,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  moodInfo!['emoji'] as String,
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mood: ${moodInfo['label']}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: moodInfo['color'] as Color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'You were feeling ${(moodInfo['label'] as String).toLowerCase()} on this day.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}