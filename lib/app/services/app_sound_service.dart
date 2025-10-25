import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:get/get.dart';
import 'package:audio_session/audio_session.dart';

enum SoundFile { beep440, beep880 }

class AppSoundService extends GetxService {
  final Map<SoundFile, AudioSource> _soundSourceMap = {};
  late final AudioSession session;
  late final SoLoud _soloud;
  SoundHandle? handle;

  bool _initiated = false;

  @override
  void onInit() async {
    super.onInit();
    await _initAudioSession();
    await _initSoLoud();

    _initiated = true;
  }

  @override
  void onClose() {
    super.onClose();
    _soloud.disposeAllSources();
  }

  Future<void> beep(SoundFile sound, {Duration? delay}) async {
    if (!_initiated) return;
    if (delay != null) await Future.delayed(delay);

    AudioSource? source = _soundSourceMap[sound];
    if (source == null) return;

    handle = await _soloud.play(source);
  }

  Future<void> _initAudioSession() async {
    session = await AudioSession.instance;
    await session.configure(
      const AudioSessionConfiguration(
        androidWillPauseWhenDucked: true,
        androidAudioAttributes: AndroidAudioAttributes(
          usage: AndroidAudioUsage.assistanceSonification,
          contentType: AndroidAudioContentType.sonification,
        ),
        androidAudioFocusGainType:
            AndroidAudioFocusGainType.gainTransientMayDuck,
        avAudioSessionCategory: AVAudioSessionCategory.playback,
        avAudioSessionCategoryOptions:
            AVAudioSessionCategoryOptions.mixWithOthers,
      ),
    );
    _handleInterruptions(session);
    await session.setActive(true);
  }

  void _handleInterruptions(AudioSession audioSession) {
    audioSession.becomingNoisyEventStream.listen((_) {
      if (handle == null) return;
      _soloud.setPause(handle!, true);
    });

    audioSession.interruptionEventStream.listen((event) {
      if (event.begin) {
        switch (event.type) {
          case AudioInterruptionType.duck:
            _soloud.fadeGlobalVolume(0.1, const Duration(milliseconds: 300));
            break;
          case AudioInterruptionType.pause:
          case AudioInterruptionType.unknown:
            if (handle == null) return;
            _soloud.setPause(handle!, true);
            break;
        }
      } else {
        switch (event.type) {
          case AudioInterruptionType.duck:
            _soloud.fadeGlobalVolume(1, const Duration(milliseconds: 300));
            break;
          case AudioInterruptionType.pause:
            if (handle == null) return;
            _soloud.setPause(handle!, false);
            break;
          case AudioInterruptionType.unknown:
            break;
        }
      }
    });
  }

  Future<void> _initSoLoud() async {
    _soloud = SoLoud.instance;

    await _soloud.init();

    _soundSourceMap[SoundFile.beep440] =
        await _soloud.loadAsset('assets/sounds/sine_wave_440Hz.wav');
    _soundSourceMap[SoundFile.beep880] =
        await _soloud.loadAsset('assets/sounds/sine_wave_880Hz_0.6s.wav');
  }
}
