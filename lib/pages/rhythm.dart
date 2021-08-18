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
      sub.cancel();
    });
  }

  _onTapDownLeft(TapDownDetails details) {
    var x = details.globalPosition.dx;
    var y = details.globalPosition.dy;
    // or user the local position method to get the offset
    print(details.localPosition);
    //   print("tap down " + x.toString() + ", " + y.toString());
    print("distance to center: " +
        pixelsToCenter(
                details.localPosition.dx, details.localPosition.dy, 45.0, 45.0)
            .toString());
    if(_gamesCommenced && _leftActivated) {
      _totalDistance+=pixelsToCenter(details.localPosition.dx, details.localPosition.dy, 45.0, 45.0);
    }
  }

  _onTapDownRight(TapDownDetails details) {
    var x = details.globalPosition.dx;
    var y = details.globalPosition.dy;
    // or user the local position method to get the offset
    print(details.localPosition);
    //   print("tap down " + x.toString() + ", " + y.toString());
    print("distance to center: " +
        pixelsToCenter(
            details.localPosition.dx, details.localPosition.dy, 45.0, 45.0)
            .toString());
    if(_gamesCommenced && _rightActivated) {
      _totalDistance+=pixelsToCenter(details.localPosition.dx, details.localPosition.dy, 45.0, 45.0);
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
                  child: Text("Time Left", style: TextStyle(fontSize: 20.0)))),
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
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0),
                child: GestureDetector(
                  onTap: () => print('tapped!'),
                  onTapDown: (TapDownDetails details) => _onTapDownLeft(details),
                  child: ClipOval(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (_leftActivated) {
                            _rightActivated = !(_rightActivated);
                            _leftActivated = !(_leftActivated);
                            _amountPressed += 1;
                          }
                        });
                      },
                      child: Center(child:CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 10,
                      )),
                      style: ElevatedButton.styleFrom(
                          primary: (_leftActivated &&
                                  _gamesCommenced &&
                                  !(_rightActivated))
                              ? Colors.red
                              : Colors.blue,
                          minimumSize: Size(90.0, 90.0)),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0),
                child: GestureDetector(
                  onTap: () => print('tapped!'),
                  onTapDown: (TapDownDetails details) => _onTapDownRight(details),
                  child: ClipOval(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (_rightActivated) {
                            _leftActivated = !(_leftActivated);
                            _rightActivated = !(_rightActivated);
                            _amountPressed += 1;
                          }
                        });
                      },
                      child: Center(child:CircleAvatar(
                        backgroundColor: Colors.white,
                        radius:10
                      )),
                      style: ElevatedButton.styleFrom(
                          primary: (_rightActivated &&
                                  _gamesCommenced &&
                                  !(_leftActivated))
                              ? Colors.red
                              : Colors.blue,
                          minimumSize: Size(90.0, 90.0)),
                    ),
                  ),
                ),
              ),
            ],
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
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Text("Score", style: TextStyle(fontSize: 15.0))),
            Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Text("Total Pixels from center",
                    style: TextStyle(fontSize: 15.0))),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child:
                    Text("$_amountPressed", style: TextStyle(fontSize: 15.0))),
            Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0),
                child:
                    Text("$_totalDistance", style: TextStyle(fontSize: 15.0))),
          ]),
        ],
      ),
    );
  }
}
