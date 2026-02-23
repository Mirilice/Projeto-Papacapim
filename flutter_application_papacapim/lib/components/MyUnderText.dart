import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyUnderText extends StatelessWidget{

  final String text;
  final Widget page;
  const MyUnderText({super.key, required this.text, required this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap:(){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Text(
          text,
          style: const TextStyle(
            decoration: TextDecoration.underline,
          )
        ),
        ),
      );
  }
}
