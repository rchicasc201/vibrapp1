
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Vibrapp")),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              if (await Vibration.hasVibrator() ?? false) {
                Vibration.vibrate(pattern: [0, 300, 200, 300]);
              }
            },
            child: Text("Vibrar"),
          ),
        ),
      ),
    );
  }
}
