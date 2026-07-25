import 'package:flutter/material.dart';

class SecurityTipCard extends StatelessWidget {
  const SecurityTipCard({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.security, color: Colors.blue),
            SizedBox(width: 10),
            Expanded(
              child: Text(text),
            ),
          ],
        ),
      ),
    );
  }
}
