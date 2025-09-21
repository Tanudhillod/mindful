import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../theme.dart';
import '../models/community_models.dart';
import '../services/community_service.dart';
import '../widgets/community_message_bubble.dart';
import '../widgets/community_reply_widget.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _messageFocusNode = FocusNode();
  
  List<CommunityMessage> _messages = [];
  CommunityMessage? _replyingTo;
  bool _isLoading = true;
  bool _isLoadingMore = false;
  DocumentSnapshot? _lastDocument;
  int _onlineUsersCount = 0;
  
  late AnimationController _sendButtonController;
  late Animation<double> _sendButtonAnimation;

  @override
  void initState() {
    super.initState();
    _initializeUser();
    _loadMessages();
    _listenToOnlineUsers();
    _scrollController.addListener(_onScroll);
    
    _sendButtonController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _sendButtonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _sendButtonController, curve: Curves.elasticOut),
    );
    
    _messageController.addListener(() {
      if (_messageController.text.isNotEmpty && !_sendButtonController.isCompleted) {
        _sendButtonController.forward();
      } else if (_messageController.text.isEmpty && _sendButtonController.isCompleted) {
        _sendButtonController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _messageFocusNode.dispose();
    _sendButtonController.dispose();
    CommunityService.updateUserOnlineStatus(false);
    super.dispose();
  }

  Future<void> _initializeUser() async {
    await CommunityService.initializeCommunityUser();
  }

  Future<void> _loadMessages() async {
    try {
      setState(() => _isLoading = true);
      
      final snapshot = await FirebaseFirestore.instance
          .collection('community_messages')
          .where('isModerated', isEqualTo: false)
          .orderBy('timestamp', descending: true)
          .limit(20)
          .get();
      
      _lastDocument = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;
      
      setState(() {
        _messages = snapshot.docs
            .map((doc) => CommunityMessage.fromMap(doc.data()))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading messages: $e');
      setState(() {
        _messages = [];
        _isLoading = false;
      });
    }
  }

  void _listenToOnlineUsers() {
    try {
      CommunityService.getOnlineUsersCount().listen((count) {
        if (mounted) {
          setState(() => _onlineUsersCount = count);
        }
      });
    } catch (e) {
      print('Error initializing community user: $e');
      setState(() => _onlineUsersCount = 0);
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore && _lastDocument != null) {
      _loadMoreMessages();
    }
  }

  Future<void> _loadMoreMessages() async {
    if (_isLoadingMore || _lastDocument == null) return;
    
    setState(() => _isLoadingMore = true);
    
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('community_messages')
          .where('isModerated', isEqualTo: false)
          .orderBy('timestamp', descending: true)
          .startAfterDocument(_lastDocument!)
          .limit(20)
          .get();
      
      if (snapshot.docs.isNotEmpty) {
        _lastDocument = snapshot.docs.last;
        final newMessages = snapshot.docs
            .map((doc) => CommunityMessage.fromMap(doc.data()))
            .toList();
        
        setState(() {
          _messages.addAll(newMessages);
        });
      }
    } catch (e) {
      print('Error loading more messages: $e');
    } finally {
      setState(() => _isLoadingMore = false);
    }
  }

  Future<void> _sendMessage() async {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    _messageController.clear();
    _sendButtonController.reverse();
    
    final success = await CommunityService.sendMessage(
      content,
      replyToId: _replyingTo?.id,
    );

    if (success) {
      setState(() => _replyingTo = null);
      _loadMessages(); // Refresh messages
      
      // Scroll to top to show new message
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send message. Please try again.')),
      );
    }
  }

  void _replyToMessage(CommunityMessage message) {
    setState(() => _replyingTo = message);
    _messageFocusNode.requestFocus();
  }

  void _cancelReply() {
    setState(() => _replyingTo = null);
  }

  void _showCommunityGuidelines() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.people, color: AppColors.primaryGreen, size: 28),
                  const SizedBox(width: 12),
                  Text(
                    'Community Guidelines',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: CommunityService.getCommunityGuidelines()
                      .entries
                      .map((entry) => _buildGuidelineItem(entry.key, entry.value))
                      .toList(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Got it!'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuidelineItem(String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryGreen.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.primaryGreen,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textMedium,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Community Support'),
            Text(
              '$_onlineUsersCount online now',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.successSoft,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showCommunityGuidelines,
          ),
        ],
      ),
      body: Column(
        children: [
          // Header with community info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryGreen.withOpacity(0.1),
                  AppColors.primaryBlue.withOpacity(0.1),
                ],
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.people,
                    color: AppColors.primaryGreen,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Safe Space for Mental Wellness',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Share experiences, find support, grow together',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Messages list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _messages.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        controller: _scrollController,
                        reverse: true,
                        padding: const EdgeInsets.all(16),
                        itemCount: _messages.length + (_isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (_isLoadingMore && index == _messages.length) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          
                          final message = _messages[index];
                          return CommunityMessageBubble(
                            message: message,
                            onReply: () => _replyToMessage(message),
                            onReact: (reactionType) => CommunityService.reactToMessage(message.id, reactionType),
                          );
                        },
                      ),
          ),
          
          // Reply preview
          if (_replyingTo != null)
            CommunityReplyWidget(
              replyingTo: _replyingTo!,
              onCancel: _cancelReply,
            ),
          
          // Message input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Colors.grey.withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      focusNode: _messageFocusNode,
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: _replyingTo != null 
                            ? 'Reply to ${_replyingTo!.userNickname}...'
                            : 'Share your thoughts with the community...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.1),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedBuilder(
                    animation: _sendButtonAnimation,
                    builder: (context, child) => Transform.scale(
                      scale: 0.8 + (_sendButtonAnimation.value * 0.2),
                      child: FloatingActionButton(
                        onPressed: _messageController.text.trim().isNotEmpty ? _sendMessage : null,
                        backgroundColor: _messageController.text.trim().isNotEmpty 
                            ? AppColors.primaryGreen 
                            : Colors.grey,
                        foregroundColor: Colors.white,
                        mini: true,
                        child: const Icon(Icons.send),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                Icons.people_outline,
                size: 48,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Welcome to Our Community!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.textDark,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'This is a safe space where you can share your experiences, find support, and connect with others on their mental wellness journey.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textMedium,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _messageFocusNode.requestFocus();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text('Start the Conversation'),
            ),
          ],
        ),
      ),
    );
  }
}