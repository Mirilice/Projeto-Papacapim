import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/MyButton.dart';
import 'package:flutter_application_1/components/MyInput.dart';
import 'package:flutter_application_1/components/MyText.dart';
import 'package:flutter_application_1/components/MyTitle.dart';
import 'package:flutter_application_1/components/MyUnderText.dart';
import 'package:flutter_application_1/repositories/UserRepository.dart';
import 'package:flutter_application_1/services/UserService.dart';
import 'package:flutter_application_1/templates/FeedTemplate.dart';
import 'package:flutter_application_1/templates/RegisterTemplate.dart';


class LoginTemplate extends StatefulWidget {

  const LoginTemplate({super.key});

  @override
  State<LoginTemplate> createState() => _LoginTemplateState();
}

class _LoginTemplateState extends State<LoginTemplate>{

  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  final _repository = UserRepository(UserService());

  bool _isLoading = false;

void _login() async{
  setState(() {
    _isLoading = true;
  });
  try{
    final session = await _repository.userLogin(
      _loginController.text,
      _passwordController.text
    );

    if(mounted){
      Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context)=> FeedTemplate(session: session)));
    }
  }catch(e){
    if(mounted){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro $e"), 
          backgroundColor: Colors.red
        )
      );
    }
  }finally{
    if (mounted) { 
      setState(() {
        _isLoading = false; 
      });
    }
  }
}

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0), 
        child: AppBar(
          flexibleSpace: SafeArea(
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
            MyInput(label: 'Login', hint: 'Digite seu usuário', icon: Icons.person, controller: _loginController),
            MyInput(label: 'Senha', hint: 'Digite sua senha', icon: Icons.lock, controller: _passwordController, obscureText: true),

          const SizedBox(height: 10),

          _isLoading
            ? const CircularProgressIndicator()
            :  MyButton(text: 'Entrar', onPressed: _login), 
          MyText(text: 'Não tem conta?'),
          MyUnderText(text: 'Faça cadastro aqui.', page: RegisterTemplate(),)
  ],
)
      )
    );
  }
}

