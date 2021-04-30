import 'package:dearplant_link/constants/app_colors.dart';
import 'package:dearplant_link/constants/music_theme.dart';
import 'package:dearplant_link/controllers/app_data.dart';
import 'package:dearplant_link/controllers/sound_controller.dart';
import 'package:dearplant_link/screens/dialogs/link_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final appData = Get.put<AppData>(AppData(), permanent: true);

  @override
  Widget build(BuildContext context) {
    SoundController.setVolume(0);
    SoundController.play();

    @override
    dispose() {
      super.dispose();
      SoundController.stop();
    }

    return GetBuilder<AppData>(
      builder: (appData) {
        return Container(
          color: AppColors.purple,
          child: SafeArea(
            bottom: false,
            child: Scaffold(
              backgroundColor: AppColors.purple,
              appBar: AppBar(
                toolbarHeight: MediaQuery.of(context).size.height / 12,
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: SizedBox(
                  height: MediaQuery.of(context).size.height / 12,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Image.asset(
                      'assets/images/dearplant_white.webp',
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ),
              body: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(appData.selectedMusic.imagePath),
                    // colorFilter: ColorFilter.mode(
                    //     Colors.black.withOpacity(0.5), BlendMode.dstATop),
                  ),
                ),
                padding: EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      '식물 친구를 통해 자연을 느껴보세요.',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '식물 친구와의 인터랙션에 따라 다양한 자연의 소리가 재생됩니다.',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    OutlinedButton(
                      onPressed: () {
                        // FlutterBlue.instance.startScan(timeout: Duration(seconds: 4));
                        Get.dialog(
                          LinkDialog(),
                          barrierDismissible: false,
                        );
                      },
                      child: Text(
                        'B612 연결',
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.only(
                            top: 16, bottom: 16, left: 40, right: 40),
                        side: BorderSide(
                          width: 2,
                          color: Colors.white,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 3,
                      child: Scrollbar(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: gMusicThemeList.length,
                          itemBuilder: (context, index) {
                            String image = gMusicThemeList[index].imagePath;
                            return GestureDetector(
                              child: Image.asset(image),
                              onTap: () {
                                appData.selectedMusic = gMusicThemeList[index];
                                SoundController.changeMusic(
                                    gMusicThemeList[index]);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    Text(
                      'Copyright 2021 Dearplants Inc. All rights reserved.',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
