import 'package:flutter/widgets.dart';

class MyUnderText extends StatelessWidget{

  final String text;
  const MyUnderText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: const TextStyle(
          decoration: TextDecoration.underline,
        )
        )
      );
  }
}
