import 'dart:io';

import 'package:flutter/material.dart';

class SecretPage extends StatelessWidget {
  const SecretPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Wow, secret page :O"),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Hello, This is a secret page \n idk what to do with it :p", style: TextStyle(fontSize: 30),),
            Image(image: AssetImage("assets/cat.jpg"))
          ],
        ),
      ),
    );
  }
}
