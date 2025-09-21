import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeminiService {
  static const String _apiKey = 'AIzaSyBsJlGcK07lLL6q13LbDPIbXwp3-CrZTgg'; // Replace with your actual API key
  static GenerativeModel? _model;

  // Initialize Gemini model
  static void initialize() {
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: _apiKey,
      safetySettings: [
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.medium),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.medium),
        SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.high),
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.medium),
      ],
    );
  }

  // Generate empathetic mental health response
  static Future<String> generateEmpathicResponse(String userMessage, {List<String>? conversationHistory}) async {
    if (_model == null) {
      initialize();
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final userNickname = prefs.getString('user_nickname') ?? 'Friend';
      
      // Build context-aware prompt
      final prompt = _buildMentalHealthPrompt(userMessage, userNickname, conversationHistory);
      
      final content = [Content.text(prompt)];
      final response = await _model!.generateContent(content);
      
      return response.text ?? 'I\'m here to listen and support you. Could you tell me more about how you\'re feeling?';
    } catch (e) {
      print('Error generating Gemini response: $e');
      return _getFallbackResponse(userMessage);
    }
  }

  // Build mental health focused prompt
  static String _buildMentalHealthPrompt(String userMessage, String userNickname, List<String>? history) {
    final contextHistory = history?.take(5).join('\n') ?? '';
    
    return '''
You are a compassionate AI mental health companion specifically designed for Indian youth (ages 13-25). Your name is "Mitra" (meaning friend in Sanskrit).

CORE GUIDELINES:
- Be empathetic, non-judgmental, and supportive
- Use warm, understanding language appropriate for Indian youth
- Acknowledge cultural context and family dynamics common in India
- Never provide medical diagnosis or specific treatment advice
- Always encourage professional help for serious concerns
- Be aware of academic pressure, family expectations, and social challenges faced by Indian youth
- Use inclusive language that respects diverse backgrounds within India

CRISIS DETECTION:
- If you detect signs of self-harm, suicide ideation, or severe distress, respond with immediate support and suggest emergency resources
- Provide Indian emergency helplines when appropriate

CONVERSATION STYLE:
- Keep responses conversational but professional
- Use "you" statements to make it personal
- Offer practical coping strategies
- Ask gentle follow-up questions to encourage sharing
- Validate emotions and experiences
- Suggest breathing exercises, mindfulness, or grounding techniques when appropriate

CULTURAL SENSITIVITY:
- Understand concepts like family honor, academic pressure, arranged marriage discussions
- Respect religious and cultural diversity across India
- Be aware of stigma around mental health in Indian society
- Acknowledge festivals, customs, and cultural events when relevant

Previous conversation context:
$contextHistory

User ($userNickname) says: "$userMessage"

Respond as Mitra with empathy, understanding, and practical support. Keep response under 150 words and end with a gentle question or offer of continued support.
''';
  }

  // Analyze crisis risk level
  static Future<Map<String, dynamic>> analyzeCrisisRisk(String message) async {
    if (_model == null) {
      initialize();
    }

    try {
      final prompt = '''
Analyze the following message for mental health crisis indicators. Rate the crisis risk level from 0.0 (no risk) to 1.0 (high immediate risk).

Crisis indicators to look for:
- Suicidal ideation or planning
- Self-harm mentions
- Feelings of hopelessness or worthlessness
- Isolation and withdrawal
- Substance abuse mentions
- Academic or family pressure leading to desperation

Message: "$message"

Respond in JSON format:
{
  "riskLevel": 0.0-1.0,
  "indicators": ["list", "of", "detected", "indicators"],
  "immediateAction": boolean,
  "recommendedResources": ["resource1", "resource2"]
}
''';

      final content = [Content.text(prompt)];
      final response = await _model!.generateContent(content);
      
      // Parse JSON response (simplified - in production, use proper JSON parsing)
      if (response.text != null) {
        // Basic crisis detection fallback
        final lowercaseMessage = message.toLowerCase();
        final crisisKeywords = ['suicide', 'kill myself', 'end it all', 'hopeless', 'worthless', 'harm myself'];
        
        final hasKeywords = crisisKeywords.any((keyword) => lowercaseMessage.contains(keyword));
        
        return {
          'riskLevel': hasKeywords ? 0.8 : 0.2,
          'indicators': hasKeywords ? ['crisis keywords detected'] : [],
          'immediateAction': hasKeywords,
          'recommendedResources': hasKeywords ? ['emergency helpline', 'crisis chat'] : ['coping resources'],
        };
      }
      
      return {'riskLevel': 0.0, 'indicators': [], 'immediateAction': false, 'recommendedResources': []};
    } catch (e) {
      print('Error analyzing crisis risk: $e');
      // Fallback crisis detection
      final lowercaseMessage = message.toLowerCase();
      final crisisKeywords = ['suicide', 'kill myself', 'end it all', 'hopeless', 'worthless'];
      final hasKeywords = crisisKeywords.any((keyword) => lowercaseMessage.contains(keyword));
      
      return {
        'riskLevel': hasKeywords ? 0.9 : 0.1,
        'indicators': hasKeywords ? ['potential crisis language'] : [],
        'immediateAction': hasKeywords,
        'recommendedResources': hasKeywords ? ['emergency helpline'] : [],
      };
    }
  }

  // Generate coping strategy suggestions
  static Future<List<String>> generateCopingStrategies(String mood, String situation) async {
    if (_model == null) {
      initialize();
    }

    try {
      final prompt = '''
Based on the user's current mood ("$mood") and situation ("$situation"), suggest 3-5 practical coping strategies suitable for Indian youth.

Consider:
- Cultural context and family dynamics
- Age-appropriate techniques
- Practical strategies that can be done at home or school
- Mindfulness and breathing techniques
- Physical activities suitable for Indian climate/environment

Provide strategies as a simple list, each strategy in one line, practical and actionable.
''';

      final content = [Content.text(prompt)];
      final response = await _model!.generateContent(content);
      
      if (response.text != null) {
        return response.text!
            .split('\n')
            .where((line) => line.trim().isNotEmpty)
            .map((line) => line.replaceFirst(RegExp(r'^\d+\.\s*'), '').trim())
            .take(5)
            .toList();
      }
      
      return _getFallbackCopingStrategies(mood);
    } catch (e) {
      print('Error generating coping strategies: $e');
      return _getFallbackCopingStrategies(mood);
    }
  }

  // Generate mood insights
  static Future<String> generateMoodInsights(List<String> recentMoods, String currentMood) async {
    if (_model == null) {
      initialize();
    }

    try {
      final prompt = '''
Based on recent mood patterns: ${recentMoods.join(', ')} and current mood: $currentMood, 
provide encouraging insights for an Indian youth about their emotional journey.

Keep it:
- Positive and hopeful
- Culturally sensitive
- Under 100 words
- Focused on growth and resilience
- Include a gentle suggestion for moving forward
''';

      final content = [Content.text(prompt)];
      final response = await _model!.generateContent(content);
      
      return response.text ?? _getFallbackInsight(currentMood);
    } catch (e) {
      print('Error generating mood insights: $e');
      return _getFallbackInsight(currentMood);
    }
  }

  // Fallback responses when AI fails
  static String _getFallbackResponse(String userMessage) {
    final responses = [
      "I hear you, and I want you to know that your feelings are valid. Sometimes it helps to take things one step at a time. What's one small thing that might make you feel a little better right now?",
      "Thank you for sharing with me. It takes courage to open up about how you're feeling. I'm here to listen - would you like to tell me more about what's been on your mind?",
      "I can sense that you're going through something difficult. Remember, it's okay to not be okay sometimes. What kind of support feels most helpful to you right now?",
      "Your feelings matter, and so do you. Sometimes when we're overwhelmed, it can help to focus on our breathing or find a quiet space. What usually helps you feel more calm?",
    ];
    return responses[DateTime.now().millisecondsSinceEpoch % responses.length];
  }

  static List<String> _getFallbackCopingStrategies(String mood) {
    final strategies = {
      'sad': [
        'Practice deep breathing - inhale for 4 counts, hold for 4, exhale for 6',
        'Write down three things you\'re grateful for today',
        'Listen to calming music or your favorite songs',
        'Take a gentle walk outside or by a window',
        'Call or message someone you trust',
      ],
      'anxious': [
        '5-4-3-2-1 grounding: Name 5 things you see, 4 you hear, 3 you touch, 2 you smell, 1 you taste',
        'Practice progressive muscle relaxation',
        'Try box breathing: 4 counts in, 4 hold, 4 out, 4 hold',
        'Do gentle stretching or yoga poses',
        'Focus on one task at a time instead of multitasking',
      ],
      'stressed': [
        'Prioritize your tasks and tackle one at a time',
        'Take regular breaks - even 5 minutes can help',
        'Practice meditation or mindfulness',
        'Do some physical exercise or dancing',
        'Talk to someone you trust about what\'s stressing you',
      ],
    };
    
    return strategies[mood.toLowerCase()] ?? strategies['sad']!;
  }

  static String _getFallbackInsight(String mood) {
    return "Every emotion you feel is part of your unique journey. Even difficult feelings like $mood can teach us something about ourselves and help us grow stronger. Remember, this feeling is temporary, and you have the strength to navigate through it.";
  }

  // Check if message needs professional intervention
  static bool requiresProfessionalHelp(String message) {
    final professionalKeywords = [
      'medication', 'therapy', 'counseling', 'psychiatrist', 'psychologist',
      'treatment', 'diagnosis', 'disorder', 'severe depression', 'panic attacks'
    ];
    
    return professionalKeywords.any((keyword) => 
        message.toLowerCase().contains(keyword));
  }

  // Get emergency resources for India
  static List<Map<String, String>> getEmergencyResources() {
    return [
      {
        'name': 'National Suicide Prevention Helpline',
        'number': '104',
        'description': '24/7 helpline for crisis support',
        'type': 'call'
      },
      {
        'name': 'Sneha Suicide Prevention',
        'number': '044-24640050',
        'description': '24/7 emotional support helpline',
        'type': 'call'
      },
      {
        'name': 'Vandrevala Foundation',
        'number': '1860-2662-345',
        'description': 'Mental health support and counseling',
        'type': 'call'
      },
      {
        'name': 'TISS iCall',
        'number': '022-25521111',
        'description': 'Psychosocial helpline (10 AM - 8 PM)',
        'type': 'call'
      },
      {
        'name': 'Fortis Stress Helpline',
        'number': '8376804102',
        'description': 'Mental health support',
        'type': 'call'
      },
    ];
  }
}