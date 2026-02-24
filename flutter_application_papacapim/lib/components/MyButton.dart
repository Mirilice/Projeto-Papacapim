import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyButton extends StatelessWidget{

  final String text;
  final Widget? page;
  const MyButton({super.key, required this.text, this.page});

  @override
  Widget build(BuildContext context) {
    return 
    SizedBox(
      width: 150,
      height: 90,
      child: Padding(
      padding: EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: page == null
            ? null 
            : () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page!),
          ),  
        child: Text(text)
      )
      ),
    );
    
  }
}
