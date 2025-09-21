import 'package:flutter/material.dart';
import '../theme.dart';

class CustomNavBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      labelColor: AppColors.primaryPurple,
      unselectedLabelColor: AppColors.textLight,
      indicatorColor: AppColors.accentTeal,
      tabs: const [
        Tab(icon: Icon(Icons.home), text: 'Home'),
        Tab(icon: Icon(Icons.chat), text: 'AI Chat'),
        Tab(icon: Icon(Icons.people), text: 'Community'),
        Tab(icon: Icon(Icons.favorite), text: 'Mood'),
        Tab(icon: Icon(Icons.shield), text: 'Coping'),
        Tab(icon: Icon(Icons.menu_book), text: 'Resources'),
        Tab(icon: Icon(Icons.lightbulb), text: 'Challenges'),
        Tab(icon: Icon(Icons.medical_services), text: 'Professionals'),
        Tab(icon: Icon(Icons.person), text: 'Profile'),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}