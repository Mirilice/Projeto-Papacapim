import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/MyPostUser.dart';
import 'package:flutter_application_1/models/UserSession.dart';
import 'package:flutter_application_1/templates/EditUserTemplate.dart';
import 'package:flutter_application_1/templates/NewPostTemplate.dart';

class UserTemplate extends StatelessWidget {
  static const String myUsername = "Maria Alice";
  static const String myHandle = "malice_dev";
  static const String myBio = "Pode passar que o cachorro tá amarrado";
  static const int myYear = 2025;

  final UserSession session;
  const UserTemplate({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil"),
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  color: Colors.blue[300],
                ),
                Positioned(
                  bottom: -40,
                  left: 20,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('img/logo.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: OutlinedButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditUserTemplate(session: session))),
                  style: OutlinedButton.styleFrom(
                    shape: const StadiumBorder(),
                  ),
                  child: const Text("Editar perfil"),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    myUsername,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "@$myHandle",
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    myBio,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.calendar_month, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text("Ingressou em $myYear",
                          style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Divider(thickness: 0.5),
            MyPostUser(
              username: myUsername,
              handle: myHandle,
              profileImg: 'img/logo.png',
              time: 2,
              comments: 3,
              reposts: 1,
              favorites: 2,
              content: "Desenvolvendo um projeto ESG incrível com IFBA e Nubank! 🚀",
            ),
            MyPostUser(
              username: myUsername,
              handle: myHandle,
              profileImg: 'img/logo.png',
              time: 2,
              comments: 3,
              reposts: 1,
              favorites: 2,
              content: "Saudades da minha viagem... ",
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Colors.blue,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NewPostTemplate(session: session)),
        ),
        child: const Text('+', style: TextStyle(color: Colors.white, fontSize: 24)),
      ),
    );
  }
}