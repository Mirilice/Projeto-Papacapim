import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/Button.dart';
import 'package:flutter_application_1/components/MyText.dart';

class LoginTemplate extends StatelessWidget {

  const LoginTemplate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ClipOval(
          child: Image.asset(
            'img/logo.png',
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
      ),   
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MyText(text: 'Você vai aprender Flutter'),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Button(text: 'Sim'),
                  Button(text: 'Não'),
                ],
              ),
            ),
            MyText(text: 'Escolha a sua resposta.'),
            Expanded(child: Container()),
            Text('Copyright ₢ Nós Mesmos')
          ],
        ),
      )
    );
  }
}

