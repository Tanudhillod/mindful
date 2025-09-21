import 'package:flutter/material.dart';
import 'app.dart';
import 'services/gemini_service.dart';

void main() {
  // Initialize Gemini AI service
  GeminiService.initialize();
  
  runApp(const MyApp());
}
