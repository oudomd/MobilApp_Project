import 'package:flutter/material.dart';
import '../../../data/repositories/scan_repository.dart';
import '../../../data/repositories/victim_repository.dart';
import '../../../models/scan_result.dart';
import '../../../models/victim.dart';
import '../../utils/async_data.dart';
import 'victim_list_screen.dart';
import 'scan_history_screen.dart';


// Fetches both scan and vicim from firebase
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
