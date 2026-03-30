import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/MyPost.dart';
import 'package:flutter_application_1/components/MyTitle.dart';
import 'package:flutter_application_1/models/UserSession.dart';
import 'package:flutter_application_1/models/UpdateUser.dart';
import 'package:flutter_application_1/repositories/UserRepository.dart';
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
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  
  final _repository = UserRepository(UserService());

  bool _isFocused = false;
  bool _isSearching = false; 
  UpdateUser? _usuarioEncontrado;
  String? _erroBusca;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _realizarBusca(String login) async {
    if (login.trim().isEmpty) {
      setState(() {
        _isSearching = false;
        _usuarioEncontrado = null;
        _erroBusca = null;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _usuarioEncontrado = null;
      _erroBusca = null;
    });

    try {
      UpdateUser user = await _repository.getUserProfile(
        login.trim(), 
        widget.session.token
      );
      
      setState(() {
        _usuarioEncontrado = user;
      });
    } catch (e) {
      setState(() {
        _erroBusca = "Usuário $login não encontrado! :()";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserTemplate(session: widget.session)),
                );
              },
              child: const CircleAvatar(
                backgroundImage: AssetImage('img/logo.png'),
              ),
            ),
          ),
          flexibleSpace: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(80, 10, 15, 10),
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
                  onSubmitted: _realizarBusca,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
                    hintText: "Buscar",
                    hintStyle: TextStyle(color: Colors.grey[600], fontSize: 15),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    suffixIcon: _isFocused || _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey, size: 20),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _isSearching = false;
                                _usuarioEncontrado = null;
                                _erroBusca = null;
                              });
                            },
                          )
                        : const Icon(Icons.search, color: Colors.transparent),
                  ),
                  onChanged: (value) {
                    if (value.isEmpty) {
                      setState(() {
                        _isSearching = false;
                        _usuarioEncontrado = null;
                        _erroBusca = null;
                      });
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ),
      body: _isSearching ? _buildResultadoBusca() : _buildFeedOriginal(),
      
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: const Color.fromARGB(255, 154, 143, 216),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NewPostTemplate(session: widget.session)),
        ),
        child: const Text('+', style: TextStyle(color: Colors.white, fontSize: 24)),
      ),
    );
  }

  Widget _buildFeedOriginal() {
    return SingleChildScrollView(
      child: Column(
        children: [
          MyPost(username: 'maliceDograu', handle: 'PresaPolítica', content: 'Beijos Brasil', profileImg: 'img/logo.png', time: 4, comments: 10, reposts: 5, favorites: 400),
          MyPost(username: 'vito', handle: 'astvito', content: 'VAI TOMANDO', profileImg: 'img/logo.png', time: 14, comments: 19, reposts: 414, favorites: 8700),
          MyPost(username: 'Mika', handle: 'chicosagrado', content: 'Morrendo com essa', profileImg: 'img/logo.png', time: 9, comments: 0, reposts: 0, favorites: 0),
          const SizedBox(height: 20),
          MyTitle(text: 'Isso é tudo.'),
        ],
      ),
    );
  }

  Widget _buildResultadoBusca() {
    if (_erroBusca != null) {
      return Center(
        child: Text(_erroBusca!, style: const TextStyle(color: Colors.grey, fontSize: 16)),
      );
    }
    if (_usuarioEncontrado != null) {
      return ListView(
        padding: const EdgeInsets.only(top: 10),
        children: [
          ListTile(
            leading: const CircleAvatar(backgroundImage: AssetImage('img/logo.png')),
            title: Text(_usuarioEncontrado!.name ?? "Não informado", 
            style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("@${_usuarioEncontrado!.login}"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserTemplate(
                    session: widget.session,
                    searchedUser: _usuarioEncontrado, 
                  ),
                ),
              );
            },
          ),
        ],
      );
    }

    return const Center(child: CircularProgressIndicator());
  }
}