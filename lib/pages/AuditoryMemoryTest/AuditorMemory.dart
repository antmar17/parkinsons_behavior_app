import 'dart:async';
import 'dart:io';
import 'package:quiver/async.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record_mp3/record_mp3.dart';

// ignore: must_be_immutable
class AuditoryMemory extends StatefulWidget {
  String recordActivityPath;
  String mp3Path;

  AuditoryMemory( {required this.recordActivityPath,required this.mp3Path});

  @override
  _AuditoryMemoryState createState() => _AuditoryMemoryState();
}

class _AuditoryMemoryState extends State<AuditoryMemory> {

  static const maxSeconds = 5;
  int seconds = maxSeconds;
  CountdownTimer? _timer = null;
  bool recordingFinished = false;
  bool recordingPlaying = false;


  late AudioCache audioCache;
  late AudioPlayer advancedPlayer;


  Duration _duration = new Duration();
  Duration _position = new Duration();
  late int x = 0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkPermission();
    initAudio();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Auditory Memory Test",
          style: TextStyle(fontSize: 15.0),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: screenSize.height,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Press the play button below to play the audio. Memorize the words you hear. After 5 seconds recall the words and speak them into the microphone.",
                style: TextStyle(fontSize: 20.0),
              ),
              SizedBox(height: screenSize.height * 0.05),
              recordingFinished ?buildTime():buildAudioPlayButton(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${_position.inMinutes}:${_position.inSeconds.remainder(60)}"),
                  buildSlider(),
                  Text("${_duration.inMinutes}:${_duration.inSeconds.remainder(60)}"),

                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  /**--- Function for Recording Audio---**/
  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
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
    return sdPath + "/test.mp3";
  }
  void initAudio(){

    advancedPlayer = AudioPlayer();
    audioCache = AudioCache(fixedPlayer: advancedPlayer);
    advancedPlayer.onDurationChanged.listen((d) => setState(() => _duration = d));
    advancedPlayer.onAudioPositionChanged.listen((p) => setState(() => _position = p));
    advancedPlayer.onPlayerCompletion.listen((event) {
      setState(() {
        _position = Duration(seconds: 0);
        recordingFinished = true;
        startCountDownTimer();
      });
    });
    audioCache.load(widget.mp3Path);
    
  }





    void onAudioPlayButtonPressed() async{
      //x = await _getDuration();
    setState(() {
      if(!recordingFinished && !recordingPlaying){
        audioCache.play(widget.mp3Path);
        recordingPlaying = true;
      }


    });
  }

  Widget buildAudioPlayButton() {
    return Opacity(
        opacity: recordingFinished ? 0.0 : 1.0,
        child: ElevatedButton(
          onPressed: onAudioPlayButtonPressed,
          child: Text("Play Audio"),
          style: ButtonStyle(
              padding:
                  MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(25)),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor: MaterialStateProperty.all<Color>(
                  recordingPlaying ? Colors.red : Colors.blue),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.blue)))),
        ));
  }
  Widget buildSlider(){
    return Slider.adaptive(
      activeColor: Colors.blue,
        inactiveColor: Colors.grey,
        value: _position.inSeconds.toDouble(),
        max:_duration.inSeconds.toDouble(),
        onChanged: null);
  }

  Widget buildTime(){
    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        fit: StackFit.expand,
        children:[
          CircularProgressIndicator(
            value: 1 - seconds/maxSeconds,
            valueColor: AlwaysStoppedAnimation(Colors.grey),
            strokeWidth: 12,
            backgroundColor: Colors.greenAccent,
          ),
          Center(
            child: Text(
            '$seconds',
            style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 50
        ),),
          ),
        ]
      ),
    );
  }


  void startCountDownTimer() {
    _timer = new CountdownTimer(
      new Duration(seconds: maxSeconds),
      new Duration(seconds: 1),
    );

    // ignore: cancel_subscriptions
    var sub = _timer!.listen(null);
    sub.onData((duration) {
      setState(() {
        seconds = maxSeconds - duration.elapsed.inSeconds;
      });
    });
    sub.onDone(() {
      if(seconds== 0) {
        Navigator.pushReplacementNamed(context, widget.recordActivityPath);

      }
    });
  }


}
