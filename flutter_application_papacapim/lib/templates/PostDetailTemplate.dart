import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/PostCard.dart';
import 'package:flutter_application_1/models/Post.dart';
import 'package:flutter_application_1/models/UserSession.dart';
import 'package:flutter_application_1/repositories/PostRepository.dart';
import 'package:flutter_application_1/services/PostService.dart';

class PostDetailTemplate extends StatefulWidget {
  final Post post;
  final UserSession session;
  final bool autoFocusReply;

  const PostDetailTemplate({
    super.key,
    required this.post,
    required this.session,
    this.autoFocusReply = false,
  });

  @override
  State<PostDetailTemplate> createState() => _PostDetailTemplateState();
}

class _PostDetailTemplateState extends State<PostDetailTemplate> {
  final _postRepository = PostRepository(PostService());
  final _replyController = TextEditingController();
  final _focusNode = FocusNode();

  List<Post> _replies = [];
  bool _isLoadingReplies = true;
  bool _isSendingReply = false;

  @override
  void initState() {
    super.initState();
    _carregarRespostas();
    if (widget.autoFocusReply) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _replyController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _carregarRespostas() async {
    setState(() => _isLoadingReplies = true);
    try {
      final replies = await _postRepository.getReplies(widget.session.token, widget.post.id);
      setState(() => _replies = replies);
    } catch (e) {
      debugPrint('Erro ao carregar respostas: $e');
    } finally {
      setState(() => _isLoadingReplies = false);
    }
  }

  Future<void> _enviarResposta() async {
    final texto = _replyController.text.trim();
    if (texto.isEmpty) return;

    setState(() => _isSendingReply = true);
    try {
      final novaResposta = await _postRepository.replyPost(
        widget.session.token,
        widget.post.id,
        texto,
      );
      _replyController.clear();
      _focusNode.unfocus();
      setState(() => _replies.insert(0, novaResposta));
      print('Resposta enviada com sucesso!');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao responder: $e')),
      );
    } finally {
      setState(() => _isSendingReply = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
        elevation: 0.5,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                // Post original
                PostCard(
                  post: widget.post,
                  session: widget.session,
                  onDeleted: () => Navigator.pop(context),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Respostas',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                ),
                // Respostas
                if (_isLoadingReplies)
                  const Center(child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ))
                else if (_replies.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text('Nenhuma resposta ainda.', style: TextStyle(color: Colors.grey)),
                    ),
                  )
                else
                  ..._replies.map((r) => PostCard(
                    post: r,
                    session: widget.session,
                    onDeleted: _carregarRespostas,
                  )),
              ],
            ),
          ),
          // Campo de resposta
          const Divider(height: 1),
          Padding(
            padding: EdgeInsets.only(
              left: 12,
              right: 8,
              top: 8,
              bottom: MediaQuery.of(context).viewInsets.bottom + 8,
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 16,
                  backgroundImage: AssetImage('img/logo.png'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _replyController,
                    focusNode: _focusNode,
                    decoration: const InputDecoration(
                      hintText: 'Escreva uma resposta...',
                      border: InputBorder.none,
                    ),
                    maxLines: null,
                  ),
                ),
                _isSendingReply
                    ? const Padding(
                        padding: EdgeInsets.all(8),
                        child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                      )
                    : IconButton(
                        icon: const Icon(Icons.send, color: Colors.blue),
                        onPressed: _enviarResposta,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
