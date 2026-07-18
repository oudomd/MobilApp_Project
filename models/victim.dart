// Represents a device that has been scanned. 
class Victim {
  final String id;
  final String deviceModel;
  final String androidVersion;
  final DateTime lastSeen;

  Victim({
    required this.id,
    required this.deviceModel,
    required this.androidVersion,
    required this.lastSeen,
  });

  static Victim fromJson(String id, Map<String, dynamic> json) {
    return Victim(
      id: id,
      deviceModel: json['deviceModel'] ?? '',
      androidVersion: json['androidVersion'] ?? '',
      lastSeen: DateTime.parse(json['lastSeen']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deviceModel': deviceModel,
      'androidVersion': androidVersion,
      'lastSeen': lastSeen.toIso8601String(),
    };
  }
}