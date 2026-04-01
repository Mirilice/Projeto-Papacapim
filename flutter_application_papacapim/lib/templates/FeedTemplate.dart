import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/PostCard.dart';
import 'package:flutter_application_1/models/Post.dart';
import 'package:flutter_application_1/models/UpdateUser.dart';
import 'package:flutter_application_1/models/UserSession.dart';
import 'package:flutter_application_1/repositories/PostRepository.dart';
import 'package:flutter_application_1/repositories/UserRepository.dart';
import 'package:flutter_application_1/services/PostService.dart';
import 'package:flutter_application_1/services/UserService.dart';
import 'package:flutter_application_1/templates/NewPostTemplate.dart';
import 'package:flutter_application_1/templates/UserTemplate.dart';

class FeedTemplate extends StatefulWidget {
  final UserSession session;
  const FeedTemplate({super.key, required this.session});

  @override
  State<FeedTemplate> createState() => _FeedTemplateState();
}

class _FeedTemplateState extends State<FeedTemplate> {
  final _postRepository = PostRepository(PostService());
  final _userRepository = UserRepository(UserService());

  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  final _scrollController = ScrollController();

  List<Post> _posts = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;

  // resultado de busca
  bool _isSearching = false;
  List<Post> _postsBusca = [];
  UpdateUser? _usuarioEncontrado;
  String? _erroBusca;
  bool _isLoadingBusca = false;

  int _currentPage = 1;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _carregarPosts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _carregarMais();
    }
  }

  Future<void> _carregarPosts({bool reset = false}) async {
    if (reset) {
      setState(() {
        _currentPage = 1;
        _hasMore = true;
        _posts = [];
        _isLoading = true;
      });
    }
    try {
      final novos = await _postRepository.getPosts(
        widget.session.token,
        page: _currentPage,
      );
      setState(() {
        _posts.addAll(novos);
        _hasMore = novos.isNotEmpty;
      });
    } catch (e) {
      debugPrint('Erro ao carregar feed: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _carregarMais() async {
    if (_isLoadingMore || !_hasMore || _isSearching) return;
    setState(() {
      _isLoadingMore = true;
      _currentPage++;
    });
    await _carregarPosts();
    setState(() => _isLoadingMore = false);
  }

  Future<void> _atualizarFeed() async {
    _limparBusca();
    await _carregarPosts(reset: true);
  }

Future<void> _realizarBusca(String query) async {
  if (query.trim().isEmpty) {
    _limparBusca();
    return;
  }

  setState(() {
    _isSearching = true;
    _isLoadingBusca = true;
    _usuarioEncontrado = null;
    _postsBusca = [];
    _erroBusca = null;
  });

  // Busca usuário E posts ao mesmo tempo
  await Future.wait([
    _userRepository.getUserProfile(query.trim(), widget.session.token).then((user) {
      setState(() => _usuarioEncontrado = user);
    }).catchError((_) {}), // silencia se não encontrar

    _postRepository.getPosts(widget.session.token, search: query.trim()).then((posts) {
      setState(() => _postsBusca = posts);
    }).catchError((_) {}),
  ]);

  setState(() {
    _isLoadingBusca = false;
    if (_usuarioEncontrado == null && _postsBusca.isEmpty) {
      _erroBusca = 'Nenhum resultado para "$query".';
    }
  });
}

  void _limparBusca() {
    _searchController.clear();
    setState(() {
      _isSearching = false;
      _usuarioEncontrado = null;
      _postsBusca = [];
      _erroBusca = null;
      _isLoadingBusca = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => UserTemplate(session: widget.session)),
              ),
              child: const CircleAvatar(backgroundImage: AssetImage('img/logo.png')),
            ),
          ),
          flexibleSpace: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(70, 10, 56, 10),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: _searchController,
                  focusNode: _focusNode,
                  textAlign: TextAlign.start,
                  textAlignVertical: TextAlignVertical.center,
                  textInputAction: TextInputAction.search,
                  onSubmitted: _realizarBusca,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
                    hintText: 'Buscar usuário ou post',
                    hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    suffixIcon: _isSearching || _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey, size: 20),
                            onPressed: _limparBusca,
                          )
                        : null,
                  ),
                  onChanged: (v) {
                    if (v.isEmpty) _limparBusca();
                  },
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _atualizarFeed,
              tooltip: 'Atualizar feed',
            ),
          ],
        ),
      ),
      body: _isSearching ? _buildResultadoBusca() : _buildFeed(),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Colors.blue,
        onPressed: () async {
          final postou = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => NewPostTemplate(session: widget.session)),
          );
          if (postou == true) _atualizarFeed();
        },
        child: const Text('+', style: TextStyle(color: Colors.white, fontSize: 24)),
      ),
    );
  }

  Widget _buildFeed() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    if (_posts.isEmpty) {
      return const Center(
        child: Text('Nenhum post ainda.', style: TextStyle(color: Colors.grey)),
      );
    }

    return RefreshIndicator(
      onRefresh: _atualizarFeed,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _posts.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (ctx, i) {
          if (i == _posts.length) {
            return const Center(child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ));
          }
          return PostCard(
            post: _posts[i],
            session: widget.session,
            onDeleted: () => setState(() => _posts.removeAt(i)),
          );
        },
      ),
    );
  }

Widget _buildResultadoBusca() {
  if (_isLoadingBusca) return const Center(child: CircularProgressIndicator());

  if (_erroBusca != null) {
    return Center(child: Text(_erroBusca!, style: const TextStyle(color: Colors.grey)));
  }

  return ListView(
    children: [
      // Seção de usuário encontrado
      if (_usuarioEncontrado != null) ...[
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text('Usuário', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        ),
        ListTile(
          leading: const CircleAvatar(backgroundImage: AssetImage('img/logo.png')),
          title: Text(
            _usuarioEncontrado!.name ?? 'Sem nome',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text('@${_usuarioEncontrado!.login}'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => UserTemplate(
                session: widget.session,
                searchedUser: _usuarioEncontrado,
              ),
            ),
          ),
        ),
        const Divider(),
      ],

      // Seção de posts encontrados
      if (_postsBusca.isNotEmpty) ...[
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text('Posts', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        ),
        ..._postsBusca.asMap().entries.map((e) => PostCard(
          post: e.value,
          session: widget.session,
          onDeleted: () => setState(() => _postsBusca.removeAt(e.key)),
        )),
      ],
    ],
  );
}
}
