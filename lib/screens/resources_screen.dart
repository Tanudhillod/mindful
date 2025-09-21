import 'package:flutter/material.dart';
import '../widgets/resource_card.dart';
import '../theme.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  String selectedCategory = 'All';
  
  final List<String> categories = [
    'All',
    'Mindfulness',
    'Study Help',
    'Sleep',
    'Anxiety',
    'Depression',
    'Relationships',
  ];

  final List<Map<String, dynamic>> resources = [
    {
      'title': '5-Minute Breathing Exercise',
      'description': 'Quick breathing technique to calm anxiety and stress',
      'category': 'Mindfulness',
      'duration': '5 min',
      'type': 'Exercise',
      'difficulty': 'Beginner',
    },
    {
      'title': 'Managing Exam Stress',
      'description': 'Practical strategies to handle academic pressure effectively',
      'category': 'Study Help',
      'duration': '10 min read',
      'type': 'Article',
      'difficulty': 'Beginner',
    },
    {
      'title': 'Progressive Muscle Relaxation',
      'description': 'Full-body relaxation technique for better sleep',
      'category': 'Sleep',
      'duration': '15 min',
      'type': 'Exercise',
      'difficulty': 'Intermediate',
    },
    {
      'title': 'Understanding Anxiety',
      'description': 'Learn about anxiety symptoms and coping strategies',
      'category': 'Anxiety',
      'duration': '12 min read',
      'type': 'Article',
      'difficulty': 'Beginner',
    },
    {
      'title': 'Mindful Walking',
      'description': 'Turn daily walks into mindfulness practice',
      'category': 'Mindfulness',
      'duration': '8 min',
      'type': 'Exercise',
      'difficulty': 'Beginner',
    },
    {
      'title': 'Sleep Hygiene Guide',
      'description': 'Evidence-based tips for better sleep quality',
      'category': 'Sleep',
      'duration': '15 min read',
      'type': 'Guide',
      'difficulty': 'Beginner',
    },
    {
      'title': 'Dealing with Sadness',
      'description': 'Healthy ways to process and cope with low moods',
      'category': 'Depression',
      'duration': '10 min read',
      'type': 'Article',
      'difficulty': 'Intermediate',
    },
    {
      'title': 'Communication Skills',
      'description': 'Improve relationships through better communication',
      'category': 'Relationships',
      'duration': '20 min read',
      'type': 'Guide',
      'difficulty': 'Intermediate',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredResources {
    if (selectedCategory == 'All') {
      return resources;
    }
    return resources.where((resource) => resource['category'] == selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn & Heal'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryGreen.withOpacity(0.1),
                  AppColors.primaryBlue.withOpacity(0.1),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Wellness Library',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Evidence-based resources and exercises to support your mental health journey',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textMedium,
                  ),
                ),
              ],
            ),
          ),
          
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
              tabs: const [
                Tab(text: 'All Resources'),
                Tab(text: 'Categories'),
                Tab(text: 'Favorites'),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // All Resources Tab
                _buildResourcesList(),
                
                // Categories Tab
                _buildCategoriesView(),
                
                // Favorites Tab
                _buildFavoritesView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourcesList() {
    return Column(
      children: [
        // Category filter
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = selectedCategory == category;
              
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                  selectedColor: AppColors.primaryGreen.withOpacity(0.2),
                  checkmarkColor: AppColors.primaryGreen,
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.primaryGreen : AppColors.textMedium,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              );
            },
          ),
        ),
        
        // Resources grid
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75, // Increased from 0.8 to give more height
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: filteredResources.length,
              itemBuilder: (context, index) {
                final resource = filteredResources[index];
                return _buildResourceCard(resource);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResourceCard(Map<String, dynamic> resource) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon
          Container(
            height: 50, // Reduced from 60 to save space
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _getCategoryColor(resource['category']).withOpacity(0.3),
                  _getCategoryColor(resource['category']).withOpacity(0.1),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12), // Reduced padding
                Icon(
                  _getCategoryIcon(resource['category']),
                  color: _getCategoryColor(resource['category']),
                  size: 20, // Reduced from 24
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), // Reduced padding
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    resource['type'],
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _getCategoryColor(resource['category']),
                      fontWeight: FontWeight.w600,
                      fontSize: 10, // Smaller text
                    ),
                  ),
                ),
                const SizedBox(width: 12), // Reduced padding
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12), // Reduced from 16
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    resource['title'],
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w600,
                      fontSize: 13, // Slightly smaller
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6), // Reduced spacing
                  Expanded(
                    child: Text(
                      resource['description'],
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textMedium,
                        fontSize: 11, // Smaller text
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 8), // Reduced spacing
                  
                  // Footer with duration and difficulty
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 12, // Smaller icon
                        color: AppColors.textLight,
                      ),
                      const SizedBox(width: 3), // Reduced spacing
                      Flexible(
                        child: Text(
                          resource['duration'],
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textLight,
                            fontSize: 10, // Smaller text
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1), // Reduced padding
                        decoration: BoxDecoration(
                          color: _getDifficultyColor(resource['difficulty']).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(3), // Smaller radius
                        ),
                        child: Text(
                          resource['difficulty'],
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: _getDifficultyColor(resource['difficulty']),
                            fontSize: 9, // Smaller text
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesView() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: categories.where((cat) => cat != 'All').length,
        itemBuilder: (context, index) {
          final category = categories.where((cat) => cat != 'All').toList()[index];
          final resourceCount = resources.where((r) => r['category'] == category).length;
          
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = category;
                _tabController.animateTo(0);
              });
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getCategoryColor(category).withOpacity(0.2),
                    _getCategoryColor(category).withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _getCategoryColor(category).withOpacity(0.3),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getCategoryIcon(category),
                    size: 40,
                    color: _getCategoryColor(category),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    category,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$resourceCount resources',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textMedium,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFavoritesView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 64,
              color: AppColors.textLight,
            ),
            const SizedBox(height: 16),
            Text(
              'No Favorites Yet',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.textMedium,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Mark resources as favorites to see them here',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'mindfulness':
        return AppColors.primaryGreen;
      case 'study help':
        return AppColors.primaryBlue;
      case 'sleep':
        return AppColors.accentLavender;
      case 'anxiety':
        return AppColors.accentPeach;
      case 'depression':
        return AppColors.moodPoor;
      case 'relationships':
        return AppColors.moodGood;
      default:
        return AppColors.primaryGreen;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'mindfulness':
        return Icons.spa_outlined;
      case 'study help':
        return Icons.school_outlined;
      case 'sleep':
        return Icons.nightlight_round_outlined;
      case 'anxiety':
        return Icons.psychology_outlined;
      case 'depression':
        return Icons.favorite_outline;
      case 'relationships':
        return Icons.people_outline;
      default:
        return Icons.lightbulb_outline;
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return AppColors.successSoft;
      case 'intermediate':
        return AppColors.warningAmber;
      case 'advanced':
        return AppColors.errorSoft;
      default:
        return AppColors.textMedium;
    }
  }
}