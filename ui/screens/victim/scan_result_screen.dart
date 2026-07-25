import 'package:flutter/material.dart';

class ScanResultScreen extends StatelessWidget {
  final int files;

  const ScanResultScreen({super.key, required this.files});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Result")),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 90),

            const SizedBox(height: 20),

            const Text(
              "Scan Complete",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Text("Files Scanned : $files"),

            const Text("Threats Found : 0"),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close Result Screen
                Navigator.pop(context); // Close Scan Screen
              },
              child: const Text("Back Home"),
            ),
          ],
        ),
      ),
    );
  }
}
