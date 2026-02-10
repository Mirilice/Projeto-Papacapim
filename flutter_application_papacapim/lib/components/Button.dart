import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Button extends StatelessWidget{

  final String text;
  const Button({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),

      
      child: ElevatedButton(
        onPressed: () => print(text),  
        child: Text(text)
      )
      );
  }
}
