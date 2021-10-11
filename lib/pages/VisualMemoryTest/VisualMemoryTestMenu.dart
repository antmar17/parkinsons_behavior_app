import 'package:flutter/material.dart';
import 'package:parkinsons_app/pages/VisualMemoryTest/memory.dart';
import 'package:parkinsons_app/services/Util.dart';

class VisualMemoryTestMenu extends StatefulWidget {
  String medicineAnswer;
  VisualMemoryTestMenu({required this.medicineAnswer});
  @override
  _VisualMemoryTestMenuState createState() => _VisualMemoryTestMenuState();
}

class _VisualMemoryTestMenuState extends State<VisualMemoryTestMenu> {

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
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Memory(medicineAnswer: widget.medicineAnswer, gridDimension: difficulty+1))  );
        },
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Colors.blue,
      ),
    );
  }
}

