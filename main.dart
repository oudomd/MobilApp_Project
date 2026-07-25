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
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF5F7FA), Color(0xFFE8F5E9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.bubble_chart,
                    size: 70,
                    color: Colors.green,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'QISK',
                  style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 6),

                Text(
                  'Qisk Information Simulation Kit',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                ),

                const SizedBox(height: 50),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      elevation: 2,
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => VictimScreen()),
                    ),
                    icon: const Icon(Icons.phone_android),
                    label: const Text(
                      'Victim Panel',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      elevation: 2,
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => DashboardScreen()),
                    ),
                    icon: const Icon(Icons.share_location_sharp),
                    label: const Text(
                      'Hacker Panel',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
