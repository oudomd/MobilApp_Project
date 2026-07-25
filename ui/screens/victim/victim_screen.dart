import 'package:flutter/material.dart';
import 'protection_card.dart';
import 'scan_button.dart';
import 'last_scan_card.dart';
import 'security_tip_card.dart';

class VictimScreen extends StatelessWidget {
  const VictimScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QISK Protection"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: const [
            ProtectionCard(),
            SizedBox(height: 25),
            ScanButton(),
            SizedBox(height: 25),
            LastScanCard(),
            SizedBox(height: 20),
            SecurityTipCard(text: 'Always keep your apps updated.'),
            SizedBox(height: 20),
            SecurityTipCard(text: 'Scan your mobile regularly.'),
          ],
        ),
      ),
    );
  }
}
