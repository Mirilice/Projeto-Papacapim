import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/MyTitle.dart';

class EditUserTemplate extends StatelessWidget {
  final String name =  "Maria Alice";
  final String usuario =  "malice_dev";
  final String bio  = "Pode passar que o cachorro tá amarrado";
  
  const EditUserTemplate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () { },
            child: const Text(
              'Salvar', 
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  color: const Color.fromARGB(255, 230, 237, 240),
                  child: const Icon(Icons.add_a_photo_outlined),
                ),
                Positioned(
                  bottom: -30,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: const AssetImage('img/logo.png'),
                    child: const Icon(Icons.camera_enhance, color: Colors.white70),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  MyTitle(text: "Editar perfil"),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Nome',
                        hintText: name,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Usuário',
                        hintText: usuario,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Bio',
                        hintText: bio,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

}

}  
