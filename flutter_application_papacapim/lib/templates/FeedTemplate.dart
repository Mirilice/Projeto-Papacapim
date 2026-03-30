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
  bool _isFocused = false;

  bool _isSearchingUser = false;
  UpdateUser? _usuarioEncontrado;
  String? _erroBusca;

  String _searchQuery = '';
  int _currentPage = 1;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() => _isFocused = _focusNode.hasFocus));
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
        search: _searchQuery,
      );
      setState(() {
        if (reset) {
          _posts = novos;
        } else {
          _posts.addAll(novos);
        }
        _hasMore = novos.isNotEmpty;
      });
      print('>>> Feed carregado: ${novos.length} posts (página $_currentPage)');
    } catch (e) {
      debugPrint('Erro ao carregar feed: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _carregarMais() async {
    if (_isLoadingMore || !_hasMore) return;
    setState(() {
      _isLoadingMore = true;
      _currentPage++;
    });
    await _carregarPosts();
    setState(() => _isLoadingMore = false);
  }

  Future<void> _atualizarFeed() async {
    setState(() => _searchQuery = '');
    _searchController.clear();
    await _carregarPosts(reset: true);
  }

  void _buscarUsuario(String login) async {
    if (login.trim().isEmpty) {
      setState(() {
        _isSearchingUser = false;
        _usuarioEncontrado = null;
        _erroBusca = null;
      });
      return;
    }
    if (login.startsWith('#')) {
      final query = login.replaceFirst('#', '').trim();
      setState(() {
        _searchQuery = query;
        _isSearchingUser = false;
      });
      _carregarPosts(reset: true);
      return;
    }

    setState(() {
      _isSearchingUser = true;
      _usuarioEncontrado = null;
      _erroBusca = null;
    });

    try {
      final user = await _userRepository.getUserProfile(login.trim(), widget.session.token);
      setState(() => _usuarioEncontrado = user);
    } catch (e) {
      setState(() => _erroBusca = 'Usuário "$login" não encontrado.');
    }
  }

  void _limparBusca() {
    _searchController.clear();
    setState(() {
      _isSearchingUser = false;
      _usuarioEncontrado = null;
      _erroBusca = null;
      _searchQuery = '';
    });
    _carregarPosts(reset: true);
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
              padding: const EdgeInsets.fromLTRB(70, 10, 12, 10),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: _searchController,
                  focusNode: _focusNode,
                  textAlign: _isFocused || _searchController.text.isNotEmpty
                      ? TextAlign.start
                      : TextAlign.center,
                  textAlignVertical: TextAlignVertical.center,
                  textInputAction: TextInputAction.search,
                  onSubmitted: _buscarUsuario,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
                    hintText: 'Buscar usuário ou #post',
                    hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    suffixIcon: _isFocused || _searchController.text.isNotEmpty
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
      body: _isSearchingUser ? _buildResultadoUsuario() : _buildFeed(),
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
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.article_outlined, size: 60, color: Colors.grey),
            const SizedBox(height: 12),
            Text(
              _searchQuery.isNotEmpty ? 'Nenhum post encontrado para "$_searchQuery".' : 'Nenhum post ainda.',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
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
            onDeleted: () {
              setState(() => _posts.removeAt(i));
            },
          );
        },
      ),
    );
  }

  Widget _buildResultadoUsuario() {
    if (_erroBusca != null) {
      return Center(child: Text(_erroBusca!, style: const TextStyle(color: Colors.grey)));
    }

    if (_usuarioEncontrado != null) {
      return ListView(
        children: [
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
        ],
      );
    }

    return const Center(child: CircularProgressIndicator());
  }
}
