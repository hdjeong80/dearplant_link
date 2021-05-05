import 'dart:async';

import 'package:dearplant_link/ble_example_widgets.dart';
import 'package:dearplant_link/constants/app_colors.dart';
import 'package:dearplant_link/controllers/app_data.dart';
import 'package:dearplant_link/controllers/bluetooth_controller.dart';
import 'package:dearplant_link/controllers/sound_controller.dart';
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
          builder: (c, snapshot) {
            return Column(
              children: snapshot.data!
                  .map(
                    (r) => ScanResultTile(
                      result: r,
                      onTap: () async {
                        Get.back();
                        Future.delayed(Duration(seconds: 1))
                            .then((value) async {
                          Get.dialog(
                            AlertDialog(
                              contentPadding:
                                  EdgeInsets.all(Get.size.width / 3),
                              content: AspectRatio(
                                aspectRatio: 1,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.purple),
                                ),
                              ),
                              backgroundColor: Colors.transparent,
                            ),
                            barrierDismissible: true,
                          );
                          gConnectedDevice = r.device;
                          gConnectedDevice?.state
                              .listen((BluetoothDeviceState event) {
                            if (event == BluetoothDeviceState.disconnected) {
                              Get.find<AppData>().isConnected = false;
                              Get.find<AppData>().isMusicPlaying = false;
                              Get.find<AppData>().isMuted = false;
                              SoundController.stop();
                            }
                          });

                          await r.device.connect();
                          await r.device.discoverServices();
                          r.device.services
                              .listen((List<BluetoothService> event) {
                            if (Get.find<AppData>().isConnected) {
                              return;
                            }
                            event.forEach((BluetoothService element) async {
                              print(
                                  '${element.uuid.toString().toUpperCase().substring(4, 8)}');
                              if ((element.uuid
                                      .toString()
                                      .toUpperCase()
                                      .substring(4, 8)) ==
                                  'FFE0') {
                                Get.find<AppData>().isConnected = true;
                                BluetoothCharacteristic c =
                                    element.characteristics.first;
                                await c.setNotifyValue(true);
                                await c.read();
                                gConnectedCharacteristic = c;
                                Timer.periodic(
                                    Duration(milliseconds: 50), _timerCallback);
                                c.value.listen(_bluetoothReceiveCallback);
                              }
                            });
                          });
                          Get.back();
                        });
                      },
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
      contentPadding: EdgeInsets.symmetric(vertical: 50),
    );
  }
}

void _bluetoothReceiveCallback(value) {
  AppData appData = Get.find<AppData>();
  value.forEach((element) {
    if (appData.isMuted) {
      return;
    }

    double value = element.toDouble();
    if (value > 20) {
      // 터치 데이터가 0~20으로 오기 때문에, 20 이상은 예외처리 (초기에 수분값으로 옴)
      return;
    }

    double touchValue =
        (value / 20).clamp(0, 1); // 0 ~ 20 -> Normalization 0 ~ 1
    gDelayedVolume = touchValue;
    if (touchValue > 0.1) {
      if (appData.isMusicPlaying == false) {
        appData.isMusicPlaying = true;
        SoundController.play();
      }
    }
    print('$touchValue, ${appData.isMusicPlaying}');
  });
  return;
}

void _timerCallback(timer) async {
  if (gConnectedDevice == null) {
  } else {
    SoundController.setVolume(gDelayedVolume);
    // }
  }
}
