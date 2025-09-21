# Firebase Setup Instructions for Mindful App

## Prerequisites
- Flutter SDK installed
- Firebase CLI installed (`npm install -g firebase-tools`)
- Google account for Firebase

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project"
3. Enter project name: `mindful-mental-wellness`
4. Enable Google Analytics (optional)
5. Create project

## Step 2: Enable Required Services

In your Firebase project console:

### Firestore Database
1. Go to "Firestore Database"
2. Click "Create database"
3. Choose "Start in test mode" (we'll update security rules later)
4. Select your preferred location (preferably close to your users)

### Authentication
1. Go to "Authentication"
2. Click "Get started"
3. In "Sign-in method" tab, enable:
   - Anonymous authentication
   - Email/Password (optional for admin features)

### Firebase Storage (Optional)
1. Go to "Storage"
2. Click "Get started"
3. Set up storage bucket

## Step 3: Configure Flutter App

### Add Firebase to Android

1. In Firebase Console, click "Add app" → Android
2. Enter package name: `com.mindful.app` (or your chosen package name)
3. Download `google-services.json`
4. Place it in `android/app/` directory

### Add Firebase to iOS

1. In Firebase Console, click "Add app" → iOS
2. Enter bundle ID: `com.mindful.app` (same as Android)
3. Download `GoogleService-Info.plist`
4. Add it to `ios/Runner/` directory through Xcode

## Step 4: Update Build Configuration

### Android Configuration

Update `android/build.gradle`:
```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.3.15'
    }
}
```

Update `android/app/build.gradle`:
```gradle
apply plugin: 'com.google.gms.google-services'

android {
    compileSdkVersion 34
    minSdkVersion 21
    targetSdkVersion 34
}
```

### iOS Configuration

Update `ios/Runner/Info.plist` to include Firebase configuration.

## Step 5: Firestore Security Rules

Replace the default rules with these secure rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Community messages - anonymous users can read/write their own
    match /community_messages/{messageId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null && 
        request.auth.uid == resource.data.userId &&
        validateMessageData(request.resource.data);
      allow update: if request.auth != null && 
        request.auth.uid == resource.data.userId;
      allow delete: if request.auth != null && 
        request.auth.uid == resource.data.userId;
    }
    
    // Community users
    match /community_users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        request.auth.uid == userId &&
        validateUserData(request.resource.data);
    }
    
    // Message reactions
    match /message_reactions/{reactionId} {
      allow read: if request.auth != null;
      allow create, delete: if request.auth != null && 
        request.auth.uid == resource.data.userId;
    }
    
    // Message reports (admin only for reads)
    match /message_reports/{reportId} {
      allow create: if request.auth != null && 
        request.auth.uid == resource.data.reportedBy;
      allow read, update: if false; // Admin only through Cloud Functions
    }
    
    // Personal data - users can only access their own
    match /users/{userId} {
      allow read, write: if request.auth != null && 
        request.auth.uid == userId;
      
      match /moods/{moodId} {
        allow read, write: if request.auth != null && 
          request.auth.uid == userId;
      }
      
      match /chat_history/{chatId} {
        allow read, write: if request.auth != null && 
          request.auth.uid == userId;
      }
    }
  }
  
  // Validation functions
  function validateMessageData(data) {
    return data.keys().hasAll(['content', 'timestamp', 'userId', 'userNickname']) &&
           data.content is string &&
           data.content.size() <= 500 &&
           data.timestamp is timestamp;
  }
  
  function validateUserData(data) {
    return data.keys().hasAll(['nickname', 'avatar', 'joinedAt']) &&
           data.nickname is string &&
           data.nickname.size() <= 50;
  }
}
```

## Step 6: Initialize Firebase in App

Update `lib/main.dart`:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
```

## Step 7: Generate Firebase Configuration

Run this command in your project root:
```bash
flutterfire configure --project=mindful-mental-wellness
```

This will generate `lib/firebase_options.dart` with your configuration.

## Step 8: Gemini AI Setup

1. Go to [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Create an API key for Gemini Pro
3. Update `lib/services/gemini_service.dart`:
   ```dart
   static const String _apiKey = 'YOUR_ACTUAL_API_KEY_HERE';
   ```
4. **Important**: Never commit API keys to version control. Use environment variables or secure storage in production.

## Step 9: Test Firebase Connection

Run the app and check:
1. Anonymous authentication works
2. Firestore operations function properly
3. Community chat displays correctly
4. No security rule violations in Firebase Console

## Step 10: Optional - Cloud Functions (for moderation)

1. Initialize Cloud Functions:
   ```bash
   firebase init functions
   ```

2. Implement message moderation functions in `functions/index.js`:
   ```javascript
   const functions = require('firebase-functions');
   const admin = require('firebase-admin');
   
   admin.initializeApp();
   
   exports.moderateMessage = functions.firestore
     .document('community_messages/{messageId}')
     .onCreate(async (snap, context) => {
       const message = snap.data();
       
       // Implement content moderation logic
       // You can integrate with Google Cloud Natural Language API
       // or other moderation services
       
       return null;
     });
   ```

3. Deploy functions:
   ```bash
   firebase deploy --only functions
   ```

## Important Security Notes

1. **API Keys**: Store Gemini API key securely (environment variables, not in code)
2. **User Privacy**: All user data is anonymous by design
3. **Content Moderation**: Implement automated and manual moderation for community safety
4. **Rate Limiting**: Consider implementing rate limits for message posting
5. **Emergency Protocols**: Ensure crisis detection and response systems are properly tested

## Testing Checklist

- [ ] Anonymous authentication works
- [ ] Community chat sends/receives messages
- [ ] Reply functionality works
- [ ] Message reactions function properly
- [ ] Report system works
- [ ] AI chat integration functional
- [ ] Crisis detection triggers properly
- [ ] Offline handling graceful
- [ ] Security rules prevent unauthorized access

## Production Considerations

1. **Backup Strategy**: Set up automated Firestore backups
2. **Monitoring**: Enable Firebase Performance and Crashlytics
3. **Scaling**: Monitor usage and upgrade Firebase plan as needed
4. **Compliance**: Ensure GDPR/data protection compliance
5. **Content Policy**: Establish clear community guidelines and enforcement