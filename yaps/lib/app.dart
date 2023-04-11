import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yaps/home.dart';
import 'package:yaps/permissions.dart';

class App extends StatelessWidget {
  App({super.key});

  final GoRouter _router = GoRouter(routes: [
    GoRoute(
        path: "/",
        builder: (context, state) => Scaffold(
              body: const GridDisplay(),
            )),
    GoRoute(
        path: "/checkpermissions", builder: (context, state) => Permissions()),
  ]);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: "YAPS",
      theme: ThemeData(backgroundColor: Colors.white),
    );
  }
}
