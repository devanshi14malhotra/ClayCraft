import 'package:flutter/material.dart';
import 'package:claycraft_google_gen_ai/services/local_storage.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _initChat();
  }

  void _initChat() {
    final user = LocalStorageService().currentUser;
    final greeting = user?.role.name == 'artisan'
        ? "Hello! I'm ClayCraft's pottery assistant. I can help you with pottery techniques, materials, customer questions, and business tips. How can I assist you today?"
        : "Welcome to ClayCraft! I'm your pottery guide. I can help you learn about pottery traditions, choose the right pieces, care for your pottery, and connect with artisans. What would you like to know?";

    _messages.add(ChatMessage(
      content: greeting,
      isBot: true,
      timestamp: DateTime.now(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.brown,
              child: Icon(Icons.smart_toy, color: Colors.white, size: 20),
            ),
            SizedBox(width: 12),
            Text('Pottery Assistant'),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      body: Column(
        children: [
          // Chat suggestions
          if (_messages.length == 1) _buildSuggestions(),
          
          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return const TypingIndicator();
                }
                return MessageBubble(message: _messages[index]);
              },
            ),
          ),
          
          // Message input
          Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              top: 16,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Ask about pottery...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestions() {
    final user = LocalStorageService().currentUser;
    final suggestions = user?.role.name == 'artisan'
        ? [
            'How to price my pottery?',
            'Best clay for beginners?',
            'Glazing techniques',
            'Customer service tips',
          ]
        : [
            'How to care for pottery?',
            'What pottery style suits me?',
            'Pottery traditions around the world',
            'How to choose quality pieces?',
          ];

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick questions:',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: suggestions.map((suggestion) => 
              InkWell(
                onTap: () => _sendSuggestion(suggestion),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    suggestion,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ),
            ).toList(),
          ),
        ],
      ),
    );
  }

  void _sendSuggestion(String suggestion) {
    _messageController.text = suggestion;
    _sendMessage();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        content: text,
        isBot: false,
        timestamp: DateTime.now(),
      ));
      _isTyping = true;
    });

    _messageController.clear();
    _scrollToBottom();

    // Simulate bot response
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _messages.add(ChatMessage(
            content: _getBotResponse(text),
            isBot: true,
            timestamp: DateTime.now(),
          ));
          _isTyping = false;
        });
        _scrollToBottom();
      }
    });
  }

  String _getBotResponse(String userMessage) {
    final message = userMessage.toLowerCase();
    
    // Pottery care responses
    if (message.contains('care') || message.contains('clean') || message.contains('maintain')) {
      return "Great question about pottery care! Here are some tips:\n\n"
          "🧼 Hand wash with warm, soapy water\n"
          "🚫 Avoid sudden temperature changes\n"
          "🔥 Check if it's microwave/dishwasher safe\n"
          "✨ Use soft cloths to prevent scratches\n\n"
          "For specific pieces, always check with the artisan about care instructions!";
    }
    
    // Pottery traditions
    if (message.contains('tradition') || message.contains('history') || message.contains('culture')) {
      return "Pottery has amazing traditions worldwide! 🏺\n\n"
          "🇲🇽 Mexican Talavera - colorful glazed ceramics\n"
          "🇯🇵 Japanese Raku - zen-inspired tea ceremony pottery\n"
          "🇬🇷 Greek pottery - ancient techniques still used today\n"
          "🇨🇳 Chinese porcelain - refined and delicate\n\n"
          "Each tradition reflects the culture's values and aesthetics. Would you like to learn more about a specific tradition?";
    }
    
    // Choosing pottery
    if (message.contains('choose') || message.contains('style') || message.contains('suits')) {
      return "Finding your pottery style is exciting! Consider these factors:\n\n"
          "🏠 Your home decor (modern, traditional, eclectic)\n"
          "🎨 Color preferences (earth tones, bold colors, neutral)\n"
          "🍽️ Functionality (decorative, daily use, special occasions)\n"
          "✋ Texture preferences (smooth, textured, glazed)\n\n"
          "I recommend browsing our marketplace and seeing what speaks to you. You can also check out artisan profiles to learn about different styles!";
    }
    
    // Pricing for artisans
    if (message.contains('price') || message.contains('cost') || message.contains('charge')) {
      return "Pricing pottery involves several factors:\n\n"
          "⏱️ Time invested (hours of work)\n"
          "🏺 Materials cost (clay, glazes, firing)\n"
          "🎓 Skill level and experience\n"
          "📏 Size and complexity\n"
          "🔥 Firing costs and kiln time\n\n"
          "A good formula: (Materials + Time × hourly rate + Overhead) × 2-3\n"
          "Don't undervalue your craft! Research similar pieces in your area for reference.";
    }
    
    // Clay types
    if (message.contains('clay') || message.contains('material') || message.contains('beginner')) {
      return "Great question about clay! Here are the main types:\n\n"
          "🟤 Earthenware - Low fire, porous, great for beginners\n"
          "⚫ Stoneware - Mid-high fire, durable, food safe\n"
          "⚪ Porcelain - High fire, refined, challenging but beautiful\n"
          "🔴 Terracotta - Unglazed earthenware, classic reddish color\n\n"
          "For beginners, I recommend starting with earthenware or stoneware. They're more forgiving and less expensive!";
    }
    
    // Glazing
    if (message.contains('glaze') || message.contains('finish') || message.contains('color')) {
      return "Glazing is where the magic happens! ✨\n\n"
          "Types of glazes:\n"
          "🌟 Matte - Soft, non-reflective finish\n"
          "💫 Glossy - Shiny, reflective surface\n"
          "🔍 Transparent - Shows clay body underneath\n"
          "🎨 Opaque - Solid color coverage\n\n"
          "Tips: Test glazes on sample pieces first, consider food safety for functional items, and remember that glazes can react differently based on clay body and firing temperature!";
    }
    
    // Customer service for artisans
    if (message.contains('customer') || message.contains('service') || message.contains('client')) {
      return "Excellent customer service builds your pottery business! 🤝\n\n"
          "📞 Respond promptly to inquiries\n"
          "📸 Share progress photos during creation\n"
          "📦 Package carefully with personal touches\n"
          "💌 Follow up after delivery\n"
          "🔄 Be open to custom requests\n\n"
          "Remember: Happy customers become repeat customers and refer others. Your passion for pottery should shine through in every interaction!";
    }
    
    // Default responses
    final defaultResponses = [
      "That's an interesting question about pottery! While I don't have specific information about that, I can help you with pottery care, traditions, choosing pieces, and connecting with artisans. What else would you like to know?",
      "I'd love to help you explore the world of pottery! You can ask me about pottery techniques, materials, care instructions, or finding the right artisan for your needs. What interests you most?",
      "Pottery is such a rich and diverse craft! I can share information about different pottery traditions, help you choose pieces that match your style, or guide you through caring for your pottery collection. What would you like to learn about?",
    ];
    
    return defaultResponses[DateTime.now().millisecond % defaultResponses.length];
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class ChatMessage {
  final String content;
  final bool isBot;
  final DateTime timestamp;

  ChatMessage({
    required this.content,
    required this.isBot,
    required this.timestamp,
  });
}

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  
  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: message.isBot 
            ? MainAxisAlignment.start 
            : MainAxisAlignment.end,
        children: [
          if (message.isBot) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(Icons.smart_toy, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
          ],
          
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: message.isBot
                    ? Theme.of(context).colorScheme.surfaceContainerHighest
                    : Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomLeft: message.isBot ? const Radius.circular(4) : null,
                  bottomRight: message.isBot ? null : const Radius.circular(4),
                ),
              ),
              child: Text(
                message.content,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: message.isBot
                      ? Theme.of(context).colorScheme.onSurface
                      : Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          
          if (!message.isBot) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: Text(
                LocalStorageService().currentUser?.name.substring(0, 1).toUpperCase() ?? 'U',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.smart_toy, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16).copyWith(
                bottomLeft: const Radius.circular(4),
              ),
            ),
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (index) {
                    return Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSurface.withValues(
                          alpha: (_animationController.value + index * 0.3) % 1.0,
                        ),
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}