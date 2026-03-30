import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/MyButton.dart';
import 'package:flutter_application_1/components/MyInput.dart';
import 'package:flutter_application_1/components/MyTitle.dart';
import 'package:flutter_application_1/models/UpdateUser.dart';
import 'package:flutter_application_1/models/UserSession.dart';
import 'package:flutter_application_1/repositories/UserRepository.dart';
import 'package:flutter_application_1/services/UserService.dart';
import 'package:flutter_application_1/templates/LoginTemplate.dart';

class EditUserTemplate extends StatefulWidget {
  final UserSession session;

  const EditUserTemplate({super.key, required this.session});

  @override
  State<EditUserTemplate> createState() => _EditUserTemplateState();
}

class _EditUserTemplateState extends State<EditUserTemplate> {
  final _loginController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _repository = UserRepository(UserService());

  bool _isLoading = false;
  
  String? _hintNomeAtual;

  int? _editingUserId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _loginController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _loadData() async {
    setState(() => _isLoading = true);

    try {
      final user = await _repository.getUserProfile(
        widget.session.login,
        widget.session.token,
      );

      setState(() {
        _hintNomeAtual = user.name;
        _editingUserId = user.id ?? widget.session.id; 
      });

      debugPrint('EditUser: session.id=${widget.session.id} / editingUserId=$_editingUserId');
    } catch (e) {
      if (mounted){
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Não foi possível carregar os dados atuais.")),
      );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _update() async {
    if (_passwordController.text.isNotEmpty) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("As senhas não coincidem!"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    setState(() => _isLoading = true);

    final newData = UpdateUser(
      login: _loginController.text,
      name: _nameController.text,
      password: _passwordController.text,
    );

    try {
      final targetId = _editingUserId ?? widget.session.id;
      await _repository.userPatch(
        targetId,
        newData,
        widget.session.token,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Perfil atualizado!")),
      );

      if (newData.password != null && newData.password!.isNotEmpty) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginTemplate()),
          (route) => false,
        );
      } else {
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro $e"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _delete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Excluir Conta"),
        content: const Text("Tem certeza? Esta ação não pode ser desfeita."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              _performDelete();
            }, 
            child: const Text("Excluir", style: TextStyle(color: Colors.red))
          ),
        ],
      ),
    );
  }

  void _performDelete() async {
    setState(() => _isLoading = true);
    try {
      final targetId = _editingUserId ?? widget.session.id;
      final ok = await _repository.deleteUser(targetId, widget.session.token);
      if (ok && mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginTemplate()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erro: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          _isLoading
              ? const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: CircularProgressIndicator(),
                )
              : TextButton(
                  onPressed: _update,
                  child: const Text('Salvar',
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold)),
                ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  color: const Color.fromARGB(255, 230, 237, 240),
                  child: const Icon(Icons.add_a_photo_outlined),
                ),
                Positioned(
                  bottom: -30,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: const AssetImage('img/logo.png'), 
                    child: const Icon(Icons.camera_enhance, color: Colors.white70),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  MyTitle(text: "Editar perfil"),
                  MyInput(
                    label: "Nome",
                    hint: _hintNomeAtual ?? "Buscando nome...",
                    icon: Icons.abc,
                    controller: _nameController,
                  ),
                  MyInput(
                    label: "Usuário",
                    hint: widget.session.login,
                    icon: Icons.person,
                    controller: _loginController,
                  ),
                  MyInput(
                    label: "Senha",
                    hint: "Digite a nova senha",
                    icon: Icons.lock,
                    controller: _passwordController,
                    obscureText: true,
                  ),
                  MyInput(
                    label: "Confirme a senha",
                    hint: "Confirme a nova senha",
                    icon: Icons.lock,
                    controller: _confirmPasswordController,
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: _delete,
                    child: const Text("Excluir minha conta permanentemente", 
                      style: TextStyle(color: Colors.redAccent)),
                  ),
                  MyButton(text: 'SAIR', page: const LoginTemplate()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}