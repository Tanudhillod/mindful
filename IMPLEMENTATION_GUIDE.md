# Mindful - AI-Powered Mental Wellness Platform

## Overview

Mindful is a comprehensive, privacy-focused mental wellness platform designed specifically for Indian youth. The app leverages Google Cloud's advanced AI capabilities to provide empathetic, culturally-sensitive mental health support while maintaining strict privacy and anonymity standards.

## Architecture Overview

### Frontend (Flutter Mobile App)
- **Framework**: Flutter with Material Design 3
- **State Management**: SharedPreferences for local anonymous storage
- **UI Components**: Custom themed widgets with nature-inspired design
- **Navigation**: Bottom tab navigation with 8 main sections

### Backend & Cloud Infrastructure (Google Cloud Platform)

#### Core Services
1. **Firebase Authentication** - Anonymous authentication
2. **Cloud Firestore** - Encrypted data storage
3. **Vertex AI** - Conversational AI and content generation
4. **Dialogflow CX** - Advanced conversation management
5. **Cloud Functions** - Serverless backend logic
6. **BigQuery** - Analytics and insights (anonymized)
7. **Cloud Storage** - Secure file storage
8. **Cloud Run** - Containerized services

## Data Flow Architecture

### 1. User Onboarding Flow
```
User Device → Firebase Auth (Anonymous) → Generate Unique ID → Store Preferences Locally
```

### 2. Chat & AI Interaction Flow
```
User Message → Local Preprocessing → Cloud Functions → Vertex AI API → 
Crisis Detection → Response Generation → Local Storage → UI Update
```

### 3. Mood Tracking Flow
```
Mood Input → Local Storage → Cloud Functions → Encrypted Firestore → 
Analytics Processing → Insights Generation → Local Cache
```

### 4. Professional Directory Flow
```
Search Query → Cloud Functions → Firestore → Filter Results → 
AI Matching → Return Recommendations → UI Display
```

## Security & Privacy Implementation

### Data Privacy Principles
1. **Anonymous by Design**: No personal identifiers collected
2. **Local-First Storage**: Sensitive data stored locally when possible
3. **Encryption at Rest**: All cloud data encrypted with AES-256
4. **Encryption in Transit**: TLS 1.3 for all communications
5. **Data Minimization**: Only necessary data collected and processed

### Authentication & Identity
```dart
// Anonymous Authentication Implementation
class AuthService {
  static Future<String> signInAnonymously() async {
    try {
      final userCredential = await FirebaseAuth.instance.signInAnonymously();
      final uid = userCredential.user?.uid;
      
      // Generate local anonymous ID
      final localId = await generateSecureLocalId();
      await storeLocalCredentials(uid, localId);
      
      return localId;
    } catch (e) {
      throw AuthException('Anonymous authentication failed');
    }
  }
  
  static Future<String> generateSecureLocalId() async {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (i) => random.nextInt(256));
    return base64Url.encode(bytes);
  }
}
```

### Data Encryption
```dart
// Local Data Encryption
class EncryptionService {
  static final _key = Hive.generateSecureKey();
  
  static Future<void> storeEncryptedData(String key, dynamic data) async {
    final box = await Hive.openBox('encrypted_data', encryptionCipher: HiveAesCipher(_key));
    await box.put(key, data);
  }
  
  static Future<T?> getEncryptedData<T>(String key) async {
    final box = await Hive.openBox('encrypted_data', encryptionCipher: HiveAesCipher(_key));
    return box.get(key) as T?;
  }
}
```

## Google Cloud Integration

### 1. Vertex AI Configuration

#### Setup Instructions
```bash
# Enable Vertex AI API
gcloud services enable aiplatform.googleapis.com

# Set up service account
gcloud iam service-accounts create mindful-ai-service \
    --description="Service account for Mindful AI features" \
    --display-name="Mindful AI Service"

# Grant necessary permissions
gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
    --member="serviceAccount:mindful-ai-service@YOUR_PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/aiplatform.user"
```

#### AI Service Implementation
```dart
class VertexAIService {
  static const String projectId = 'your-project-id';
  static const String location = 'us-central1';
  
  static Future<String> generateEmpathicResponse(String userMessage, String context) async {
    final prompt = buildEmpathicPrompt(userMessage, context);
    
    final request = {
      'instances': [
        {
          'prompt': prompt,
          'parameters': {
            'temperature': 0.7,
            'maxOutputTokens': 200,
            'topP': 0.8,
            'topK': 40,
          }
        }
      ]
    };
    
    try {
      final response = await http.post(
        Uri.parse('https://$location-aiplatform.googleapis.com/v1/projects/$projectId/locations/$location/publishers/google/models/text-bison:predict'),
        headers: {
          'Authorization': 'Bearer ${await getAccessToken()}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request),
      );
      
      final data = jsonDecode(response.body);
      return data['predictions'][0]['content'];
    } catch (e) {
      throw AIServiceException('Failed to generate response: $e');
    }
  }
  
  static String buildEmpathicPrompt(String userMessage, String context) {
    return '''
You are a compassionate AI mental health companion for Indian youth. 
Your responses should be:
- Empathetic and non-judgmental
- Culturally sensitive to Indian context
- Encouraging and supportive
- Include appropriate mental health resources when needed

Context: $context
User message: $userMessage

Response:
''';
  }
}
```

### 2. Crisis Detection System
```dart
class CrisisDetectionService {
  static const List<String> crisisKeywords = [
    'suicide', 'kill myself', 'end it all', 'hopeless', 'worthless',
    'harm myself', 'self-harm', 'cutting', 'overdose', 'giving up'
  ];
  
  static Future<bool> detectCrisis(String message) async {
    // Local keyword detection
    final localDetection = crisisKeywords.any(
      (keyword) => message.toLowerCase().contains(keyword)
    );
    
    if (localDetection) {
      // Use Vertex AI for context-aware analysis
      final aiAnalysis = await VertexAIService.analyzeCrisisRisk(message);
      return aiAnalysis.riskLevel > 0.7;
    }
    
    return false;
  }
  
  static void handleCrisisDetection(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('We\'re Here for You'),
        content: const Text(
          'It seems like you might be going through a difficult time. Please know that you\'re not alone, and help is available.'
        ),
        actions: [
          TextButton(
            onPressed: () => launchEmergencyContacts(),
            child: const Text('Emergency Help'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('I\'m Safe'),
          ),
        ],
      ),
    );
  }
}
```

### 3. Firebase Configuration

#### Firestore Security Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Anonymous users can only access their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      // Mood data with additional privacy controls
      match /moods/{moodId} {
        allow read, write: if request.auth != null && 
          request.auth.uid == userId &&
          validateMoodData(request.resource.data);
      }
      
      // Chat history (encrypted)
      match /chats/{chatId} {
        allow read, write: if request.auth != null && 
          request.auth.uid == userId &&
          validateChatData(request.resource.data);
      }
    }
    
    // Public professional directory (read-only)
    match /professionals/{professionalId} {
      allow read: if request.auth != null;
      allow write: if false; // Only admin access through Cloud Functions
    }
    
    // Resources (read-only)
    match /resources/{resourceId} {
      allow read: if request.auth != null;
    }
  }
  
  function validateMoodData(data) {
    return data.keys().hasAll(['mood', 'timestamp', 'encrypted']) &&
           data.mood is string &&
           data.timestamp is timestamp &&
           data.encrypted is bool;
  }
  
  function validateChatData(data) {
    return data.keys().hasAll(['message', 'timestamp', 'encrypted']) &&
           data.encrypted == true;
  }
}
```

#### Cloud Functions Implementation
```javascript
const functions = require('firebase-functions');
const admin = require('firebase-admin');
const { VertexAI } = require('@google-cloud/vertexai');

admin.initializeApp();

// AI Response Generation
exports.generateAIResponse = functions.https.onCall(async (data, context) => {
  // Verify authentication
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }
  
  const { message, conversationHistory } = data;
  
  // Input validation and sanitization
  if (!message || typeof message !== 'string') {
    throw new functions.https.HttpsError('invalid-argument', 'Invalid message');
  }
  
  try {
    // Crisis detection
    const crisisDetected = await detectCrisis(message);
    
    if (crisisDetected) {
      // Log crisis event (anonymized)
      await logCrisisEvent(context.auth.uid);
      
      return {
        response: getCrisisResponse(),
        crisis: true,
        resources: getEmergencyResources()
      };
    }
    
    // Generate empathic response
    const vertexAI = new VertexAI({
      project: 'your-project-id',
      location: 'us-central1'
    });
    
    const response = await vertexAI.generateContent({
      model: 'gemini-pro',
      prompt: buildEmpathicPrompt(message, conversationHistory),
      parameters: {
        temperature: 0.7,
        maxOutputTokens: 200
      }
    });
    
    return {
      response: response.text,
      crisis: false
    };
    
  } catch (error) {
    console.error('AI Response Error:', error);
    throw new functions.https.HttpsError('internal', 'Failed to generate response');
  }
});

// Mood Analytics (Privacy-Preserving)
exports.processMoodData = functions.firestore
  .document('users/{userId}/moods/{moodId}')
  .onCreate(async (snap, context) => {
    const moodData = snap.data();
    const userId = context.params.userId;
    
    // Anonymize and aggregate data for insights
    const anonymizedData = {
      mood_category: categorizeMood(moodData.mood),
      timestamp: moodData.timestamp,
      user_segment: await getUserSegment(userId) // Based on usage patterns, not personal data
    };
    
    // Store in BigQuery for analytics
    await storeMoodAnalytics(anonymizedData);
    
    // Generate personalized insights
    const insights = await generateMoodInsights(userId);
    
    // Update user's insights (encrypted)
    await admin.firestore()
      .collection('users')
      .doc(userId)
      .update({
        latest_insights: encryptData(insights),
        last_updated: admin.firestore.FieldValue.serverTimestamp()
      });
  });

// Professional Matching
exports.matchProfessionals = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }
  
  const { preferences, location, language } = data;
  
  // AI-powered matching based on user needs
  const matches = await findMatchingProfessionals({
    specialization: preferences.specialization,
    location: location,
    language: language,
    availability: 'available'
  });
  
  // Rank matches using AI
  const rankedMatches = await rankProfessionals(matches, preferences);
  
  return { professionals: rankedMatches };
});

// Helper Functions
async function detectCrisis(message) {
  // Implement crisis detection logic
  const crisisKeywords = ['suicide', 'kill myself', 'hopeless', 'end it all'];
  return crisisKeywords.some(keyword => 
    message.toLowerCase().includes(keyword)
  );
}

function getCrisisResponse() {
  return "I'm really concerned about you right now. Please know that you're not alone and there are people who want to help. Would you like me to provide some immediate support resources?";
}

function getEmergencyResources() {
  return [
    {
      name: "National Suicide Prevention Helpline",
      number: "104",
      available: "24/7"
    },
    {
      name: "Sneha Suicide Prevention",
      number: "044-24640050",
      available: "24/7"
    }
  ];
}
```

## Deployment Guide

### 1. Environment Setup
```bash
# Install Flutter
flutter doctor

# Install Firebase CLI
npm install -g firebase-tools

# Install Google Cloud SDK
# Follow: https://cloud.google.com/sdk/docs/install

# Login to Firebase and Google Cloud
firebase login
gcloud auth login
```

### 2. Firebase Project Setup
```bash
# Create Firebase project
firebase projects:create mindful-mental-wellness

# Enable required services
firebase use mindful-mental-wellness
firebase init firestore
firebase init functions
firebase init hosting
```

### 3. Google Cloud Configuration
```bash
# Set project
gcloud config set project mindful-mental-wellness

# Enable APIs
gcloud services enable aiplatform.googleapis.com
gcloud services enable dialogflow.googleapis.com
gcloud services enable bigquery.googleapis.com
gcloud services enable cloudfunctions.googleapis.com

# Create service accounts
gcloud iam service-accounts create mindful-app-service
gcloud iam service-accounts create mindful-ai-service
```

### 4. Security Configuration
```yaml
# security.yaml
api_security:
  rate_limiting:
    requests_per_minute: 60
    burst_capacity: 10
  
  authentication:
    require_firebase_auth: true
    anonymous_allowed: true
  
  data_protection:
    encryption_at_rest: true
    encryption_in_transit: true
    pii_detection: enabled
  
  monitoring:
    audit_logging: enabled
    anomaly_detection: enabled
    security_alerts: enabled
```

## Performance & Monitoring

### 1. Analytics Implementation
```dart
class AnalyticsService {
  static Future<void> trackEvent(String eventName, Map<String, dynamic> parameters) async {
    // Remove any PII before tracking
    final sanitizedParams = sanitizeParameters(parameters);
    
    await FirebaseAnalytics.instance.logEvent(
      name: eventName,
      parameters: sanitizedParams,
    );
  }
  
  static Map<String, dynamic> sanitizeParameters(Map<String, dynamic> params) {
    // Remove any potential PII
    final sanitized = Map<String, dynamic>.from(params);
    sanitized.removeWhere((key, value) => 
      key.contains('name') || 
      key.contains('email') || 
      key.contains('phone')
    );
    return sanitized;
  }
}
```

### 2. Performance Monitoring
```dart
class PerformanceService {
  static Future<void> trackAIResponseTime(Future<String> aiCall) async {
    final trace = FirebasePerformance.instance.newTrace('ai_response_time');
    await trace.start();
    
    try {
      await aiCall;
      trace.putAttribute('success', 'true');
    } catch (e) {
      trace.putAttribute('success', 'false');
      trace.putAttribute('error', e.toString());
    } finally {
      await trace.stop();
    }
  }
}
```

## Compliance & Ethics

### 1. Data Governance
- **GDPR Compliance**: Right to erasure, data portability
- **Indian IT Act Compliance**: Local data storage options
- **Mental Health Ethics**: Professional oversight, crisis protocols

### 2. AI Ethics Guidelines
- **Transparency**: Clear AI interaction indicators
- **Bias Prevention**: Regular model evaluation and adjustment
- **Human Oversight**: Mental health professional review
- **Cultural Sensitivity**: Indian context awareness

### 3. Crisis Response Protocol
1. **Immediate Detection**: Real-time keyword and context analysis
2. **Professional Alert**: Notify crisis intervention team
3. **Resource Provision**: Local emergency contacts and services
4. **Follow-up**: Check-in mechanisms for user safety

## Testing Strategy

### 1. Unit Testing
```dart
// test/services/ai_service_test.dart
void main() {
  group('AI Service Tests', () {
    testWidgets('Crisis detection works correctly', (tester) async {
      final crisisMessage = "I want to kill myself";
      final result = await CrisisDetectionService.detectCrisis(crisisMessage);
      expect(result, isTrue);
    });
    
    testWidgets('Normal conversation detection', (tester) async {
      final normalMessage = "I'm feeling a bit sad today";
      final result = await CrisisDetectionService.detectCrisis(normalMessage);
      expect(result, isFalse);
    });
  });
}
```

### 2. Integration Testing
```dart
// test/integration/chat_flow_test.dart
void main() {
  group('Chat Integration Tests', () {
    testWidgets('End-to-end chat flow', (tester) async {
      // Test complete chat flow including AI response
      await tester.pumpWidget(const MyApp());
      
      // Navigate to chat
      await tester.tap(find.text('Chat'));
      await tester.pumpAndSettle();
      
      // Send message
      await tester.enterText(find.byType(TextField), 'Hello, I need help');
      await tester.tap(find.byIcon(Icons.send));
      
      // Verify response appears
      await tester.pumpAndSettle(const Duration(seconds: 5));
      expect(find.textContaining('I\'m here to help'), findsOneWidget);
    });
  });
}
```

## Maintenance & Updates

### 1. Regular Updates
- **AI Model Updates**: Monthly evaluation and retraining
- **Security Patches**: Immediate deployment for critical issues
- **Content Updates**: Quarterly review of resources and professionals

### 2. Monitoring Dashboards
- **User Engagement**: Anonymous usage analytics
- **AI Performance**: Response quality and accuracy metrics
- **Crisis Events**: De-identified crisis detection statistics
- **System Health**: Uptime, latency, and error rates

This comprehensive documentation provides the foundation for implementing, deploying, and maintaining the Mindful mental wellness platform with robust security, privacy, and AI capabilities.