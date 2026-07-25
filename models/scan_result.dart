// Represents one scan event. Holds everything collected during a scan 
class ScanResult {
  final String id;
  final String victimId;
  final String deviceModel;
  final String androidVersion;
  final int battery;
  final double? latitude;
  final double? longitude;
  final int fileCount;
  final String storageSize;
  final DateTime timestamp;

  ScanResult({
    required this.id,
    required this.victimId,
    required this.deviceModel,
    required this.androidVersion,
    required this.battery,
    this.latitude,
    this.longitude,
    required this.fileCount,
    required this.storageSize,
    required this.timestamp,
  });

  static ScanResult fromJson(String id, Map<String, dynamic> json) {
    return ScanResult(
      id: id,
      victimId: json['victimId'] ?? '',
      deviceModel: json['deviceModel'] ?? '',
      androidVersion: json['androidVersion'] ?? '',
      battery: json['battery'] ?? 0,
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      fileCount: json['fileCount'] ?? 0,
      storageSize: json['storageSize'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'victimId': victimId,
      'deviceModel': deviceModel,
      'androidVersion': androidVersion,
      'battery': battery,
      'latitude': latitude,
      'longitude': longitude,
      'fileCount': fileCount,
      'storageSize': storageSize,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
