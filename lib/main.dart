import 'package:flutter/material.dart';
import 'screens/closet_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Outfit Generator',
      home: ClosetScreen(),
    );
  }
}
