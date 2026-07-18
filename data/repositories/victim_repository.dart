import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/victim.dart';
import 'repository_exception.dart';
import 'package:http/http.dart';

class VictimRepository {
  // Handles all Firebase operations related to victims.
  static final global = VictimRepository();

  final Uri baseUri = Uri.parse(
    'https://qisk-4aa21-default-rtdb.asia-southeast1.firebasedatabase.app/',
  );

  //  ftech list of victims
  Future<List<Victim>> fetchVictims() async {
    final Uri scanUri = baseUri.replace(path: '/qisk/victims.json');

    Response response = await http.get(scanUri);

    if (response.statusCode != 200) {
      throw RepositoryException('Failed to fetch victims.');
    }
    if (response.body == 'null') {
      return [];
    }

    final Map<String, dynamic> json = jsonDecode(response.body);

    return json.entries
        .map((e) => Victim.fromJson(e.key, Map<String, dynamic>.from(e.value)))
        .toList()
      ..sort((a, b) => b.lastSeen.compareTo(a.lastSeen));
  }

  // insert victim
  Future<void> insertVictime(Victim victim) async {
    final Uri victimUri = baseUri.replace(
      path: '/qisk/victims/${victim.id}.json',
    );
    Response response = await http.put(
      victimUri,
      body: jsonEncode(victim.toJson()),
    );

    if (response.statusCode != 200) {
      throw RepositoryException('Failed to insert victim.');
    }
  }
}
