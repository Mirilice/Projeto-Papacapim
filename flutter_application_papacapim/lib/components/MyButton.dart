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
      width: 120,
      height: 40,
      child: ElevatedButton(
        onPressed: page == null
            ? null 
            : () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page!),
          ),  
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 154, 143, 216),
              foregroundColor: Colors.black,
            ),
        child: Text(text)
      ),
    );
    
  }
}
