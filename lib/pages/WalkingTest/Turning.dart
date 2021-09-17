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


class TurnWalking extends StatefulWidget {
  @override
  _TurnWalkingState createState() => _TurnWalkingState();
}

class _TurnWalkingState extends State<TurnWalking> {
  bool isRecording = false;
  bool hasTurnedAround = false;
  bool isDone = false;
  int stepsTaken = 0;
  int maxSteps = 40;
  double counterOpacity= 0.0;
  List<List<dynamic>>?_sensorDataArray = [["TimeStamp","Acc_x","Acc_y","Acc_z","Gyro_x","Gyro_y","Gyro_z","Magnetic_x","Magnetic_y","Magnetic_z"]];//this array of arrays will be converted into a csv
  List<double>? _userAccelerometerValues;
  List<double>? _gyroscopeValues;
  List<double>? _magnetometerValues;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _steps = '?';

  AudioPlayer? audioPlayer;
  AudioCache? audioCache;
  late String localFilePath;

  static const maxSeconds = 30;
  int seconds = maxSeconds;
  CountdownTimer? _timer = null;

  @override
  void initState() {
    super.initState();
    checkPermissions();
    initSensorSate();
    initPlatformState();
    initAudio();
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    lastMedicineAnswer = "";
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Turn Walking Test"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: SafeArea(
              child: Container(
                width: double.infinity,
                height: screenSize.height,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                        child: Text(
                          "Instructions",
                          style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        )),
                    buildInstructions(screenSize),
                    buildStartStopButton(),
                    buildStepCounter()
                  ],
                ),
              )),
        ));
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
    stepsTaken = 0;
    counterOpacity = 0.0;
    _sensorDataArray = [["TimeStamp","Acc_x","Acc_y","Acc_z","Gyro_x","Gyro_y","Gyro_z","Magnetic_x","Magnetic_y","Magnetic_z"]] ;//this array of arrays will be converted into a csv
    hasTurnedAround = false;
  }
  void updateSensorDataArray(){
    if(isRecording) {
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
    final pathOfTheFileToWrite = directory.path + "/walking_test.csv";
    File file = File(pathOfTheFileToWrite);
    await file.writeAsString(csv);

    //Upload to firebase
    String uid = AuthService().getCurrentUser().uid;
    DataBaseService(uid:uid).uploadFile(file, "Turning Walking Test",".csv");
    resetData();


    print("written to csv!");
    print(csv);
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
      setState(() {
        audioCache!.play("StartWalkingAgain.mp3");
        isRecording = true;
        hasTurnedAround = true;
      });
    });
  }

  /**--- Funcions for Pedometer---**/
  void onStepCount(StepCount event) {

    _steps = event.steps.toString();
    setState(() {
      if (isRecording) {
        updateSensorDataArray();
        if(stepsTaken < maxSteps) {
          if(stepsTaken == 20 && !hasTurnedAround){
            isRecording = false;
            audioCache!.play("TurnAround.mp3");
            startCountDownTimer();

          }
          else {
            stepsTaken += 1;
          }
        }
        else {
          isRecording = false;
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Good Job! Walking data recorded")));
            writeDataToCsv();
            audioCache!.play("RecordingFinished.mp3");
      }


      }

    });
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
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

  void initAudio(){
    audioPlayer = AudioPlayer();
    audioCache = AudioCache(fixedPlayer: audioPlayer);
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

  void onPedestrianStatusChanged(PedestrianStatus event) {
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    print(_status);
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 'Step Count not available';
    });
  }

  /**--- Funcions for building the UI---**/
  Widget buildInstructions(Size screenSize) {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border.all(color: Colors.black, width: 2.0)),
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
                "1.Turn up your phone's volume so you can hear the instructions while you are walking\n\n"+
                "2.Put your smartphone in your pocket and walk straight at least for 20 steps\n\n"+
                "3.When Instructed, turn around and wait for 30 seconds\n\n"+
                 "4. When told start walking again for a tleast another 20 steps",
            style: TextStyle(fontSize: 15.0),
          ),
        ),
      ),
    );
  }

  void OnStartStopButtonPressed() {
    setState(() {
      if (isRecording) {
        audioCache!.play('RecordingCanceled.mp3');
        resetData();



      } else {
        audioCache!.play('RecordingStarted.mp3');
      }

      isRecording = !isRecording;
    });
  }

  Widget buildStartStopButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: WideButton(
        color: isRecording ? Colors.red : Colors.blue,
        buttonText: isRecording ? "Press to Stop" : "Press to Start",
        onPressed: OnStartStopButtonPressed,
      ),
    );
  }

  Widget buildStepCounter() {
    return Opacity(
      opacity: isRecording ? 1.0 : 0.0 ,
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          child: Text("Steps Taken: " + stepsTaken.toString(),
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold))),
    );
  }
}
