import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkHelper {
  static Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  static Future<ConnectivityResult> getConnectionType() async {
    final connectivity = Connectivity();
    return await connectivity.checkConnectivity();
  }

  static Future<Map<String, dynamic>> getNetworkStatus() async {
    final hasInternet = await hasInternetConnection();
    final connectionType = await getConnectionType();
    
    return {
      'hasInternet': hasInternet,
      'connectionType': connectionType.toString(),
      'canReachGemini': await _canReachGeminiAPI(),
    };
  }

  static Future<bool> _canReachGeminiAPI() async {
    try {
      final result = await InternetAddress.lookup('generativelanguage.googleapis.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  static String getNetworkTroubleshootingMessage(Map<String, dynamic> status) {
    if (!status['hasInternet']) {
      return "❌ No internet connection detected. Please check your WiFi or mobile data.";
    }
    
    if (!status['canReachGemini']) {
      return "⚠️ Internet connected but can't reach Gemini AI. This might be due to:\n" +
             "• Firewall blocking the connection\n" +
             "• Regional restrictions\n" +
             "• Temporary server issues\n\n" +
             "Don't worry - I can still help with basic responses!";
    }
    
    return "✅ All systems connected! Gemini AI is available.";
  }
}