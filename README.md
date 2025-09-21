# mindful

# Mindful - AI-Powered Mental Wellness Platform with Community Support

## 🌟 Overview

Mindful is a comprehensive, privacy-focused mental wellness platform designed specifically for Indian youth. The app leverages Google's Gemini AI and Firebase Firestore to provide empathetic mental health support through both AI chatbots and peer community interactions.

## ✨ New Features Added

### 🤖 Enhanced AI Chat with Gemini
- **Mitra AI Companion**: Culturally-sensitive AI powered by Google's Gemini Pro
- **Crisis Detection**: Real-time analysis of user messages for emergency situations
- **Contextual Conversations**: AI remembers conversation history for better responses
- **Indian Context Awareness**: Understanding of family dynamics, academic pressure, and cultural nuances
- **Professional Referrals**: Smart recommendations for when to seek professional help

### 👥 Community Support Features
- **Anonymous Public Chat**: Safe space for peer support and shared experiences
- **Reply Threading**: Visual reply system to maintain conversation context in group chats
- **Reaction System**: Express support through helpful, heart, thanks, and strong reactions
- **Real-time Messaging**: Instant message delivery with online status indicators
- **Content Moderation**: Automated filtering and reporting system for safety

### 🔒 Privacy & Safety
- **Anonymous by Design**: No personal information required or stored
- **Firestore Database**: Secure, scalable backend with granular security rules
- **Content Filtering**: Automated moderation to prevent harmful content
- **Crisis Intervention**: Emergency resources and immediate support protocols
- **User Reporting**: Community-driven safety through reporting mechanisms

## 🛠 Technical Implementation

### Architecture
```
├── Frontend (Flutter)
│   ├── Community Chat UI
│   ├── AI Chat Interface
│   ├── Reply Threading System
│   └── Moderation Controls
├── Backend (Firebase)
│   ├── Firestore Database
│   ├── Anonymous Authentication
│   ├── Security Rules
│   └── Real-time Messaging
└── AI Services
    ├── Gemini Pro Integration
    ├── Crisis Detection
    ├── Context-Aware Responses
    └── Cultural Sensitivity
```

### Database Structure
```
Firestore Collections:
├── community_messages/
│   ├── message content & metadata
│   ├── reply relationships
│   └── moderation flags
├── community_users/
│   ├── anonymous profiles
│   ├── online status
│   └── activity metrics
├── message_reactions/
│   └── user reactions to messages
└── moderation_logs/
    └── automated & manual moderation
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0.0+)
- Firebase CLI
- Google AI Studio account (for Gemini API)
- Android Studio/VS Code

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd mindful
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up Firebase** (See FIREBASE_SETUP.md for detailed instructions)
   ```bash
   flutterfire configure --project=your-project-id
   ```

4. **Configure Gemini AI**
   - Get API key from [Google AI Studio](https://makersuite.google.com/app/apikey)
   - Update `lib/services/gemini_service.dart`:
     ```dart
     static const String _apiKey = 'YOUR_GEMINI_API_KEY';
     ```

5. **Run the app**
   ```bash
   flutter run
   ```

## 📱 Features Walkthrough

### Community Chat
1. **Join the Community**: Anonymous authentication creates secure identity
2. **Start Conversations**: Share experiences and seek support
3. **Reply to Messages**: Use @ mentions and visual threading
4. **Express Support**: React with helpful, heart, thanks, or strong emojis
5. **Stay Safe**: Report inappropriate content and follow community guidelines

### AI Chat (Enhanced)
1. **Meet Mitra**: Your AI companion understands Indian cultural context
2. **Natural Conversations**: Chat naturally; AI remembers your conversation
3. **Crisis Support**: Immediate detection and emergency resource provision
4. **Professional Guidance**: Smart suggestions for when to seek professional help
5. **Coping Strategies**: Personalized recommendations based on your needs

### Safety Features
- **Content Moderation**: Automatic filtering of harmful content
- **Rate Limiting**: Prevents spam and excessive posting
- **User Reporting**: Community-driven safety measures
- **Emergency Detection**: Real-time crisis keyword monitoring
- **Professional Resources**: Integrated directory of mental health professionals

## 🔧 Configuration

### Firebase Security Rules
```javascript
// Secure community access - users can only post as themselves
match /community_messages/{messageId} {
  allow read: if request.auth != null;
  allow create: if request.auth != null && 
    request.auth.uid == resource.data.userId;
}
```

### Gemini AI Configuration
```dart
// Culturally-sensitive prompts for Indian youth
final prompt = '''
You are Mitra, a compassionate AI companion for Indian youth.
- Understand family dynamics and academic pressure
- Be culturally sensitive to Indian traditions
- Provide practical coping strategies
- Know when to recommend professional help
''';
```

## 🛡️ Privacy & Security

### Data Protection
- **Anonymous Authentication**: No personal data collection
- **Local Storage**: Sensitive data stored on device only
- **Encrypted Communication**: All data encrypted in transit and at rest
- **Automatic Cleanup**: Message history automatically managed

### Content Safety
- **Automated Moderation**: Real-time filtering of harmful content
- **Human Oversight**: Flagged content reviewed by moderators
- **Community Guidelines**: Clear rules enforced consistently
- **Crisis Protocols**: Immediate intervention for emergency situations

## 📊 Monitoring & Analytics

### Safety Metrics
- Crisis detection accuracy
- Response time to reports
- Community engagement levels
- User safety feedback

### Performance Tracking
- Message delivery latency
- AI response quality
- User retention rates
- Feature usage patterns

## 🌍 Cultural Considerations

### Indian Context Awareness
- **Academic Pressure**: Understanding of competitive education system
- **Family Dynamics**: Respect for hierarchical family structures
- **Cultural Events**: Awareness of festivals and traditions
- **Language Support**: Multi-language interface planned
- **Regional Differences**: Sensitivity to diverse cultural backgrounds

## 🔮 Future Enhancements

### Planned Features
- **Voice Messages**: Audio support for community chat
- **Group Therapy Sessions**: Moderated group discussions
- **Mood Tracking Integration**: Connect community activity with personal mood data
- **Professional Integration**: Direct booking with verified therapists
- **Advanced AI**: More sophisticated conversation and emotional intelligence

### Technical Roadmap
- **Cloud Functions**: Server-side moderation and analytics
- **Push Notifications**: Real-time engagement alerts
- **Offline Support**: Message queuing for poor connectivity
- **Advanced Search**: Find relevant community discussions
- **Data Insights**: Anonymous analytics for mental health trends

## 🤝 Contributing

### Development Guidelines
1. Follow Flutter best practices
2. Maintain privacy-first design
3. Test all moderation features thoroughly
4. Ensure cultural sensitivity in all content
5. Document all API integrations

### Safety First
- All PRs must include safety impact assessment
- Community features require moderation system updates
- AI responses must be tested for harmful outputs
- Emergency protocols must remain functional

## 📞 Emergency Resources

### India-Specific Helplines
- **National Suicide Prevention**: 104
- **Sneha Foundation**: 044-24640050
- **Vandrevala Foundation**: 1860-2662-345
- **TISS iCall**: 022-25521111
- **Fortis Stress Helpline**: 8376804102

## 📄 License

This project is developed for mental health support and educational purposes. Please ensure compliance with local healthcare regulations and data protection laws.

## 🙏 Acknowledgments

- Google AI for Gemini Pro API
- Firebase for backend infrastructure
- Flutter community for UI frameworks
- Mental health professionals for guidance
- Indian youth for feedback and testing

---

**Remember**: This app supplements but does not replace professional mental health care. Always encourage users to seek professional help when needed.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
