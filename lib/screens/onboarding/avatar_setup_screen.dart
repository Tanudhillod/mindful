import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme.dart';
import 'initial_mood_screen.dart';

class AvatarSetupScreen extends StatefulWidget {
  const AvatarSetupScreen({super.key});

  @override
  State<AvatarSetupScreen> createState() => _AvatarSetupScreenState();
}

class _AvatarSetupScreenState extends State<AvatarSetupScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  String selectedAvatar = '🌱';
  
  final List<String> avatarOptions = [
    '🌱', '🌸', '🦋', '🌟', '🌙', '☀️',
    '🌊', '🍃', '🌺', '🦉', '🐛', '🌈',
    '💫', '🌷', '🌿', '🦄', '🌻', '🍀',
    '🔮', '🎋', '🌵', '🌴', '🏔️', '🌼',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Your Identity'),
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
                'Choose a nickname and avatar',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This helps personalize your experience while keeping you completely anonymous.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textMedium,
                ),
              ),
              const SizedBox(height: 32),
              
              // Nickname input
              Text(
                'What would you like to be called?',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _nicknameController,
                decoration: const InputDecoration(
                  hintText: 'Enter a nickname (e.g., StarGazer)',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                maxLength: 20,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 24),
              
              // Avatar selection
              Text(
                'Pick your avatar',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              
              // Selected avatar display
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: AppColors.primaryGreen,
                      width: 3,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      selectedAvatar,
                      style: const TextStyle(fontSize: 48),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Avatar grid
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    childAspectRatio: 1,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: avatarOptions.length,
                  itemBuilder: (context, index) {
                    final avatar = avatarOptions[index];
                    final isSelected = selectedAvatar == avatar;
                    
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedAvatar = avatar;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: isSelected 
                            ? AppColors.primaryGreen.withOpacity(0.2) 
                            : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected 
                              ? AppColors.primaryGreen 
                              : AppColors.textLight.withOpacity(0.3),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            avatar,
                            style: TextStyle(
                              fontSize: isSelected ? 28 : 24,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _nicknameController.text.trim().isNotEmpty 
                    ? _continueToNext 
                    : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _nicknameController.text.trim().isNotEmpty 
                      ? AppColors.primaryGreen 
                      : AppColors.textLight.withOpacity(0.3),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: _nicknameController.text.trim().isNotEmpty ? 4 : 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continue',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded, color: Colors.white),
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

  Future<void> _continueToNext() async {
    if (_nicknameController.text.trim().isNotEmpty) {
      // Save user identity
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_nickname', _nicknameController.text.trim());
      await prefs.setString('user_avatar', selectedAvatar);
      
      if (!mounted) return;
      
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const InitialMoodScreen(),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _nicknameController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }
}