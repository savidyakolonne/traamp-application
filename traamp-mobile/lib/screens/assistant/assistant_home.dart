import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../models/chat_message.dart';
import '../../services/gemini_service.dart';

class AssistantHome extends StatefulWidget {
  const AssistantHome({super.key});

  @override
  State<AssistantHome> createState() => _AssistantHomeState();
}

class _AssistantHomeState extends State<AssistantHome> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  late final GeminiService _geminiService;
  ChatSession? _chat;

  final List<ChatMessage> _messages = [];
  bool _loading = false;

  String _getGeminiKey() {
    const key = String.fromEnvironment('GEMINI_API_KEY');
    if (key.isEmpty) {
      throw Exception("Missing GEMINI_API_KEY.");
    }
    return key;
  }

  @override
  void initState() {
    super.initState();

    final apiKey = _getGeminiKey();
    if (apiKey.isEmpty) {
      throw Exception(
        "Missing GEMINI_API_KEY.\n"
        "Web: flutter run -d chrome --dart-define=GEMINI_API_KEY=YOUR_KEY\n"
        "Android/Desktop: put GEMINI_API_KEY in .env and load dotenv in main.dart",
      );
    }

    _geminiService = GeminiService(apiKey);
    _chat = _geminiService.startSriLankaTourismChat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _send(String text) async {
    final prompt = text.trim();
    if (prompt.isEmpty || _loading) return;

    setState(() {
      _messages.add(ChatMessage(role: ChatRole.user, text: prompt));
      _loading = true;
    });
    _controller.clear();
    _scrollToBottom();

    try {
      final chat = _chat;
      if (chat == null) throw Exception('Chat session not initialized');

      final response = await chat.sendMessage(Content.text(prompt));
      final reply = response.text?.trim();

      setState(() {
        _messages.add(
          ChatMessage(
            role: ChatRole.assistant,
            text: reply ?? "Hmm I couldn’t generate a reply. Try again.",
          ),
        );
        _loading = false;
      });
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _messages.add(
          ChatMessage(
            role: ChatRole.assistant,
            text: "Oops — something broke while talking to Gemini.\n$e",
          ),
        );
        _loading = false;
      });
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    final showLanding = _messages.isEmpty;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 247, 248, 246),
      body: SafeArea(
        child: Column(
          children: [
            // Top close button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6F5E9),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: const Icon(Icons.close, color: Color(0xFF4CAF50)),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: showLanding
                  ? _Landing(onTapSuggestion: _send)
                  : _ChatList(
                      messages: _messages,
                      controller: _scrollController,
                    ),
            ),

            // Input bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE6E8EF)),
                      ),
                      child: TextField(
                        controller: _controller,
                        textInputAction: TextInputAction.send,
                        onSubmitted: _send,
                        decoration: const InputDecoration(
                          hintText: "Ask me anything…",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 52,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _loading
                          ? null
                          : () => _send(_controller.text),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        backgroundColor: const Color(0xFF6CC04A),
                        elevation: 0,
                      ),
                      child: _loading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Landing extends StatelessWidget {
  const _Landing({required this.onTapSuggestion});

  final Future<void> Function(String) onTapSuggestion;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 78,
              height: 78,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 18,
                    color: Color(0x22000000),
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.smart_toy,
                size: 40,
                color: Color(0xFF2E3A59),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              "Hi 👋",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "How can I help you today?",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 22),
            _SuggestionTile(
              icon: Icons.map,
              text: "Find a guide in Kandy",
              onTap: () => onTapSuggestion(
                "Find me a friendly English-speaking guide in Kandy. Give options + what to do in 1 day.",
              ),
            ),
            const SizedBox(height: 12),
            _SuggestionTile(
              icon: Icons.beach_access,
              text: "Top beaches near Galle",
              onTap: () => onTapSuggestion(
                "Top beaches near Galle for swimming and sunset. Include travel times and best hours.",
              ),
            ),
            const SizedBox(height: 12),
            _SuggestionTile(
              icon: Icons.wb_sunny,
              text: "Weather in Nuwara Eliya",
              onTap: () => onTapSuggestion(
                "I’m visiting Nuwara Eliya. What’s the typical weather like now and what should I pack?",
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              "Traamp assistant is here to support you",
              style: TextStyle(
                color: Color(0xFF94A3B8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  const _SuggestionTile({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  final IconData icon;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE6E8EF)),
          ),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF6CC04A)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatList extends StatelessWidget {
  const _ChatList({required this.messages, required this.controller});

  final List<ChatMessage> messages;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      itemCount: messages.length,
      itemBuilder: (context, i) {
        final m = messages[i];
        final isUser = m.role == ChatRole.user;

        return Align(
          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            constraints: const BoxConstraints(maxWidth: 340),
            decoration: BoxDecoration(
              color: isUser ? const Color(0xFF6CC04A) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: isUser
                  ? null
                  : Border.all(color: const Color(0xFFE6E8EF)),
            ),
            child: Text(
              m.text,
              style: TextStyle(
                color: isUser ? Colors.white : const Color(0xFF0F172A),
                height: 1.35,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      },
    );
  }
}
