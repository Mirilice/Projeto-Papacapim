import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/MyButton.dart';
import 'package:flutter_application_1/models/UserSession.dart';

class NewPostTemplate extends StatelessWidget {
  final UserSession session;
  const NewPostTemplate ({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Center(
              child: SizedBox(
                width: 90,
                height: 45,
                child: MyButton(
                  text: "Postar",
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('img/logo.png'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                autofocus: true, 
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  hintText: "O que está acontecendo?",
                  border: InputBorder.none, 
                ),
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


  
