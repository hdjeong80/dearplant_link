import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dearplant_link/constants/music_theme.dart';
import 'package:dearplant_link/models/music_theme_model.dart';

var _player = AssetsAudioPlayer.newPlayer();

class SoundController {
  static String soundPath = defaultMusicThemes.soundPath;

  static play() {
    _player.open(
      Audio(soundPath),
      autoStart: true,
      showNotification: false,
      loopMode: LoopMode.single,
    );
  }

  static setVolume(double volume) {
    _player.setVolume(volume);
  }

  static changeMusic(MusicThemeModel m) {
    soundPath = m.soundPath;
    _player.stop();
    _player.open(
      Audio(m.soundPath),
      autoStart: true,
      showNotification: true,
    );
  }

  static stop() {
    _player.stop();
  }
}
