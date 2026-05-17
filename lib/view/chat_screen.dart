import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../viewmodel/chat_viewmodel.dart';
import '../services/gemini_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  @override
  void dispose() {
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _send() async {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;
    _msgCtrl.clear();
    await context.read<ChatViewModel>().sendMessage(text);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ChatViewModel>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Ustadz AI'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Hapus percakapan',
            onPressed: () => context.read<ChatViewModel>().clearChat(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: vm.messages.isEmpty
                ? _buildWelcome()
                : ListView.builder(
                    controller: _scrollCtrl,
                    padding: const EdgeInsets.all(AppTheme.spacingMd),
                    itemCount: vm.messages.length + (vm.isThinking ? 1 : 0),
                    itemBuilder: (_, i) {
                      if (i == vm.messages.length) return _ThinkingBubble();
                      final msg = vm.messages[i];
                      return _MessageBubble(message: msg);
                    },
                  ),
          ),

          // Input bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerLowest,
              border: const Border(
                  top: BorderSide(color: AppTheme.outlineVariant, width: 0.5)),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _msgCtrl,
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      decoration: const InputDecoration(
                        hintText: 'Tanyakan seputar Islam...',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: Material(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                        onTap: vm.isThinking ? null : _send,
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(Icons.send, color: Colors.white, size: 20),
                        ),
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

  Widget _buildWelcome() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.pageMargin),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primary, AppTheme.primaryContainer],
              ),
              borderRadius: BorderRadius.circular(AppTheme.radiusXl),
            ),
            child: const Center(
              child: Text('☪', style: TextStyle(fontSize: 40, color: Colors.white)),
            ),
          ),
          const SizedBox(height: 24),
          Text('Ustadz AI', style: AppTheme.headlineMd),
          const SizedBox(height: 8),
          Text(
            'Asisten Islam yang siap menjawab pertanyaan\nseputar Al-Quran, Hadits, Fiqih, dan Sejarah Islam',
            style: AppTheme.bodyMd.copyWith(color: AppTheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              'Apa hukum shalat Jumat?',
              'Doa sebelum tidur',
              'Kisah Nabi Ibrahim AS',
              'Keutamaan Surah Al-Mulk',
            ].map((q) => ActionChip(
              label: Text(q, style: AppTheme.labelMd.copyWith(color: AppTheme.primary)),
              backgroundColor: AppTheme.primary.withOpacity(0.08),
              side: BorderSide(color: AppTheme.primary.withOpacity(0.2)),
              onPressed: () {
                _msgCtrl.text = q;
                _send();
              },
            )).toList(),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
        margin: EdgeInsets.only(
          bottom: 8,
          left: isUser ? 48 : 0,
          right: isUser ? 0 : 48,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isUser ? AppTheme.primary : AppTheme.surfaceContainerLowest,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Text(
          message.text,
          style: AppTheme.bodyMd.copyWith(
            color: isUser ? Colors.white : AppTheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _ThinkingBubble extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerLowest,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
          ),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) => _Dot(delay: i * 200)),
        ),
      ),
    );
  }
}

class _Dot extends StatefulWidget {
  final int delay;
  const _Dot({required this.delay});

  @override
  State<_Dot> createState() => _DotState();
}

class _DotState extends State<_Dot> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))
      ..repeat(reverse: true);
    _anim = Tween<double>(begin: 0, end: -6).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: Interval(widget.delay / 800, (widget.delay + 400) / 800,
            curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        width: 8, height: 8,
        transform: Matrix4.translationValues(0, _anim.value, 0),
        decoration: const BoxDecoration(
          color: AppTheme.primary, shape: BoxShape.circle,
        ),
      ),
    );
  }
}
