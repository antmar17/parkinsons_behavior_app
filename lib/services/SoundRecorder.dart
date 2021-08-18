import 'dart:io';
import 'dart:async';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:record_mp3/record_mp3.dart';
import 'package:path_provider/path_provider.dart';

final pathToSaveAudio = 'audio_example.mp3';
const theSource = AudioSource.microphone;

//TODO: try using record_mp3
/***Using record_mp3 ***/
class SoundRecorder {

  Future<bool> checkPermissions() async {
    final micStatus = await Permission.microphone.request();
    final storageStatus = await Permission.storage.request();
    if (micStatus != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone Permission denied');
    }
    if (storageStatus != PermissionStatus.granted) {
      throw Exception('Storage Permission denied');
    }
    return true;
  }

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path + "/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return sdPath + "/" + pathToSaveAudio;
  }
}



/***Using  flutter_sound (Not working so far)***/
//class SoundRecorder {
//  FlutterSoundRecorder? _audioRecorder;
//  bool _isRecorderInitialized = false;
//
//
//  bool get isRecording => _audioRecorder!.isRecording;
//
//  Future init() async {
//    _audioRecorder = FlutterSoundRecorder();
//
//    //ask user permission to use microphone
//    final status = await Permission.microphone.request();
//    if (status != PermissionStatus.granted) {
//      throw RecordingPermissionException('Microphone Permission denied');
//    }
//    await _audioRecorder!.openAudioSession();
//    _isRecorderInitialized = true;
//  }
//
//  void dispose() {
//    if (!_isRecorderInitialized) {return;}
//    _audioRecorder!.closeAudioSession();
//    _audioRecorder = null;
//    _isRecorderInitialized = false;
//  }
//
//  Future _record() async {
//    if (!_isRecorderInitialized) {return;}
//    await _audioRecorder!.startRecorder(toFile: pathToSaveAudio,codec: Codec.aacADTS);
//  }
//
//  Future _stop() async {
//    if (!_isRecorderInitialized) {return;}
//    await _audioRecorder!.stopRecorder();
//  }
//
//  Future toggleRecording() async {
//    if (_audioRecorder!.isStopped) {
//      await _record();
//    } else {
//      await _stop();
//    }
//  }
//}
