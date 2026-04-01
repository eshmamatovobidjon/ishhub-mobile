import 'package:flutter/material.dart';

class IshHubApp extends StatelessWidget {
  const IshHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IshHub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF2E7D32),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(child: Text('IshHub')),
      ),
    );
  }
}
