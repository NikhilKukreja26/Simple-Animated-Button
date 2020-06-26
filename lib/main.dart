import 'package:flutter/material.dart';

import 'animated_button.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple Animations',
      home: Scaffold(
        body: Center(
          child: AnimatedButton(
            onTap: () {
              print('Animated button pressed');
            },
            animationDuartion: const Duration(milliseconds: 2000),
            initialText: 'Confirm',
            finalText: 'Submitted',
            icon: Icons.check,
            iconSize: 32.0,
            buttonStyle: ButtonStyle(
              primaryColor: Colors.green.shade600,
              secondaryColor: Colors.white,
              elevation: 20.0,
              initialTextStyle: const TextStyle(
                fontSize: 24.0,
                color: Colors.white,
              ),
              finalTextStyle: TextStyle(
                fontSize: 22.0,
                color: Colors.green.shade600,
              ),
              borderRadius: 10.0,
            ),
          ),
        ),
      ),
    );
  }
}
