import 'dart:convert';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import '../../models/scan_result.dart';
import 'repository_exception.dart';

// Handles all Firebase operations related to scans.
class ScanRepository {
  static final global = ScanRepository();

  final String baseUri =
      'https://qisk-4aa21-default-rtdb.asia-southeast1.firebasedatabase.app/qisk.json';

  // upload scans to firebase
  Future<void> uploadScans(ScanResult scan) async {
    Response response = await http.post(
      Uri.parse('$baseUri/qisk/scans.json'),
      body: jsonEncode(scan.toJson()),
    );

    if (response.statusCode != 200) {
      throw RepositoryException('Failed to upload scan');
    }
  }

  // fetch all scans
  Future<List<ScanResult>> fetchScans() async {
    Response response = await http.get(Uri.parse('$baseUri/qisk/scans.json'));

    if (response.statusCode != 200) {
      throw RepositoryException('Failed to fetch scans');
    }

    if (response.body == 'null') return [];

    final Map<String, dynamic> json = jsonDecode(response.body);

    return json.entries
        .map(
          (e) => ScanResult.fromJson(e.key, Map<String, dynamic>.from(e.value)),
        )
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  // fetch scan for one victim

  Future<List<ScanResult>> fetchScanForVictime(String victimId) async {
    final all = await fetchScans();
    return all.where((e) => e.victimId == victimId).toList();
  }
}
