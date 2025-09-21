import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../theme.dart';
import '../models/community_models.dart';
import '../services/community_service.dart';

class CommunityMessageBubble extends StatefulWidget {
  final CommunityMessage message;
  final VoidCallback onReply;
  final Function(String) onReact;

  const CommunityMessageBubble({
    super.key,
    required this.message,
    required this.onReply,
    required this.onReact,
  });

  @override
  State<CommunityMessageBubble> createState() => _CommunityMessageBubbleState();
}

class _CommunityMessageBubbleState extends State<CommunityMessageBubble> with TickerProviderStateMixin {
  bool _showActions = false;
  CommunityMessage? _replyToMessage;
  late AnimationController _reactionController;
  late Animation<double> _reactionAnimation;

  @override
  void initState() {
    super.initState();
    _loadReplyToMessage();
    
    _reactionController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _reactionAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _reactionController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _reactionController.dispose();
    super.dispose();
  }

  Future<void> _loadReplyToMessage() async {
    if (widget.message.replyToId != null) {
      final replyMessage = await CommunityService.getMessageById(widget.message.replyToId!);
      if (mounted) {
        setState(() => _replyToMessage = replyMessage);
      }
    }
  }

  void _showReactionOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'React to this message',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildReactionOption('helpful', '👍', 'Helpful', AppColors.primaryGreen),
                _buildReactionOption('heart', '❤️', 'Support', AppColors.accentPeach),
                _buildReactionOption('thanks', '🙏', 'Thanks', AppColors.primaryBlue),
                _buildReactionOption('strong', '💪', 'Strong', AppColors.warningAmber),
              ],
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReactionOption(String type, String emoji, String label, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        widget.onReact(type);
        _reactionController.forward().then((_) {
          _reactionController.reverse();
        });
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 24),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showMessageOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.reply, color: AppColors.primaryBlue),
              title: const Text('Reply'),
              onTap: () {
                Navigator.pop(context);
                widget.onReply();
              },
            ),
            ListTile(
              leading: Icon(Icons.thumb_up, color: AppColors.primaryGreen),
              title: const Text('React'),
              onTap: () {
                Navigator.pop(context);
                _showReactionOptions();
              },
            ),
            if (_isOwnMessage())
              ListTile(
                leading: Icon(Icons.delete, color: AppColors.errorSoft),
                title: const Text('Delete'),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete();
                },
              ),
            if (!_isOwnMessage())
              ListTile(
                leading: Icon(Icons.report, color: AppColors.warningAmber),
                title: const Text('Report'),
                onTap: () {
                  Navigator.pop(context);
                  _showReportDialog();
                },
              ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }

  bool _isOwnMessage() {
    final currentUser = FirebaseAuth.instance.currentUser;
    return currentUser?.uid == widget.message.userId;
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Message'),
        content: const Text('Are you sure you want to delete this message? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await CommunityService.deleteMessage(widget.message.id);
              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Message deleted')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorSoft,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showReportDialog() {
    final reasons = [
      'Inappropriate content',
      'Spam or repetitive',
      'Harmful or dangerous',
      'Harassment or bullying',
      'False information',
      'Other',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Message'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Why are you reporting this message?'),
            const SizedBox(height: 16),
            ...reasons.map((reason) => ListTile(
              title: Text(reason),
              onTap: () async {
                Navigator.pop(context);
                final success = await CommunityService.reportMessage(widget.message.id, reason);
                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Message reported. Thank you for keeping our community safe.')),
                  );
                }
              },
            )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isOwnMessage = _isOwnMessage();
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reply context (if replying to another message)
          if (_replyToMessage != null)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border(
                  left: BorderSide(
                    color: AppColors.primaryBlue,
                    width: 3,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        _replyToMessage!.userAvatar,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _replyToMessage!.userNickname,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _replyToMessage!.content,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textMedium,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          
          // Main message
          GestureDetector(
            onLongPress: _showMessageOptions,
            onTap: () {
              setState(() => _showActions = !_showActions);
            },
            child: AnimatedBuilder(
              animation: _reactionAnimation,
              builder: (context, child) => Transform.scale(
                scale: 1.0 + (_reactionAnimation.value * 0.05),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isOwnMessage 
                        ? AppColors.primaryGreen.withOpacity(0.1)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isOwnMessage 
                          ? AppColors.primaryGreen.withOpacity(0.3)
                          : Colors.grey.withOpacity(0.2),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User info
                      Row(
                        children: [
                          Text(
                            widget.message.userAvatar,
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.message.userNickname,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: isOwnMessage ? AppColors.primaryGreen : AppColors.primaryBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (isOwnMessage) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primaryGreen,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'You',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                          const Spacer(),
                          Text(
                            timeago.format(widget.message.timestamp),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textLight,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      
                      // Message content
                      Text(
                        widget.message.content,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textDark,
                        ),
                      ),
                      
                      // Reactions
                      if (widget.message.reactions.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primaryGreen.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('👍', style: TextStyle(fontSize: 12)),
                                  const SizedBox(width: 4),
                                  Text(
                                    widget.message.reactions.length.toString(),
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.primaryGreen,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Action buttons
          if (_showActions)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  _buildActionButton(
                    icon: Icons.reply,
                    label: 'Reply',
                    color: AppColors.primaryBlue,
                    onTap: widget.onReply,
                  ),
                  const SizedBox(width: 12),
                  _buildActionButton(
                    icon: Icons.thumb_up,
                    label: 'React',
                    color: AppColors.primaryGreen,
                    onTap: _showReactionOptions,
                  ),
                  const SizedBox(width: 12),
                  _buildActionButton(
                    icon: Icons.more_horiz,
                    label: 'More',
                    color: AppColors.textMedium,
                    onTap: _showMessageOptions,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}