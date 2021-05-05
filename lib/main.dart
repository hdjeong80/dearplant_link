import 'package:dearplant_link/screens/splash.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';

import 'screens/bluetooth_off_screen.dart';

String gSerialMessages = '';
int gIndex = 0;
double gValue = 0;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(FlutterBlueApp());
}

class FlutterBlueApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.white,
      home: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if ((state == BluetoothState.on) || (kDebugMode)) {
              return SplashScreen();
              // return FindDevicesScreen(); // example code
            }
            return BluetoothOffScreen();
          }),
    );
  }
}
