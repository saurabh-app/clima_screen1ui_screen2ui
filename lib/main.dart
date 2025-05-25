import 'package:clima_screen1ui_screen2ui/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Climate());
}

class Climate extends StatelessWidget {
  const Climate({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, 
      home: HomeScreen(),
    );
  }
}