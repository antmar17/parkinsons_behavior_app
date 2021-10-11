import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:parkinsons_app/pages/VisualMemoryTest/VisualMemoryTestMenu.dart';
import 'package:parkinsons_app/services/auth.dart';
import 'package:parkinsons_app/services/database.dart';
import 'package:parkinsons_app/widgets/TileModel.dart';
import 'package:quiver/async.dart';

CountdownTimer? _timer = null;
List<TileModel> pairs = <TileModel>[];
bool selected = false;
bool gameStarted = false;

String correctImagePath = ""; //path to what the user will have to remember
int difficulty = 0; //index of difficulty

List<String> startButtonString = ["Start",  "Next Stage"];

class Memory extends StatefulWidget {
  String medicineAnswer;
  int gridDimension;

  Memory({required this.medicineAnswer,required this.gridDimension});

  @override
  _MemoryState createState() => _MemoryState();
}

class _MemoryState extends State<Memory> {
  List<int> activeIndexes = []; // holds indexes of tiles with images in them
  List<TileModel> visiblePairs = []; //holds whats actually visible to user
  int maxActive = 8; //how many tiles will be active
  double correctShapeOpactity =
      1.0; //controls weather the correct shape shows at top
  double youWonOpacity = 0.0;

  double _countDownOpacity = 0.0;

  /* to display time left*/
  int _countDownStart = 30;
  int _countDownCurrent = 30;

  int timeLeftCurrent = 30;
  int timeLeftMax = 30;
  late CountdownTimer sub;
  int score = 0;

  String instructionText = "Remember where the shape is: ";

  AuthService _authService = AuthService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pairs = getPairs(widget.gridDimension);
    pairs.shuffle();
    visiblePairs = getQuestions(widget.gridDimension);
    // selected = true;
    Random random = Random();
    correctImagePath = "assets/green_triangle.png";
    difficulty = 0;


    // Future.delayed(const Duration(seconds: 5), () {
    //   setState(() {
    //     visiblePairs = getQuestions();
    //   });
    // });

    // selected = false;
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    gameStarted = false;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Visual Memory Test!",
            style: TextStyle(fontSize: 15.0),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Container(
              height: size.height,
              color: Colors.white,
              child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Opacity(
                          opacity: correctShapeOpactity,
                          child: Text(
                            instructionText,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Helvetica",
                                color: Colors.black),
                          ),
                        ),
                        Opacity(
                          opacity: correctShapeOpactity,
                          child: Image.asset(
                            correctImagePath,
                            height: size.width * 0.15,
                            width: size.width * 0.15,
                          ),
                        )
                      ]),
                      Opacity(
                        opacity: youWonOpacity,
                        child: Text(
                          "Great Job! Press " +
                              startButtonString[difficulty] +
                              "!",
                          style: TextStyle(
                              fontSize: size.width * 0.05,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Helvetica",
                              color: Colors.black),
                        ),
                      ),
                      Opacity(
                          opacity: 1.0,
                          child: Container(
                              padding: EdgeInsets.all(size.height * 0.025),
                              child: Text(
                                "Time Left: " + "$_countDownCurrent",
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.black,
                                    fontFamily: "Helvetica"),
                              ))),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 4.0, color: Colors.blue)),
                        child: SizedBox(
                          height: size.width * 0.9,
                          width: size.width * 0.9,
                          child: GridView(
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    mainAxisSpacing: 0.0,
                                    crossAxisCount: widget.gridDimension),
                            children: List.generate(visiblePairs.length, (index) {
                              return Tile(
                                imageAssetPath:
                                    visiblePairs[index].getImageAssetPath(),
                                index: index,
                                parent: this,
                              );
                            }),
                          ),
                        ),
                      ),
                      Text(
                        "Tries: " + "$score",
                        style: TextStyle(
                            fontSize: size.width * 0.05,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Helvetica",
                            color: Colors.black),
                      ),
                      Container(
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () {
                              if (!gameStarted) {

                                if (difficulty < 1) {
                                  setState(() {
                                    gameStarted = true;
                                    correctShapeOpactity = 1.0;
                                    youWonOpacity = 0.0;
                                    pairs = getPairs(widget.gridDimension);
                                    pairs.shuffle();
                                    visiblePairs = pairs;
                                    selected = true;
                                    Random random = Random();
                                    correctImagePath =
                                        "assets/green_triangle.png";

                                    Future.delayed(const Duration(seconds: 5),
                                        () {
                                      setState(() {
                                        instructionText = "Find where the shape is: ";
                                        visiblePairs =
                                            getQuestions(widget.gridDimension);
                                        correctShapeOpactity = 1.0;
                                        score = 0;
                                        startCountDownTimer();
                                      });
                                    });
                                    selected = false;
                                  });
                                } else {
                                  if (widget.gridDimension < 6) {
                                    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Memory(medicineAnswer: widget.medicineAnswer, gridDimension: widget.gridDimension+1)));
                                  } else {
                                    Navigator.pop(context);
                                  }
                                }
                              }
                            },
                            child: Text("${startButtonString[difficulty]}"),
                          ),
                        ),
                      )
                    ]),
              )),
        ));
  }

  void startCountDownTimer() {
    _countDownOpacity = 1.0;
    _countDownCurrent = 30;
    _timer = new CountdownTimer(
      new Duration(seconds: _countDownStart),
      new Duration(seconds: 1),
    );

    var sub = _timer!.listen(null);
    sub.onData((duration) {
      setState(() {
        _countDownCurrent = _countDownStart - duration.elapsed.inSeconds;
      });
    });
    sub.onDone(() {
      if(_countDownCurrent == 0) {
        DataBaseService(uid: _authService
            .getCurrentUser()
            .uid).updateUserMemoryGame(score, widget.gridDimension - 1, false,widget.medicineAnswer);
      }
      gameStarted = false;
    });
  }
}

class Tile extends StatefulWidget {
  String imageAssetPath;
  int index;
  _MemoryState parent;

  Tile(
      {required this.imageAssetPath,
      required this.index,
      required this.parent});

  @override
  _TileState createState() => _TileState();
}

class _TileState extends State<Tile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!selected && gameStarted) {
          setState(() {
            widget.parent.setState(() {
                if (pairs[widget.index].getisSelected() == false) {
                  widget.parent.score++;
                }
            });
            pairs[widget.index].setisSelected(true);
            print(checkForWin());
          });
        }
      },
      child: Container(
          decoration: BoxDecoration(border: Border.all()),
          margin: EdgeInsets.all(0.0),
          child: Transform.scale(
              scale: 0.75,
              child: Image.asset(pairs[widget.index].getisSelected()
                  ? pairs[widget.index].getImageAssetPath()
                  : widget.imageAssetPath))),
    );
  }

  bool checkForWin() {
    for (var i = 0; i < pairs.length; i++) {
      if (pairs[i].getImageAssetPath() == correctImagePath &&
          pairs[i].getisSelected() == false) {
        return false;
      }
    }
    widget.parent.youWonOpacity = 1.0;
    if (difficulty < 1) {
      difficulty++;
    } else {
      difficulty = 0;
    }
    selected = false;
    //widget.parent._countDownCurrent = 0;
    gameStarted = false;
    _timer!.cancel();
    DataBaseService(uid:widget.parent._authService.getCurrentUser().uid).updateUserMemoryGame(widget.parent.score,widget.parent.widget.gridDimension - 1,true,widget.parent.widget.medicineAnswer);
    return true;
  }
}

List<TileModel> getPairs(int gridDimension) {
  List<TileModel> pairs = [];

  for (var i = 0; i < gridDimension * gridDimension; i++) {
    if (i < difficulty + 1) {
      TileModel tileModel = new TileModel(
          imageAssetPath: "assets/green_triangle.png", isSelected: false);
      pairs.add(tileModel);
    } else {
      TileModel tileModel = new TileModel(
          imageAssetPath: "assets/transparent.jpg", isSelected: false);
      pairs.add(tileModel);
    }
  }

  return pairs;
}

List<TileModel> getQuestions(int gridDimension) {
  List<TileModel> pairs = [];

  for (var i = 0; i < gridDimension * gridDimension; i++) {
    TileModel tileModel =
        new TileModel(imageAssetPath: "assets/question.png", isSelected: false);
    pairs.add(tileModel);
  }

  return pairs;
}
