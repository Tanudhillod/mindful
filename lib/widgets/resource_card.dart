import 'package:flutter/material.dart';
import '../theme.dart';

class ResourceCard extends StatelessWidget {
  final String title;
  final String description;
  final String category;
  final String duration;
  final String? imageUrl;
  final VoidCallback onTap;

  const ResourceCard({
    super.key,
    required this.title,
    required this.description,
    required this.category,
    required this.duration,
    this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 4),
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
            // Image or icon placeholder
            Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getCategoryColor().withOpacity(0.3),
                    _getCategoryColor().withOpacity(0.1),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Center(
                child: Icon(
                  _getCategoryIcon(),
                  size: 32,
                  color: _getCategoryColor(),
                ),
              ),
            ),
            
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category and duration
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getCategoryColor().withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            category,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: _getCategoryColor(),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          duration,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Title
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    
                    // Description
                    Expanded(
                      child: Text(
                        description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textMedium,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor() {
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

  IconData _getCategoryIcon() {
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
}