import 'package:flutter/material.dart';
import '../../../data/repositories/scan_repository.dart';
import '../../../models/scan_result.dart';
import '../../utils/async_data.dart';

// show every scan from every victim
class ScanHistoryScreen extends StatefulWidget {
  const ScanHistoryScreen({super.key});

  @override
  State<ScanHistoryScreen> createState() => _ScanHistoryScreenState();
}

class _ScanHistoryScreenState extends State<ScanHistoryScreen> {
  AsyncData<List<ScanResult>> data = AsyncData.notStarted();

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  void _fetch() async {
    setState(() => data = AsyncData.loading());
    try {
      final scans = await ScanRepository.global.fetchScans();
      setState(() => data = AsyncData.success(scans));
    } catch (e) {
      setState(() => data = AsyncData.error(e.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan History'),
        actions: [IconButton(onPressed: _fetch, icon: Icon(Icons.refresh))],
      ),
      body: switch (data.status) {
        AsyncStatus.notStarted => Center(child: Text('Loading...')),
        AsyncStatus.loading => Center(child: CircularProgressIndicator()),
        AsyncStatus.error => Center(
          child: Text(data.error!, style: TextStyle(color: Colors.red)),
        ),
        AsyncStatus.success => _buildList(data.value!),
      },
    );
  }

  Widget _buildList(List<ScanResult> scans) {
    if (scans.isEmpty) return Center(child: Text('No scans yet'));
    return ListView.builder(
      itemCount: scans.length,
      itemBuilder: (ctx, i) {
        final s = scans[i];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: ListTile(
            leading: Icon(Icons.phone_android),
            title: Text(s.deviceModel),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Battery: ${s.battery}% · Files: ${s.fileCount}',
                ),
                Text(
                  '${s.timestamp.toLocal()}',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            trailing: s.latitude != null
                ? Icon(Icons.location_on, color: Colors.green)
                : Icon(Icons.location_off, color: Colors.grey),
          ),
        );
      },
    );
  }
}
