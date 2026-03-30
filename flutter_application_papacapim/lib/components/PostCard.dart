import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/Post.dart';
import 'package:flutter_application_1/models/UserSession.dart';
import 'package:flutter_application_1/repositories/PostRepository.dart';
import 'package:flutter_application_1/services/PostService.dart';
import 'package:flutter_application_1/templates/PostDetailTemplate.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final UserSession session;
  final VoidCallback? onDeleted;

  const PostCard({
    super.key,
    required this.post,
    required this.session,
    this.onDeleted,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final _postRepository = PostRepository(PostService());

  bool _isLiked = false;
  int _likeId = 0;
  int _likeCount = 0;
  bool _isLoadingLike = false;

  @override
  void initState() {
    super.initState();
    _carregarLikes();
  }

  Future<void> _carregarLikes() async {
    try {
      final likes = await _postRepository.getLikes(widget.session.token, widget.post.id);
      final myLike = likes.where((l) => l.userLogin == widget.session.login);
      setState(() {
        _likeCount = likes.length;
        _isLiked = myLike.isNotEmpty;
        if (myLike.isNotEmpty) _likeId = myLike.first.id;
      });
    } catch (e) {
      debugPrint('Erro ao carregar likes: $e');
    }
  }

  Future<void> _toggleLike() async {
    setState(() => _isLoadingLike = true);
    try {
      if (_isLiked) {
        await _postRepository.unlikePost(widget.session.token, widget.post.id, _likeId);
        setState(() {
          _isLiked = false;
          _likeCount--;
          _likeId = 0;
        });
      } else {
        final id = await _postRepository.likePost(widget.session.token, widget.post.id);
        setState(() {
          _isLiked = true;
          _likeCount++;
          _likeId = id;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao curtir: $e')),
      );
    } finally {
      setState(() => _isLoadingLike = false);
    }
  }

  Future<void> _deletePost() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir post'),
        content: const Text('Tem certeza que deseja excluir este post?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await _postRepository.deletePost(widget.session.token, widget.post.id);
      print('Post ${widget.post.id} deletado com sucesso!');
      widget.onDeleted?.call();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao deletar: $e')),
        );
      }
    }
  }

  String _formatTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }

  @override
  Widget build(BuildContext context) {
    final isMyPost = widget.post.userLogin == widget.session.login;

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PostDetailTemplate(
            post: widget.post,
            session: widget.session,
          ),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('img/logo.png'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.post.userLogin,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '· ${_formatTime(widget.post.createdAt)}',
                        style: TextStyle(color: Colors.grey[500], fontSize: 13),
                      ),
                      const Spacer(),
                      if (isMyPost)
                        IconButton(
                          icon: const Icon(Icons.more_horiz, size: 18, color: Colors.grey),
                          onPressed: _deletePost,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(widget.post.message, style: const TextStyle(fontSize: 15)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PostDetailTemplate(
                              post: widget.post,
                              session: widget.session,
                              autoFocusReply: true,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.chat_bubble_outline, size: 18, color: Colors.grey[500]),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      InkWell(
                        onTap: _isLoadingLike ? null : _toggleLike,
                        child: Row(
                          children: [
                            _isLoadingLike
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(strokeWidth: 1.5),
                                  )
                                : Icon(
                                    _isLiked ? Icons.favorite : Icons.favorite_border,
                                    size: 18,
                                    color: _isLiked ? Colors.red : Colors.grey[500],
                                  ),
                            const SizedBox(width: 4),
                            Text(
                              '$_likeCount',
                              style: TextStyle(
                                color: _isLiked ? Colors.red : Colors.grey[500],
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
