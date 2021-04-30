import 'package:dearplant_link/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: '플리터 터치',
      home: SplashScreen(),
      // home: StreamBuilder<BluetoothState>(
      //     stream: FlutterBlue.instance.state,
      //     initialData: BluetoothState.unknown,
      //     builder: (c, snapshot) {
      //       final state = snapshot.data;
      //       if (state == BluetoothState.on) {
      //         return FindDevicesScreen();
      //       }
      //       return BluetoothOffScreen(state: state);
      //     }),
    );
  }
}
