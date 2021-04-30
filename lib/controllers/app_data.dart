import 'package:dearplant_link/constants/music_theme.dart';
import 'package:dearplant_link/controllers/sound_controller.dart';
import 'package:dearplant_link/models/music_theme_model.dart';
import 'package:get/get.dart';

class AppData extends GetxController {
  MusicThemeModel _selectedMusic = defaultMusicThemes;

  MusicThemeModel get selectedMusic {
    return _selectedMusic;
  }

  set selectedMusic(MusicThemeModel newMusic) {
    _selectedMusic = newMusic;
    SoundController.soundPath = newMusic.soundPath;
    update();
  }
}
