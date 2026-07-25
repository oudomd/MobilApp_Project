import 'package:flutter/material.dart';

class LastScanCard extends StatelessWidget {
  const LastScanCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: ListTile(
        leading: Icon(Icons.history, color: Colors.green),
        title: Text("Last Scan"),
        subtitle: Text("Today • No threats found"),
      ),
    );
  }
}
