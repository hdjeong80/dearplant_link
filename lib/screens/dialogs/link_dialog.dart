import 'dart:async';

import 'package:dearplant_link/controllers/bluetooth_controller.dart';
import 'package:dearplant_link/controllers/sound_controller.dart';
import 'package:dearplant_link/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';

class LinkDialog extends StatefulWidget {
  @override
  _LinkDialogState createState() => _LinkDialogState();
}

class _LinkDialogState extends State<LinkDialog> {
  @override
  Widget build(BuildContext context) {
    FlutterBlue.instance.stopScan();
    FlutterBlue.instance.startScan(timeout: Duration(seconds: 4));
    return SimpleDialog(
      title: Row(
        children: [
          Text('B612 연결'),
          Spacer(),
          IconButton(
            icon: Icon(
              Icons.cancel_outlined,
              color: Colors.red,
            ),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
      children: [
        StreamBuilder<List<ScanResult>>(
          stream: FlutterBlue.instance.scanResults,
          initialData: [],
          builder: (c, snapshot) => Column(
            children: snapshot.data!
                .map(
                  (r) => ScanResultTile(
                    result: r,
                    onTap: () async {
                      Get.back();
                      Future.delayed(Duration(seconds: 2)).then((value) async {
                        gConnectedDevice = r.device;
                        await r.device.connect();
                        await r.device.discoverServices();
                        List<BluetoothService> s =
                            await r.device.services.first;
                        BluetoothCharacteristic c =
                            s.first.characteristics.first;
                        await c.setNotifyValue(true);
                        await c.read();
                        c.value.listen((value) {
                          value.forEach((element) {
                            double value = element.toDouble();
                            double volumeValue = (value / 100).clamp(0, 1);
                            print(volumeValue);
                            SoundController.setVolume(element.toDouble());
                          });
                          return;
                        });
                      });

                      // Navigator.of(context)
                      //     .push(MaterialPageRoute(builder: (context) {
                      //   r.device.connect();
                      //   return DeviceScreen(device: r.device);
                      // }));
                    },
                  ),
                )
                .toList(),
          ),
        ),
      ],
      contentPadding: EdgeInsets.symmetric(vertical: 50),
    );
  }
}
