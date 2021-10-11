import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:parkinsons_app/services/SoundRecorder.dart';
import 'package:parkinsons_app/services/auth.dart';
import 'package:parkinsons_app/services/database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:audioplayers/audioplayers.dart';



// ignore: must_be_immutable
class RecordActivity extends StatefulWidget {
  String medicineAnswer;
  String activityTitle;
  String instructionText;
  String subInstructionsText;

  RecordActivity(
      {required this.medicineAnswer,required this.activityTitle,required this.instructionText, required this.subInstructionsText});

  @override
  _RecordActivityState createState() => _RecordActivityState();
}

class _RecordActivityState extends State<RecordActivity> {
  final recorder = SoundRecorder();
  bool isRecording = false;
  bool isComplete = false;
  late String recordFilePath;

  @override
  void initState() {
    // TODO: implement initState
    //recorder.init();
    super.initState();
    checkPermission();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //recorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text("Follow the instructions below!"),
          centerTitle: true,
        ),
        body: SafeArea(
            child: Container(
          width: double.infinity,
          height: screenSize.height,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            Text(widget.instructionText, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
            Container(
                padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.025),
                child: Text(widget.subInstructionsText, style: TextStyle(fontSize: 20))),
            ( isComplete && !isRecording) ? buildCompletionButtons() : buildRecordButton(),
            SizedBox(height: screenSize.height * 0.025),
            Opacity(
              opacity: isRecording ? 1.0 : 0.0,
              child: Text("RECORDING",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                      color: Colors.red)),
            ),
          ]),
        )));
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

  int i = 0;

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path + "/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return sdPath + "/test.mp3";
  }
  void startRecord() async {
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      recordFilePath = await getFilePath();
      RecordMp3.instance.start(recordFilePath, (type) {
        setState(() {});
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Permission for microphone not granted")));
    }
    setState(() {});
  }

  void stopRecord() {
    bool s = RecordMp3.instance.stop();
    if (s) {
      setState(() {});
    }
  }




    /**--- Functions for building UI---**/
  void onSubmitPressed() async {
    if (recordFilePath != null && File(recordFilePath).existsSync()) {
      //AudioPlayer audioPlayer = AudioPlayer();
      //audioPlayer.play(recordFilePath, isLocal: true);
      String uid = AuthService().getCurrentUser().uid.toString();
      File file = File(recordFilePath);
      DataBaseService db = DataBaseService(uid: uid);

      db.uploadFile(file, widget.activityTitle, ".mp3");
      db.updateGeneric(widget.activityTitle, widget.medicineAnswer);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Recording Submitted!")));
      Navigator.of(context).pop();

    }
  }

  /**Builds Submit Button Widget**/
  Widget buildSubmitButton() {
    return ElevatedButton(
      onPressed: () => onSubmitPressed(),
      child: Text("Submit Recording"),
      style: ButtonStyle(
          padding:
              MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(25)),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          backgroundColor:
              MaterialStateProperty.all<Color>(Colors.blueAccent),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.blueAccent)))),
    );
  }

  void onRetryPressed() {
    setState(() {
      isRecording = false;
      isComplete = false;
    });
  }

  /**Builds Retry Button Widget**/
  Widget buildRetyButton() {
    return ElevatedButton(
      onPressed: () => onRetryPressed(),
      child: Text("Retry Recording"),
      style: ButtonStyle(
          padding:
              MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(30)),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          backgroundColor:
              MaterialStateProperty.all<Color>(Colors.blueAccent),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.blueAccent)))),
    );
  }

  Widget buildCompletionButtons(){
    return Column(
      children: [
        buildRetyButton(),
        SizedBox(height: 20.0,),
        buildSubmitButton()
      ],
    );
  }

  void onRecordPressed() async {
    print("IS RECORDING" + isRecording.toString());
    setState(() {
      if (isRecording) {
        stopRecord();
        isComplete = true;
        isRecording = false;
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Your recording is complete!")));
      }
      else{
        isRecording = true;
        isComplete = false;
        startRecord();
      }
    });
  }

  /** builds record Button Widget**/
  Widget buildRecordButton() {
    return ElevatedButton(
      onPressed: () async => onRecordPressed(),
      child: Text(isRecording ? "Stop Recording" : "Start Recording"),
      style: ButtonStyle(
          padding:
              MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(25)),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          backgroundColor: MaterialStateProperty.all<Color>(
              isRecording ? Colors.red : Colors.blue),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.blue)))),
    );
  }
}
