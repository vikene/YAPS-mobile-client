import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Permissions extends StatelessWidget {
  Permissions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Permissions"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          iconSize: 30.0,
          onPressed: () => {context.go("/")},
        ),
      ),
      body: const Center(
        child: Text("I am a permissions page"),
      ),
    );
  }
}
