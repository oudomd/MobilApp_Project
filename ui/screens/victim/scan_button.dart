import 'package:flutter/material.dart';
import 'scan_screen.dart';

class ScanButton extends StatelessWidget {
  const ScanButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.search),
      label: const Text("Scan Now"),
      style: ElevatedButton.styleFrom(minimumSize: const Size(180, 55)),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ScanScreen()),
        );
      },
    );
  }
}
