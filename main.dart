import 'package:flutter/material.dart';
import 'ui/screens/victim/victim_screen.dart';
import 'ui/screens/hacker/dashboard_screen.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QISK',
      home: ModeSelectScreen(),
    ),
  );
}

class ModeSelectScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bubble_chart, size: 80, color: Colors.green),
            SizedBox(height: 16),
            Text(
              'QISK',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            Text(
              'Qisk Info Stealer Kit',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 60),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => VictimScreen()),
              ),
              icon: Icon(Icons.phone_android),
              label: Text('Victim Side'),
            ),
            SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DashboardScreen()),
              ),
              icon: Icon(Icons.analytics),
              label: Text('Hacker Side'),
            ),
          ],
        ),
      ),
    );
  }
}







