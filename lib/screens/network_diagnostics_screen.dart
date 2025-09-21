import 'package:flutter/material.dart';
import '../utils/network_helper.dart';
import '../services/gemini_service.dart';
import '../theme.dart';

class NetworkDiagnosticsScreen extends StatefulWidget {
  const NetworkDiagnosticsScreen({super.key});

  @override
  State<NetworkDiagnosticsScreen> createState() => _NetworkDiagnosticsScreenState();
}

class _NetworkDiagnosticsScreenState extends State<NetworkDiagnosticsScreen> {
  Map<String, dynamic>? networkStatus;
  bool isLoading = true;
  String? geminiTestResult;

  @override
  void initState() {
    super.initState();
    _runDiagnostics();
  }

  Future<void> _runDiagnostics() async {
    setState(() {
      isLoading = true;
    });

    try {
      final status = await NetworkHelper.getNetworkStatus();
      String testResult = "Connection test failed";
      
      try {
        final response = await GeminiService.generateEmpathicResponse("Hello, test connection");
        if (response.contains("having trouble connecting")) {
          testResult = "❌ Gemini API unreachable - Using fallback responses";
        } else {
          testResult = "✅ Gemini AI responding successfully";
        }
      } catch (e) {
        testResult = "❌ Gemini test failed: ${e.toString().substring(0, 100)}...";
      }

      setState(() {
        networkStatus = status;
        geminiTestResult = testResult;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        geminiTestResult = "Error running diagnostics: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightMint,
      appBar: AppBar(
        title: const Text('Network Diagnostics'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _runDiagnostics,
          ),
        ],
      ),
      body: isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusCard(),
                const SizedBox(height: 16),
                _buildGeminiTestCard(),
                const SizedBox(height: 16),
                _buildTroubleshootingCard(),
                const SizedBox(height: 16),
                _buildHelpCard(),
              ],
            ),
          ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.network_check, color: AppColors.primaryGreen),
                const SizedBox(width: 8),
                Text(
                  'Network Status',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (networkStatus != null) ...[
              _buildStatusRow('Internet Connection', 
                networkStatus!['hasInternet'] ? '✅ Connected' : '❌ No Connection'),
              _buildStatusRow('Connection Type', networkStatus!['connectionType']),
              _buildStatusRow('Gemini API Reachable', 
                networkStatus!['canReachGemini'] ? '✅ Reachable' : '❌ Unreachable'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGeminiTestCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.psychology, color: AppColors.primaryGreen),
                const SizedBox(width: 8),
                Text(
                  'Gemini AI Test',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              geminiTestResult ?? 'Testing...',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTroubleshootingCard() {
    if (networkStatus == null) return const SizedBox();

    final troubleshootingMessage = NetworkHelper.getNetworkTroubleshootingMessage(networkStatus!);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.build, color: AppColors.primaryGreen),
                const SizedBox(width: 8),
                Text(
                  'Troubleshooting',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              troubleshootingMessage,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.help_outline, color: AppColors.primaryGreen),
                const SizedBox(width: 8),
                Text(
                  'Need Help?',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Even without AI, Mindful can still help you with:\n\n'
              '• Mood tracking and visualization\n'
              '• Crisis support resources\n'
              '• Coping strategies and techniques\n'
              '• Emergency contacts and helplines\n'
              '• Breathing exercises and mindfulness\n\n'
              'The AI chat will automatically reconnect when your network improves.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value),
        ],
      ),
    );
  }
}