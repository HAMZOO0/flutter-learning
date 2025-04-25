import 'package:flutter/material.dart';

void main() {
  runApp(TimerApp());
}

class TimerApp extends StatelessWidget {
  const TimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Timer App', home: TimerHomePage());
  }
}

class TimerHomePage extends StatefulWidget {
  const TimerHomePage({super.key});

  @override
  _TimerHomePageState createState() => _TimerHomePageState();
}

class _TimerHomePageState extends State<TimerHomePage> {
  int _remainingTime = 10; // Countdown starts from 10 seconds
  bool _isRunning = false;

  void _startTimer() async {
    if (_isRunning) return;

    setState(() {
      _isRunning = true;
      _remainingTime = 10;
    });

    for (int i = _remainingTime; i > 0; i--) {
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        _remainingTime--;
      });
    }

    setState(() {
      _isRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Timer App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$_remainingTime',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _startTimer, child: Text('Start Timer')),
          ],
        ),
      ),
    );
  }
}
