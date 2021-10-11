import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:parkinsons_app/services/Util.dart';
import 'package:parkinsons_app/services/auth.dart';
import 'package:parkinsons_app/services/database.dart';
import 'package:parkinsons_app/widgets/WideButton.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:sensors_plus/sensors_plus.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:motion_sensors/motion_sensors.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:csv/csv.dart';
import 'package:quiver/async.dart';

class Turning extends StatefulWidget {
  String medcineAnswer;
  Turning({required this.medcineAnswer});
  @override
  _TurningState createState() => _TurningState();
}

class _TurningState extends State<Turning> {
  int maxSeconds = 3;
  int seconds = 3;
  CountdownTimer? _timer = null;
  bool testStarted = false;



  List<List<dynamic>>?_sensorDataArray = [["TimeStamp","Acc_x","Acc_y","Acc_z","Gyro_x","Gyro_y","Gyro_z","Magnetic_x","Magnetic_y","Magnetic_z"]];//this array of arrays will be converted into a csv
  List<double>? _userAccelerometerValues;
  List<double>? _gyroscopeValues;
  List<double>? _magnetometerValues;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  List<String>instructionsMP3 = ['turnaround.mp3','standstill_30.mp3'];
  List<int> waitTimes= [5,30];
  int masterIndex = 0;



  AudioPlayer? audioPlayer;
  AudioCache? audioCache;




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
      if(masterIndex < waitTimes.length){

        audioCache!.play(instructionsMP3[masterIndex]);
        maxSeconds = waitTimes[masterIndex];
        masterIndex++;
        startCountDownTimer();
      }
      else {
        audioCache!.play('recording_finished.mp3');
        writeDataToCsv();
        seconds = maxSeconds;
        testStarted = false;
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Turning Test completed!")));
        masterIndex = 0;
      }
    });
  }

  void initAudio(){
    audioPlayer = AudioPlayer();
    audioCache = AudioCache(fixedPlayer: audioPlayer);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    checkPermissions();
    initSensorSate();
    initAudio();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: buildAppBar(),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: screenSize.height,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Column(
            children: [
              buildInstructions(screenSize),
              SizedBox(height: screenSize.height * 0.025,),
              buildStartButton(),
              SizedBox(height: screenSize.height * 0.025,),
              if (testStarted) buildTime() ,
            ],
          ),
        ),
      ),
    );
  }


  Future<bool> checkPermissions() async {
    final activityStatus = await Permission.activityRecognition.request();
    final storageStatus = await Permission.storage.request();
    if (activityStatus != PermissionStatus.granted && storageStatus != PermissionStatus.granted) {
      throw Exception("Permission denied");
    }
    return true;
  }


  void resetData(){
    //set all member variables to initial state
    _sensorDataArray = [["TimeStamp","Acc_x","Acc_y","Acc_z","Gyro_x","Gyro_y","Gyro_z","Magnetic_x","Magnetic_y","Magnetic_z"]] ;//this array of arrays will be converted into a csv
  }
  void updateSensorDataArray(){
    if(testStarted) {
      List<dynamic> row = [
        createTimeStamp(),
        _userAccelerometerValues![0],
        _userAccelerometerValues![1],
        _userAccelerometerValues![2],
        _gyroscopeValues![0],
        _gyroscopeValues![1],
        _gyroscopeValues![2],
        _magnetometerValues![0],
        _magnetometerValues![1],
        _magnetometerValues![2]
      ];
      _sensorDataArray!.add(row);
    }
  }


  void writeDataToCsv() async {
    String csv = const ListToCsvConverter().convert(_sensorDataArray);

    /// Write to a file
    final directory = await getApplicationDocumentsDirectory();
    final pathOfTheFileToWrite = directory.path + "/tremor_test.csv";
    File file = File(pathOfTheFileToWrite);
    await file.writeAsString(csv);

    //Upload to firebase
    String uid = AuthService().getCurrentUser().uid;
    DataBaseService db = DataBaseService(uid: uid);
    db.uploadFile(file, "Turning Test",".csv");
    db.updateGeneric('Turning Test', widget.medcineAnswer);
    resetData();

  }

  void initSensorSate() {
    _streamSubscriptions.add(
      motionSensors.gyroscope.listen(onGyroScopeEvent),
    );
    _streamSubscriptions.add(
      motionSensors.userAccelerometer.listen(onAccelerometerEvent),
    );
    _streamSubscriptions.add(
      motionSensors.magnetometer.listen(onMagnetometerEvent),
    );
  }

  /**--- Funcions for Sensors---**/
  void onGyroScopeEvent(GyroscopeEvent event) {
    setState(() {
      _gyroscopeValues = <double>[event.x, event.y, event.z];
      updateSensorDataArray();
    });
  }

  void onAccelerometerEvent(UserAccelerometerEvent event) {
    setState(() {
      _userAccelerometerValues = <double>[event.x, event.y, event.z];
      updateSensorDataArray();
      print(_userAccelerometerValues);
    });
  }

  void onMagnetometerEvent(MagnetometerEvent event) {
    setState(() {
      _magnetometerValues = <double>[event.x, event.y, event.z];

      updateSensorDataArray();
    });
  }

  /**--- Funcions for building UI---**/

  PreferredSizeWidget buildAppBar() {
    return AppBar(
      title: Text("Turning Test"),
      centerTitle: true,
    );
  }
  Widget buildInstructions(Size screenSize) {
    return Column(
      children: [
        Container(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: Text(
              "Instructions",
              style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline),
            )),
        Container(
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(color: Colors.black, width: 2.0)),
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "1.Turn up your phone's volume so you can hear the instructions while you are walking\n\n"+
                "2.Put your smartphone in your front pocket if you do not have pockets you can place the phone in the waist band of your pants\n\n"+
                "3.Please stand up if you are sitting, please turn around and stand still for 30 seconds",
                style: TextStyle(fontSize: 15.0),
              ),
            ),
          ),
        ),
      ],
    );
  }



  Widget buildTime() {
    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(fit: StackFit.expand, children: [
        CircularProgressIndicator(
          value: 1 - seconds / maxSeconds,
          valueColor: AlwaysStoppedAnimation(Colors.grey),
          strokeWidth: 12,
          backgroundColor: Colors.greenAccent,
        ),
        Center(
          child: Text(
            '$seconds',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 50),
          ),
        ),
      ]),
    );
  }

  Widget buildStartButton() {
    return WideButton(color: testStarted?Colors.red:Colors.blue, buttonText: testStarted?"Stop Test":"Start test", onPressed: (){
      if(!testStarted){
        testStarted = true;


          startCountDownTimer();

      }
    });
    //return ElevatedButton(
    //  child: Text("Start Test"),
    //  onPressed: startCountDownTimer,
    //);
  }
}
