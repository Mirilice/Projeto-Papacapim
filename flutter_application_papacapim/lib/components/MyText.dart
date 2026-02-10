import 'package:flutter/widgets.dart';

class MyText extends StatelessWidget{

  final String text;
  const MyText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text),
      );
  }
}
