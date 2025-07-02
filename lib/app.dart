import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'routes.dart';

class PawPinApp extends StatelessWidget {
  const PawPinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'PawPin Flutter',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepPurple),
      routerConfig: router,
    );
  }
}
