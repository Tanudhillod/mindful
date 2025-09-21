import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme.dart';

class EmergencyDialog extends StatelessWidget {
  const EmergencyDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Row(
        children: [
          Icon(
            Icons.emergency,
            color: AppColors.errorSoft,
            size: 28,
          ),
          const SizedBox(width: 12),
          const Text(
            'Crisis Resources',
            style: TextStyle(
              color: AppColors.errorSoft,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'If you\'re having thoughts of self-harm or suicide, please reach out for immediate help. You\'re not alone.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textMedium,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            
            _buildEmergencyResource(
              context,
              '🇮🇳 National Crisis Helpline',
              'KIRAN Mental Health Helpline',
              '1800-599-0019',
              'Free, 24/7 mental health support',
            ),
            
            _buildEmergencyResource(
              context,
              '🏥 Emergency Services',
              'Medical Emergency',
              '108',
              'Immediate medical assistance',
            ),
            
            _buildEmergencyResource(
              context,
              '💬 Text Support',
              'Crisis Text Line India',
              'Text HELLO to 741741',
              'Anonymous crisis counseling',
            ),
            
            _buildEmergencyResource(
              context,
              '🧠 Mental Health First Aid',
              'Vandrevala Foundation',
              '9999666555',
              '24x7 free mental health support',
            ),
            
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primaryGreen.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Remember:',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Your life has value and meaning\n'
                    '• This pain is temporary\n'
                    '• Professional help is available\n'
                    '• You deserve support and care',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textMedium,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'I\'m Safe',
            style: TextStyle(color: AppColors.textMedium),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            _makeEmergencyCall('1800-599-0019');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.errorSoft,
            foregroundColor: Colors.white,
          ),
          child: const Text('Call Now'),
        ),
      ],
    );
  }

  Widget _buildEmergencyResource(
    BuildContext context,
    String emoji,
    String title,
    String contact,
    String description,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    contact,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textMedium,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () => _makeEmergencyCall(contact),
                  icon: const Icon(Icons.phone),
                  color: AppColors.primaryGreen,
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen.withOpacity(0.1),
                  ),
                ),
                IconButton(
                  onPressed: () => _copyToClipboard(context, contact),
                  icon: const Icon(Icons.copy),
                  color: AppColors.textMedium,
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.textLight.withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _makeEmergencyCall(String phoneNumber) {
    // In a real app, this would use url_launcher to make a phone call
    // For now, we'll just show a message
    print('Calling $phoneNumber');
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied $text to clipboard'),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
  }
}