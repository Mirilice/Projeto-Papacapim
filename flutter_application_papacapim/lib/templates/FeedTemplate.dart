import 'package:flutter/material.dart';
//import 'package:flutter_application_1/components/MyButton.dart';
import 'package:flutter_application_1/components/MyPost.dart';
//import 'package:flutter_application_1/components/MyText.dart';
import 'package:flutter_application_1/components/MyTitle.dart';
//import 'package:flutter_application_1/components/MyUnderText.dart';


class FeedTemplate extends StatelessWidget {

  const FeedTemplate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0), 
        child: AppBar(
          flexibleSpace: SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 50.0, 
                    backgroundImage: AssetImage('img/logo.png'),
                  ),
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            MyPost(username: 'maliceDograu',
          handle: 'PresaPolítica', 
          content: 'Beijos Brasil', 
          profileImg: 'img/logo.png', 
          time: 4,
          comments: 10,
          reposts: 5,
          favorites: 400),

          MyPost(username: 'vito',
          handle: 'astvito', 
          content: 'VAI TOMANDO', 
          profileImg: 'img/logo.png', 
          time: 14,
          comments: 19,
          reposts: 414,
          favorites: 8700),

          MyPost(username: 'Mika',
          handle: 'chicosagrado', 
          content: 'Morrendo com essa', 
          profileImg: 'img/logo.png', 
          time: 9,
          comments: 0,
          reposts: 0,
          favorites: 0),

          MyPost(username: 'aninha',
          handle: 'indiazinha', 
          content: 'Preciso muito receber meu salário pqp', 
          profileImg: 'img/logo.png', 
          time: 3,
          comments: 61,
          reposts: 9200,
          favorites: 27000),

          const SizedBox(height: 100),
          MyTitle(text: 'Isso é tudo.'),

          ],
            ),
          ),
      );
  }
}

