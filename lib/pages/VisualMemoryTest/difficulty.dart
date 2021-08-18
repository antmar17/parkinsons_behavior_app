import 'package:flutter/material.dart';

class Difficulty extends StatefulWidget {
  @override
  _DifficultyState createState() => _DifficultyState();
}

class _DifficultyState extends State<Difficulty> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar:AppBar(
          title:Text("Select Difficulty",
            style: TextStyle(
                fontSize: 15.0
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
            child: Container(
                width: double.infinity,
                height: screenSize.height,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Choose a Difficulty!",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(height: 10),
                      buildDifficultyBtn(context, 1),
                      buildDifficultyBtn(context, 2),
                      buildDifficultyBtn(context, 3),
                      buildDifficultyBtn(context, 4),
                      buildDifficultyBtn(context, 5)


                    ]))));
  }
}

Widget buildDifficultyBtn(BuildContext context, int difficulty) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 25),
    width: double.infinity,
    child: RaisedButton(
      elevation: 5,
      child: Text(
        'Difficulty level ' + difficulty.toString() + " (" + (difficulty + 1).toString() + "x" + (difficulty +1).toString() +" grid)",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        Navigator.pushNamed(context,'/memory' + difficulty.toString());
      },
      padding: EdgeInsets.all(15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.blue,
    ),
  );
}
