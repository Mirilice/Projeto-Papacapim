import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/MyPost.dart';
import 'package:flutter_application_1/components/MyTitle.dart';
import 'package:flutter_application_1/models/UserSession.dart';
import 'package:flutter_application_1/templates/NewPostTemplate.dart';
import 'package:flutter_application_1/templates/UserTemplate.dart';

class FeedTemplate extends StatelessWidget {
  final UserSession session;
  const FeedTemplate({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => UserTemplate(session: session)));
              },
              child: const CircleAvatar(
                backgroundImage: AssetImage('img/logo.png'),
              ),
            ),
          ),
          flexibleSpace: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(80, 10, 15, 10), 
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  textAlign: TextAlign.center, 
                  textAlignVertical: TextAlignVertical.center,
                  onTap: () {},
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
                    
                    hintText: "Buscar",
                    hintStyle: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 15,
                    ),
                    
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    suffixIcon: const Icon(Icons.search, color: Colors.transparent), 
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MyPost(
                username: 'maliceDograu',
                handle: 'PresaPolítica',
                content: 'Beijos Brasil',
                profileImg: 'img/logo.png',
                time: 4,
                comments: 10,
                reposts: 5,
                favorites: 400),
            MyPost(
                username: 'vito',
                handle: 'astvito',
                content: 'VAI TOMANDO',
                profileImg: 'img/logo.png',
                time: 14,
                comments: 19,
                reposts: 414,
                favorites: 8700),
            MyPost(
                username: 'Mika',
                handle: 'chicosagrado',
                content: 'Morrendo com essa',
                profileImg: 'img/logo.png',
                time: 9,
                comments: 0,
                reposts: 0,
                favorites: 0),
            MyPost(
                username: 'aninha',
                handle: 'indiazinha',
                content: 'Preciso muito receber meu salário pqp',
                profileImg: 'img/logo.png',
                time: 3,
                comments: 61,
                reposts: 9200,
                favorites: 27000),
            MyPost(
                username: 'ryan maluco',
                handle: 'ryanmaluco',
                content: 'to sentido que minha vida ta mudando de temporada',
                profileImg: 'img/logo.png',
                time: 23,
                comments: 102,
                reposts: 10000,
                favorites: 32000),
            MyPost(
                username: 'aninha',
                handle: 'indiazinha',
                content: 'Preciso muito receber meu salário pqp',
                profileImg: 'img/logo.png',
                time: 3,
                comments: 61,
                reposts: 9200,
                favorites: 27000),
            MyPost(
                username: 'Nathalia Rodrigues',
                handle: 'iNathaliabrs',
                content: 'Se fizer a avaliação de saúde mental ninguém casa',
                profileImg: 'img/logo.png',
                time: 2,
                comments: 10,
                reposts: 59,
                favorites: 3800),
            const SizedBox(height: 20),
            MyTitle(text: 'Isso é tudo.'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Color.fromARGB(255, 154, 143, 216), 
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NewPostTemplate(session: session)),
        ),
        child: const Text('+', style: TextStyle(color: Colors.white, fontSize: 24)),
      ),
    );
  }
}