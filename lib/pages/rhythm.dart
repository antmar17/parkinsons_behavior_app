import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:parkinsons_app/services/auth.dart';
import 'package:parkinsons_app/services/database.dart';
import 'package:quiver/async.dart';

class Rhythm extends StatefulWidget {
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

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
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

    sub.onDone(() {
      print("Done");
      _countDownOpacity = 0.0;
      _countDownCurrent = 30;
      _gamesCommenced = false;
      _countdownCommenced = false;
      _leftActivated = false;
      _rightActivated = false;

      //send up to firebase firestore
      DataBaseService(uid: _authService.getCurrentUser().uid).updateUserRythmGame(_amountPressed, _totalDistance);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("You have completed the Rythm game good job!")));
      Navigator.pop(context);
      sub.cancel();
    });
  }

  void _onTapDown(TapDownDetails details) {
    if (_gamesCommenced) {
      if (_leftActivated) {
        setState(() {
          RenderBox? lbox =
              leftKey.currentContext!.findRenderObject() as RenderBox?;
          leftButtonPosition = lbox!.localToGlobal(Offset.zero);
          double distance = pixelsToCenter(
              details.globalPosition.dx,
              details.globalPosition.dy,
              leftButtonPosition!.dx + lbox.size.width / 2,
              leftButtonPosition!.dy + lbox.size.height / 2);
          _totalDistance += distance;
          print("DISTANCE TO CENTER: $distance");
        });
      } else {
        setState(() {
          RenderBox? rbox =
              rightKey.currentContext!.findRenderObject() as RenderBox?;
          rightButtonPosition = rbox!.localToGlobal(Offset.zero);
          double distance = pixelsToCenter(
              details.globalPosition.dx,
              details.globalPosition.dy,
              rightButtonPosition!.dx + rbox.size.width / 2,
              rightButtonPosition!.dy + rbox.size.height / 2);
          _totalDistance += distance;

          print("DISTANCE TO CENTER:$distance");
        });
      }
    }
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
