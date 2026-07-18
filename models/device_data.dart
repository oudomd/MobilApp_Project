// hold data collected from real device APIs before it gets packaged into a ScanResult. Not stored in Firebase directly.
class DeviceData {
  final String model;
  final String androidVersion;
  final int battery;
  final double? latitude;
  final double? longitude;
  final int fileCount;
  final String storageSize;

  DeviceData({
    required this.model,
    required this.androidVersion,
    required this.battery,
    this.latitude,
    this.longitude,
    required this.fileCount,
    required this.storageSize,
  });
}
