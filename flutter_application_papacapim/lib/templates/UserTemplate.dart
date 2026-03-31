import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/MyButton.dart'; 
import 'package:flutter_application_1/models/Post.dart';
import 'package:flutter_application_1/models/UserSession.dart';
import 'package:flutter_application_1/models/UpdateUser.dart';
import 'package:flutter_application_1/repositories/FollowRepository.dart';
import 'package:flutter_application_1/repositories/PostRepository.dart';
import 'package:flutter_application_1/services/FollowService.dart';
import 'package:flutter_application_1/services/PostService.dart';
import 'package:flutter_application_1/components/PostCard.dart';
import 'package:flutter_application_1/templates/EditUserTemplate.dart';
import 'package:flutter_application_1/templates/NewPostTemplate.dart';

class UserTemplate extends StatefulWidget {
  final UserSession session;
  final UpdateUser? searchedUser; 

  const UserTemplate({
    super.key, 
    required this.session, 
    this.searchedUser,
  });

  @override
  State<UserTemplate> createState() => _UserTemplateState();
}

class _UserTemplateState extends State<UserTemplate> {
  final _followerRepository = FollowRepository(FollowService());
  final _postRepository = PostRepository(PostService());

  bool _isLoadingFollowData = false;
  bool _isLoadingPosts = true;
  bool _isFollowing = false;
  bool _isMyProfile = false;
  
  int? _followRelationId;
  int _numeroSeguidores = 0;
  int _numeroSeguindo = 0;

  List<Post> _userPosts = [];

  @override
  void initState() {
    super.initState();
    _isMyProfile = widget.searchedUser == null || widget.searchedUser!.login == widget.session.login;
    _carregarDadosDeFollow();
    _carregarPostsDoUsuario();
  }

  Future<void> _carregarDadosDeFollow() async {
    setState(() => _isLoadingFollowData = true);
    try {
      final loginAlvo = _isMyProfile ? widget.session.login : widget.searchedUser!.login!;
      final token = widget.session.token;

      final followers = await _followerRepository.getFollowers(loginAlvo, token);

      bool isFollowing = false;
      if (!_isMyProfile) {
        isFollowing = followers.any((f) => f.login == widget.session.login);
      }

      setState(() {
        _isFollowing = isFollowing;
        _numeroSeguidores = followers.length;
      });

      print('>>> Seguidores carregados: $_numeroSeguidores | já segue: $_isFollowing');
    } catch (e) {
      debugPrint("Erro ao carregar dados de follow: $e");
    } finally {
      setState(() => _isLoadingFollowData = false);
    }
  }

  Future<void> _carregarPostsDoUsuario() async {
    setState(() => _isLoadingPosts = true);
    try {
      final login = _isMyProfile ? widget.session.login : widget.searchedUser!.login!;
      final posts = await _postRepository.getUserPosts(widget.session.token, login);
      setState(() => _userPosts = posts);
      print('>>> Posts carregados: ${posts.length}');
    } catch (e) {
      debugPrint("Erro ao carregar posts: $e");
    } finally {
      setState(() => _isLoadingPosts = false);
    }
  }

  Future<void> _toggleFollow() async {
    setState(() => _isLoadingFollowData = true);
    try {
      final targetLogin = widget.searchedUser!.login!;
      final token = widget.session.token;

      if (_isFollowing) {
        int? idParaUnfollow = _followRelationId;

        if (idParaUnfollow == null) {
          final relation = await _followerRepository.followUser(targetLogin, token);
          idParaUnfollow = relation?.id;
        }

        if (idParaUnfollow == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Saia e entre novamente no perfil para deixar de seguir.")),
          );
          setState(() => _isLoadingFollowData = false);
          return;
        }

        await _followerRepository.unfollowUser(targetLogin, idParaUnfollow, token);
        setState(() {
          _isFollowing = false;
          _followRelationId = null;
        });
        print('Deixou de seguir $targetLogin');
      } else {
        final relation = await _followerRepository.followUser(targetLogin, token);
        setState(() {
          _isFollowing = true;
          _followRelationId = relation?.id;
        });
        print('Seguindo $targetLogin | relationId: ${relation?.id}');
      }
    } catch (e) {
      print('[_toggleFollow] Erro: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: $e")),
      );
    } finally {
      setState(() => _isLoadingFollowData = false);
    }
  }

String _getAnoIngresso() {
  final createdAt = widget.searchedUser?.createdAt ?? widget.session.created_at;
  if (createdAt.isEmpty) return '2026';
  try {
    return DateTime.parse(createdAt).year.toString();
  } catch (_) {
    return '2026';
  }
}
  @override
  Widget build(BuildContext context) {
    final String username = _isMyProfile ? widget.session.name : (widget.searchedUser?.name ?? '');
    final String handle = _isMyProfile ? widget.session.login : (widget.searchedUser?.login ?? '');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil"),
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  color: Colors.blue[300],
                ),
                Positioned(
                  bottom: -40,
                  left: 20,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('img/logo.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: _isMyProfile
                  ? OutlinedButton(
                      onPressed: () async {
                        final result = await Navigator.push<Map<String, dynamic>>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditUserTemplate(session: widget.session),
                          ),
                        );

                        if (result != null) {
                          setState(() {
                            widget.session.name = result['name'] ?? widget.session.name;
                            widget.session.login = result['login'] ?? widget.session.login;
                          });
                          _carregarPostsDoUsuario(); 
                        }
                      },
                      style: OutlinedButton.styleFrom(shape: const StadiumBorder()),
                      child: const Text("Editar perfil"),
                    )
                  : _isLoadingFollowData 
                    ? const Padding(
                        padding: EdgeInsets.only(right: 20, top: 10),
                        child: SizedBox(
                          width: 20, height: 20, 
                          child: CircularProgressIndicator(strokeWidth: 2)
                        ),
                      )
                    : SizedBox(
                        width: 150, 
                        height: 40,
                        child: MyButton(
                          text: _isFollowing ? "Seguindo" : "Seguir",
                          onPressed: _toggleFollow,
                        ),
                      ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "@$handle",
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  const Text("Papacapim é top demais!!!"),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.calendar_month, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        "Ingressou em ${_getAnoIngresso()}",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (_numeroSeguindo > 0) ...[
                        Text("$_numeroSeguindo ", style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text("Seguindo", style: TextStyle(color: Colors.grey[600])),
                        const SizedBox(width: 15),
                      ],
                      // Text("$_numeroSeguidores ", style: const TextStyle(fontWeight: FontWeight.bold)),
                      // Text("Seguidores", style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Divider(thickness: 0.5),

            // Posts do usuário
            if (_isLoadingPosts)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_userPosts.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    "Nenhum post ainda.",
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                ),
              )
            else
              ..._userPosts.map((post) => PostCard(
                post: post,
                session: widget.session,
                onDeleted: _carregarPostsDoUsuario,
              )),
          ],
        ),
      ),
      floatingActionButton: _isMyProfile
          ? FloatingActionButton(
              shape: const CircleBorder(),
              backgroundColor: Colors.blue,
              onPressed: () async {
                final postou = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(builder: (context) => NewPostTemplate(session: widget.session)),
                );
                if (postou == true) _carregarPostsDoUsuario();
              },
              child: const Text('+', style: TextStyle(color: Colors.white, fontSize: 24)),
            )
          : null,
    );
  }
}
