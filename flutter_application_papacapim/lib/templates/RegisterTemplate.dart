import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/MyButton.dart';
import 'package:flutter_application_1/components/MyText.dart';
import 'package:flutter_application_1/components/MyTitle.dart';
import 'package:flutter_application_1/templates/LoginTemplate.dart';
import 'package:flutter_application_1/components/MyUnderText.dart';


class RegisterTemplate extends StatelessWidget {

  const RegisterTemplate({super.key});

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
            SizedBox(
              width: 300,
              child: TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'E-mail',
                hintText: 'Digite seu e-mail',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            ),
          const SizedBox(height: 20), 
          SizedBox(
            width: 300,
            child: TextField(
            obscureText: true, 
            decoration: InputDecoration(
              labelText: 'Senha',
              hintText: 'Digite sua senha',
              prefixIcon: Icon(Icons.lock),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          ),
          const SizedBox(height: 20), 
          SizedBox(
            width: 300,
            child: TextField(
            obscureText: true, 
            decoration: InputDecoration(
              labelText: 'Confirme a sua senha',
              hintText: 'Digite sua senha',
              prefixIcon: Icon(Icons.lock),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          ),

          const SizedBox(height: 30),

          MyButton(text: 'Entrar'),
          MyText(text: 'Já tem conta?'),
          MyUnderText(text: 'Faça login aqui.', page: LoginTemplate()),
  ],
)
      )
    );
  }
}

