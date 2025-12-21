
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

// --- DATA MODEL ---
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;
  final bool hasAction;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
    this.hasAction = false,
  });
}

// --- UI CONSTANTS ---
const Color offWhite = Color(0xFFF5F5F7);
const Color lavender = Color(0xFFE6E6FA);
const Color blackBubble = Color(0xFF1A1A1A);
const Color darkGreyText = Color(0xFF333333);
const Color greyText = Color(0xFF8A8A8E);
const Color inputBg = Color(0xFFF0F0F0);

class MobileAIChatScreen extends StatefulWidget {
  const MobileAIChatScreen({super.key});

  @override
  State<MobileAIChatScreen> createState() => _MobileAIChatScreenState();
}

class _MobileAIChatScreenState extends State<MobileAIChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool isTyping = false;

  final List<ChatMessage> _messages = [
    ChatMessage(text: "Approx 1.2kWh. Shall I turn it off?", isUser: false, time: DateTime.now(), hasAction: true),
    ChatMessage(text: "How much power is it wasting?", isUser: true, time: DateTime.now().subtract(const Duration(minutes: 1))),
    ChatMessage(text: "Alert: Lab 01 AC is running in an empty room.", isUser: false, time: DateTime.now().subtract(const Duration(minutes: 2))),
  ];

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSendMessage(String text) {
    if (text.isEmpty) return;
    _textController.clear();
    
    setState(() {
      _messages.insert(0, ChatMessage(text: text, isUser: true, time: DateTime.now()));
      isTyping = true;
    });
    _scrollToBottom();

    // TODO: Send to Gemini API and get a real response
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _messages.insert(0, ChatMessage(text: "Okay, I've turned off the AC in Lab 01 and logged the action.", isUser: false, time: DateTime.now()));
        isTyping = false;
      });
      _scrollToBottom();
    });
  }

  void _handleActionClick(String actionId) {
    // TODO: Trigger IoT command based on actionId
    print("Action clicked: $actionId");
    setState(() {
      final actionMessageIndex = _messages.indexWhere((msg) => msg.hasAction);
      if (actionMessageIndex != -1) {
        _messages[actionMessageIndex] = ChatMessage(text: _messages[actionMessageIndex].text, isUser: false, time: _messages[actionMessageIndex].time, hasAction: false);
      }
      _messages.insert(0, ChatMessage(text: "Confirmed. The AC in Lab 01 is now off.", isUser: false, time: DateTime.now()));
      isTyping = false;
    });
     _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: offWhite,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final previousMessage = index < _messages.length - 1 ? _messages[index + 1] : null;
                final bool showTimestamp = index == _messages.length - 1 || message.time.day != previousMessage?.time.day;

                return Column(
                  children: [
                    if (showTimestamp)
                      _buildTimestamp(message.time),
                    _buildMessageItem(message),
                  ],
                );
              },
            ),
          ),
          if (isTyping) _buildTypingIndicator(),
          _buildInputArea(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: offWhite,
      elevation: 0,
      centerTitle: true,
      title: Column(
        children: [
          Text('AI Facility Manager', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: blackBubble)),
          const SizedBox(height: 2),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Powered by Gemini', style: GoogleFonts.inter(fontSize: 12, color: greyText)),
              const SizedBox(width: 5),
              Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
              const SizedBox(width: 2),
              Text('Online', style: GoogleFonts.inter(fontSize: 12, color: greyText)),
            ],
          ),
        ],
      ),
      actions: [IconButton(icon: const Icon(Icons.more_vert, color: blackBubble), onPressed: () {})],
    );
  }

  Widget _buildTimestamp(DateTime time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Text(
        'Today, ${DateFormat.jm().format(time)}',
        style: GoogleFonts.inter(color: greyText, fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildMessageItem(ChatMessage message) {
    final isUser = message.isUser;
    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(20),
      topRight: const Radius.circular(20),
      bottomLeft: isUser ? const Radius.circular(20) : Radius.zero,
      bottomRight: isUser ? Radius.zero : const Radius.circular(20),
    );

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            decoration: BoxDecoration(
              color: isUser ? blackBubble : Colors.white,
              borderRadius: borderRadius,
            ),
            child: Text(
              message.text,
              style: GoogleFonts.inter(color: isUser ? Colors.white : darkGreyText, fontWeight: FontWeight.w500),
            ),
          ),
          if (message.hasAction)
            _buildActionChips(),
        ],
      ),
    );
  }
  
  Widget _buildActionChips() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 0, right: 10, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: () => _handleActionClick("turn_off_ac"),
            style: ElevatedButton.styleFrom(
              backgroundColor: lavender,
              shape: const StadiumBorder(),
              elevation: 1,
              shadowColor: Colors.black26,
            ),
            child: Text("Yes, Turn Off", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: blackBubble)),
          ),
          const SizedBox(width: 10),
          TextButton(
            onPressed: () {
              setState(() {
                final index = _messages.indexWhere((m) => m.hasAction);
                if(index != -1) {
                  _messages[index] = ChatMessage(text: _messages[index].text, isUser: false, time: _messages[index].time, hasAction: false);
                }
              });
            },
            child: Text("Dismiss", style: GoogleFonts.inter(color: greyText)),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        children: [
          const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 3)),
          const SizedBox(width: 10),
          Text("AI is thinking...", style: GoogleFonts.inter(color: greyText)),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.75),
            border: const Border(top: BorderSide(color: Colors.black12, width: 0.5)),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: "Ask about lab status...",
                        fillColor: inputBg,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      ),
                      onSubmitted: _handleSendMessage,
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => _handleSendMessage(_textController.text),
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(14),
                      backgroundColor: blackBubble,
                      foregroundColor: Colors.white,
                    ),
                    child: const Icon(Icons.arrow_upward),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
