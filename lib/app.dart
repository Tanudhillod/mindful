import 'package:flutter/material.dart';
import 'theme.dart';
import 'widgets/nav_bar.dart';
import 'screens/home_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/mood_screen.dart';
import 'screens/coping_screen.dart';
import 'screens/challenges_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mindful',
      theme: appTheme,
      home: const MainScaffold(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScaffold extends StatelessWidget {
  const MainScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mindful', style: TextStyle(color: AppColors.primaryPurple)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.lightBlue, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          bottom: const CustomNavBar(),
        ),
        body: const TabBarView(
          children: [
            HomeScreen(),
            ChatScreen(),
            MoodScreen(),
            CopingScreen(),
            ChallengesScreen(),
          ],
        ),
      ),
    );
  }
}