import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'dart:io';

import 'package:youyu/controllers/base/base_controller.dart';

///播放监听
mixin VoiceAudioListener {
  onPlayChangeState(
      PlayerState state, String? url, String? audioUrlId, File? file);

  onPlayChangeTime(int p, String? url, String? audioUrlId, File? file);
}

class VoiceService extends AppBaseController {
  static VoiceService? _instance;

  factory VoiceService() => _instance ??= VoiceService._();

  VoiceService._();

  ///播放相关
  final AudioPlayer _audioPlayer = AudioPlayer(playerId: '1');

  AudioPlayer get audioPlayer => _audioPlayer;

  PlayerState _state = PlayerState.stopped;
  StreamSubscription? _playerStateChangeSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _positionSubscription;
  File? _audioFile;
  String? _audioUrl;
  String? _audioUrlId;
  final List<VoiceAudioListener> _audioObservers = [];

  @override
  void onInit() async {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 300), () {
      ///完成监听
      _playerCompleteSubscription =
          audioPlayer.onPlayerComplete.listen((event) {
        _state = PlayerState.stopped;
        for (VoiceAudioListener listener in _audioObservers) {
          listener.onPlayChangeState(
              _state, _audioUrl, _audioUrlId, _audioFile);
        }
      });

      ///进度监听
      _positionSubscription = audioPlayer.onPositionChanged.listen((p) {
        for (VoiceAudioListener listener in _audioObservers) {
          listener.onPlayChangeTime(
              p.inSeconds, _audioUrl, _audioUrlId, _audioFile);
        }
      });

      ///状态监听
      _playerStateChangeSubscription =
          audioPlayer.onPlayerStateChanged.listen((state) {
        _state = state;
        for (VoiceAudioListener listener in _audioObservers) {
          listener.onPlayChangeState(
              _state, _audioUrl, _audioUrlId, _audioFile);
        }
      });
    });
  }

  //监听
  addAudioObserver(VoiceAudioListener listener) {
    _audioObservers.add(listener);
  }

  removeAudioObserver(VoiceAudioListener listener) {
    _audioObservers.remove(listener);
  }

  //播放文件
  playAudioFile(File audioFile) async {
    if (_audioFile != null) {
      if (_audioFile!.path != audioFile.path) {
        await audioPlayer.stop();
        _state = PlayerState.stopped;
        for (VoiceAudioListener listener in _audioObservers) {
          listener.onPlayChangeState(
              _state, _audioUrl, _audioUrlId, _audioFile);
        }
      }
    }
    _audioFile = audioFile;
    if (_state == PlayerState.playing) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.play(DeviceFileSource(audioFile.path), volume: 1);
      _state = PlayerState.playing;
      for (VoiceAudioListener listener in _audioObservers) {
        listener.onPlayChangeState(_state, _audioUrl, _audioUrlId, _audioFile);
      }
    }
  }

  //播放url
  playAudioUrl(String audioUrlId, String audioUrl) async {
    if (_audioUrl != null && _audioUrlId != null) {
      if ('${_audioUrl}_$_audioUrlId' != '${audioUrl}_$audioUrlId') {
        await audioPlayer.stop();
        _state = PlayerState.stopped;
        for (VoiceAudioListener listener in _audioObservers) {
          listener.onPlayChangeState(
              _state, _audioUrl, _audioUrlId, _audioFile);
        }
      }
    }
    _audioUrl = audioUrl;
    _audioUrlId = audioUrlId;
    if (_state == PlayerState.playing) {
      await audioPlayer.pause();
    } else {
      audioPlayer.play(UrlSource(audioUrl), volume: 1);
      _state = PlayerState.playing;
      for (VoiceAudioListener listener in _audioObservers) {
        listener.onPlayChangeState(_state, _audioUrl, _audioUrlId, _audioFile);
      }
    }
  }

  stopAudio() async {
    if (_audioUrl != null || _audioFile != null || _audioUrlId != null) {
      await audioPlayer.stop();
      _state = PlayerState.stopped;
      for (VoiceAudioListener listener in _audioObservers) {
        listener.onPlayChangeState(_state, _audioUrl, _audioUrlId, _audioFile);
      }
      _audioUrl = null;
      _audioUrlId = null;
    }
  }

  @override
  void onClose() {
    super.onClose();
    _playerCompleteSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerStateChangeSubscription?.cancel();
    audioPlayer.stop();
  }
}
