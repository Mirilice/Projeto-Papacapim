import 'package:flutter/material.dart';
import 'package:flutter_application_1/templates/LoginTemplate.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Papacapim',
      home: LoginTemplate(),
      theme: ThemeData(
        textTheme: GoogleFonts.nunitoSansTextTheme(), 
      ),
    );
  }
}

