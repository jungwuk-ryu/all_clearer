import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:soundpool/soundpool.dart';

enum SoundFile { beep440, beep880 }

class AppSoundService extends GetxService {
  final Map<SoundFile, int> _soundIdMap = {};
  int _streamId = -1;
  late Soundpool _pool;

  @override
  void onInit() {
    super.onInit();
    _pool = Soundpool.fromOptions();
    rootBundle.load("assets/sounds/sine_wave_440Hz.wav").then((value) async {
      _soundIdMap[SoundFile.beep440] = await _pool.load(value);
    });

    rootBundle
        .load("assets/sounds/sine_wave_880Hz_0.6s.wav")
        .then((value) async {
      _soundIdMap[SoundFile.beep880] = await _pool.load(value);
    });
  }

  @override
  void onClose() {
    super.onClose();
    _pool.release();
  }

  Future<void> beep(SoundFile sound, {Duration? delay}) async {
    if (delay != null) await Future.delayed(delay);
    int? soundId = _getSoundId(sound);
    if (soundId == null) return;

    if (_streamId > 0) {
      try {
        await _pool.stop(_streamId);
        _streamId = -1;
      } catch (_) {}
    }
    _streamId = await _pool.play(soundId);
  }

  int? _getSoundId(SoundFile sound) {
    return _soundIdMap[sound];
  }
}
