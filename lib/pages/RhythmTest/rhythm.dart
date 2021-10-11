import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:parkinsons_app/services/Util.dart';
import 'package:parkinsons_app/services/auth.dart';
import 'package:parkinsons_app/services/database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quiver/async.dart';
import 'package:csv/csv.dart';
import 'dart:io';

class Rhythm extends StatefulWidget {

  String medicineAnswer;
  Rhythm({required this.medicineAnswer});

  @override
  _RhythmState createState() => _RhythmState();
}

class _RhythmState extends State<Rhythm> {
  late Size screenSize;
  GlobalKey leftKey = GlobalKey();
  GlobalKey rightKey = GlobalKey();

  Offset? leftButtonPosition;
  Offset? rightButtonPosition;

  AuthService _authService = AuthService();
  int _amountPressed = 0;
  double _totalDistance = 0.0;

  bool _leftActivated = false;
  bool _rightActivated = false;

  //prevents multiple countdowns
  bool _gamesCommenced = false;
  bool _countdownCommenced = false;

  //for initial count down
  int _readyTimerStart = 5;
  int _readyTimerCurrent = 5;

  // to display time left
  int _countDownStart = 30;
  int _countDownCurrent = 30;

  //controls visibility of timers
  double _readyTimerOpacity = 0.0;
  double _countDownOpacity = 0.0;


  List<List<dynamic>>?_DataArray = [["TimeStamp","TappedButtonType", "TappedCoordinate", "CoordinateOfLeftButton","CoordinateOfRightButton","PixelsFromTheCenter"]];//this array of arrays will be converted into a csv
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkPermissions();
  }



  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return new Scaffold(
      appBar: AppBar(
        title: Text(
          "Rhythm game!",
          style: TextStyle(fontSize: 15.0),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Center(
              child: Container(
                  padding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
                  child: Text("Press start to start the game",
                      style: TextStyle(fontSize: 15.0)))),
          Center(
              child: Container(
                  child: Text("Tap the buttons when they turn red!",
                      style: TextStyle(fontSize: 15.0)))),
          Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
              child: Opacity(
                  opacity: _countDownOpacity,
                  child:
                  Text("Time Left", style: TextStyle(fontSize: 20.0)))),
          Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
              child: Opacity(
                  opacity: _countDownOpacity,
                  child: Text("$_countDownCurrent",
                      style: TextStyle(fontSize: 20.0)))),
          Divider(
            height: 90.0,
            color: Colors.grey,
          ),
          Opacity(
              opacity: _readyTimerOpacity,
              child: Text(
                "Get Ready! " + " $_readyTimerCurrent",
                style: TextStyle(fontSize: 20.0),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[buildLeftButton(), buildRightButton()],
          ),
          Divider(
            height: 90.0,
            color: Colors.grey,
          ),
          Center(
              child: Container(
                  padding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
                  child: ElevatedButton(
                      onPressed: () {
                        if (!(_countdownCommenced) && !(_gamesCommenced)) {
                          startReadyTimer();
                        }
                      },
                      child: Text("Start Test")))),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Container(
                padding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Text("Score", style: TextStyle(fontSize: 15.0))),
            Container(
                padding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Text("Total Pixels from center",
                    style: TextStyle(fontSize: 15.0))),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Container(
                padding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Text("$_amountPressed",
                    style: TextStyle(fontSize: 15.0))),
            Container(
                padding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0),
                child: Text("$_totalDistance",
                    style: TextStyle(fontSize: 15.0))),
          ]),
        ],
      ),
    );
  }

  Future<bool> checkPermissions() async {
    final storageStatus = await Permission.storage.request();
    if ( storageStatus != PermissionStatus.granted) {
      throw Exception("Permission denied");
    }
    return true;
  }
  void getPositions() {
    RenderBox? lbox = leftKey.currentContext!.findRenderObject() as RenderBox?;
    leftButtonPosition = lbox!.localToGlobal(Offset.zero);

    RenderBox? rbox = rightKey.currentContext!.findRenderObject() as RenderBox?;
    rightButtonPosition = rbox!.localToGlobal(Offset.zero);

    print(
        "LEFT BUTTON x: ${leftButtonPosition!.dx} , y: ${leftButtonPosition!.dy}");
    print(
        "RIGHT BUTTON x: ${rightButtonPosition!.dx} , y: ${rightButtonPosition!.dy}");
  }

  /**
   * Starts countdown timer to  when start test is pressed, when countdown reaches zero the game timer starts
   */

  void startReadyTimer() {
    _countdownCommenced = true;
    _readyTimerOpacity = 1.0;
    _totalDistance = 0.0;
    _amountPressed = 0;
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: _readyTimerStart),
      new Duration(seconds: 1),
    );

    var sub = countDownTimer.listen(null);
    sub.onData((duration) {
      setState(() {
        _readyTimerCurrent = _readyTimerStart - duration.elapsed.inSeconds;
      });
    });

    sub.onDone(() {
      print("Done");
      _readyTimerOpacity = 0.0;
      _readyTimerCurrent = 10;
      _gamesCommenced = true;
      _leftActivated = true;
      sub.cancel();
      startCountDownTimer();
    });
  }

  /**
   * Starts countdown timer to tell user how much time they have left in the test
   */
  void startCountDownTimer() {
    _countDownOpacity = 1.0;
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: _countDownStart),
      new Duration(seconds: 1),
    );

    var sub = countDownTimer.listen(null);
    sub.onData((duration) {
      setState(() {
        _countDownCurrent = _countDownStart - duration.elapsed.inSeconds;
      });
    });

    sub.onDone(() async {
      print("Done");
      _countDownOpacity = 0.0;
      _countDownCurrent = 30;
      _gamesCommenced = false;
      _countdownCommenced = false;
      _leftActivated = false;
      _rightActivated = false;

      //sub.cancel();
      //send up to firebase firestore
      DataBaseService(uid: AuthService().getCurrentUser().uid).updateUserRythmGame(_amountPressed, _totalDistance,widget.medicineAnswer);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("You have completed the Rythm game good job!")));
      writeDataToCsv();
    });
  }

  void _onTapDown(TapDownDetails details) {
    if (_gamesCommenced) {

      //Find the Coordinants of the buttons
      RenderBox? lbox = leftKey.currentContext!.findRenderObject() as RenderBox?;
      leftButtonPosition = lbox!.localToGlobal(Offset.zero);

      RenderBox? rbox = rightKey.currentContext!.findRenderObject() as RenderBox?;
      rightButtonPosition = rbox!.localToGlobal(Offset.zero);

      String ButtonType = "";

      if (_leftActivated) {
        setState(() {

          //calculate distance from center of active button
          double distance = pixelsToCenter(
              details.globalPosition.dx,
              details.globalPosition.dy,
              leftButtonPosition!.dx + lbox.size.width / 2,
              leftButtonPosition!.dy + lbox.size.height / 2);
          _totalDistance += distance;

          print("DISTANCE TO CENTER: $distance");

          //Add Info to DataArray to be turned into csv
          ButtonType = "LeftButton";
          List<dynamic> row = [
            createTimeStamp(),
            ButtonType,
            {'x':details.globalPosition.dx,'y':details.globalPosition.dy},
            {'x': leftButtonPosition!.dx,'y':leftButtonPosition!.dy},
            {'x': rightButtonPosition!.dx,'y':rightButtonPosition!.dy},
            distance
          ];
          _DataArray!.add(row);

        });
      } else {
        setState(() {

          //calculate distance from center of active button
          double distance = pixelsToCenter(
              details.globalPosition.dx,
              details.globalPosition.dy,
              rightButtonPosition!.dx + rbox.size.width / 2,
              rightButtonPosition!.dy + rbox.size.height / 2);
          _totalDistance += distance;

          print("DISTANCE TO CENTER:$distance");



          //Add Info to DataArray to be turned into csv
          ButtonType = "RightButton";
          List<dynamic> row = [
            createTimeStamp(),
            ButtonType,
            {'x':details.globalPosition.dx,'y':details.globalPosition.dy},
            {'x': leftButtonPosition!.dx,'y':leftButtonPosition!.dy},
            {'x': rightButtonPosition!.dx,'y':rightButtonPosition!.dy},
            distance
          ];
          _DataArray!.add(row);
        });
      }
    }
  }


  void writeDataToCsv() async {
    String csv = const ListToCsvConverter().convert(_DataArray);

    /// Write to a file
    final directory = await getApplicationDocumentsDirectory();
    final pathOfTheFileToWrite = directory.path + "/rhythm_test.csv";
    File file = File(pathOfTheFileToWrite);
    await file.writeAsString(csv);

    //Upload to firebase
    String uid = AuthService().getCurrentUser().uid;
    DataBaseService(uid:uid).uploadFile(file, "Rhythm Test",".csv");


    print("written to csv!");
    print(csv);
  }


  /**
   * calculates distance in pixels from where the user touched a button, to the center of the button
   *
   * @param touchx,touchY : offset for where user touched the button
   * @param centerX,centerY: offset for center of button
   */
  double pixelsToCenter(touchX, touchY, centerX, centerY) {
    return (touchX - centerX).abs() + (touchY - centerY).abs();
  }


  Widget buildRightButton() {
    return Container(
      key: rightKey,
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0),
      child: GestureDetector(
        onTapDown: (TapDownDetails details) {
          setState(() {
            _onTapDown(details);
            if (_rightActivated) {
              _rightActivated = !(_rightActivated);
              _leftActivated = !(_leftActivated);
              _amountPressed += 1;
            }
          });
        },
        onTertiaryTapDown: (TapDownDetails details) {
          setState(() {
            _onTapDown(details);
            if (_rightActivated) {
              _rightActivated = !(_rightActivated);
              _leftActivated = !(_leftActivated);
              _amountPressed += 1;
            }
          });
        },
        child: CircleAvatar(
          backgroundColor:
              (_rightActivated && _gamesCommenced && !(_leftActivated))
                  ? Colors.red
                  : Colors.blue,
          radius: 45,
          child: Center(
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 10,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLeftButton() {
    return Container(
      key: leftKey,
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0),
      child: GestureDetector(
        onTapDown: (TapDownDetails details) {
          setState(() {
            _onTapDown(details);
            if (_leftActivated) {
              _rightActivated = !(_rightActivated);
              _leftActivated = !(_leftActivated);
              _amountPressed += 1;
            }
          });
        },
        onTertiaryTapDown: (TapDownDetails details) {
          setState(() {
            _onTapDown(details);
            if (_leftActivated) {
              _rightActivated = !(_rightActivated);
              _leftActivated = !(_leftActivated);
              _amountPressed += 1;
            }
          });
        },
        child: CircleAvatar(
          backgroundColor:
              (_leftActivated && _gamesCommenced && !(_rightActivated))
                  ? Colors.red
                  : Colors.blue,
          radius: 45,
          child: Center(
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 10,
            ),
          ),
        ),
      ),
    );
  }
}
