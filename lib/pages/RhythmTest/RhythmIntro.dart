import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parkinsons_app/pages/RhythmTest/rhythm.dart';
import 'package:parkinsons_app/services/Util.dart';

class RhythmIntro extends StatelessWidget {
  String medicineAnswer;

  RhythmIntro({required this.medicineAnswer});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
              width: double.infinity,
              height: screenSize.height,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Column(
                children: [
                  buildInstructions(screenSize),
                  buildImage(screenSize),
                  buildNextButton(context, screenSize)
                ],
              )),
        ),
      ),
    );
  }

  Widget buildInstructions(Size screenSize) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(height: screenSize.height * 0.05),
      Text(
        "INSTRUCTIONS",
        style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: screenSize.height * 0.05),
      Text(
        "Rest your phone on a flat surface. Then use two fingers on the same hand to tap the buttons that appear. Keep tapping for 20 seconds",
        style: TextStyle(fontSize: 15),
      ),
      SizedBox(height: screenSize.height * 0.05),
      Text(
        "Tap Next to begin the test",
        style: TextStyle(fontSize: 15),
      )
    ]);
  }

  Widget buildImage(Size screenSize) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.05),
      child: Image.asset(
        "assets/HandImage.png",
        width: screenSize.width * 0.8,
        height: screenSize.height * 0.4,
        fit: BoxFit.fitWidth,
      ),
    );
  }

  Widget buildNextButton(BuildContext context, Size screenSize) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.white,
            padding: EdgeInsets.symmetric(
              vertical: screenSize.height * 0.025,
              horizontal: screenSize.width * 0.2,
            ),
            side: BorderSide(color: Colors.red)),
        child: Text("Next", style: TextStyle(fontSize: 15, color: Colors.red)),
        onPressed: () {
          //Navigator.of(context).pushReplacementNamed('/rhythm');

          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Rhythm(medicineAnswer: medicineAnswer,)));
        });
  }
}
