import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/MyButton.dart';
import 'package:flutter_application_1/components/MyInput.dart';
import 'package:flutter_application_1/components/MyText.dart';
import 'package:flutter_application_1/components/MyTitle.dart';
import 'package:flutter_application_1/models/CreateUser.dart';
import 'package:flutter_application_1/repositories/UserRepository.dart';
import 'package:flutter_application_1/services/UserService.dart';
import 'package:flutter_application_1/templates/FeedTemplate.dart';
import 'package:flutter_application_1/templates/LoginTemplate.dart';
import 'package:flutter_application_1/components/MyUnderText.dart';

class RegisterTemplate extends StatefulWidget {

  const RegisterTemplate({super.key});

  @override
  State<RegisterTemplate> createState() => _RegisterTemplateState();
}

class _RegisterTemplateState extends State<RegisterTemplate>{

  final _loginController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _repository = UserRepository(UserService());

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loginController.clear();
    _nameController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
  }

  void _register() async{

    setState(() => _isLoading = true);
    try{
      CreateUser newUser = CreateUser(login: _loginController.text, name: _nameController.text, password: _passwordController.text);
      await _repository.createUser(newUser);

      final sessionToken = await _repository.userLogin(
        _loginController.text,
        _passwordController.text
      );
      if (!mounted) return;

      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context)=> FeedTemplate(session: sessionToken)));
    }catch(e){
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro $e"), 
          backgroundColor: Colors.red
        )
      );
    }finally{
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0), 
        child: AppBar(
          flexibleSpace: Container(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 50.0, 
                    backgroundImage: AssetImage('img/logo.png'),
                  ),
              ),
            ),
          ),
        ),
      ),  
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyTitle(text: 'Papacapim'),
            MyInput(label: 'Login', hint: 'Crie um login', icon: Icons.person, controller: _loginController),
            MyInput(label: 'Nome', hint: 'Digite seu nome', icon: Icons.abc, controller: _nameController),
            MyInput(label: 'Senha', hint: 'Digite sua senha', icon: Icons.lock, controller: _passwordController, obscureText: true),
            MyInput(label: 'Confirme a senha', hint: 'Confirme a sua senha', icon: Icons.lock, controller: _confirmPasswordController, obscureText: true),

          const SizedBox(height: 10),

          _isLoading
            ? const CircularProgressIndicator()
            :  MyButton(text: 'Entrar', onPressed: _register),         
          MyText(text: 'Já tem conta?'),
          MyUnderText(text: 'Faça login aqui.', page: LoginTemplate()),
  ],
)
      )
    );
  }
}

