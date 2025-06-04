
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:vibration/vibration.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PairScreen(),
    );
  }
}

class PairScreen extends StatefulWidget {
  @override
  _PairScreenState createState() => _PairScreenState();
}

class _PairScreenState extends State<PairScreen> {
  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Emparejar por código')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _codeController,
              decoration: InputDecoration(
                labelText: 'Código de sala',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RoomScreen(roomCode: _codeController.text),
                  ),
                );
              },
              child: Text('Entrar'),
            ),
          ],
        ),
      ),
    );
  }
}

class RoomScreen extends StatefulWidget {
  final String roomCode;
  RoomScreen({required this.roomCode});

  @override
  _RoomScreenState createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  late DatabaseReference _roomRef;

  @override
  void initState() {
    super.initState();
    _roomRef = FirebaseDatabase.instance.ref('rooms/\${widget.roomCode}');
    _roomRef.onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      if (data != null && data.containsKey('lastPing')) {
        Vibration.vibrate(duration: 100);
      }
    });
  }

  void sendPing() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    _roomRef.update({'lastPing': timestamp});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sala: \${widget.roomCode}')),
      body: Center(
        child: IconButton(
          iconSize: 100,
          icon: Icon(Icons.notifications_active),
          onPressed: sendPing,
        ),
      ),
    );
  }
}
