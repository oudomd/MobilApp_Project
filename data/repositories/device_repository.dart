import '../../models/device_data.dart';

class DeviceRepository {
  static final global = DeviceRepository();



  // collect device info like version, model, location...
  Future<DeviceData> collectInfo() async {

  // Todo : get permission from user to extract info 
  // using packages

  return DeviceData(model: model, androidVersion: androidVersion, battery: battery, fileCount: fileCount, storageSize: storageSize)
  }
}
