import 'package:flutter/material.dart';
import 'package:parkinsons_app/pages/RecordActivity.dart';
import 'package:parkinsons_app/services/Util.dart';
import 'package:parkinsons_app/widgets/WideButton.dart';

class RecordMenu extends StatefulWidget {
  String medicineAnswer;

  RecordMenu({required this.medicineAnswer});

  @override
  _RecordMenuState createState() => _RecordMenuState();
}

class _RecordMenuState extends State<RecordMenu> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Voice Record Test'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: screenSize.height,
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              WideButton(
                  color: Colors.blue,
                  buttonText: "Pronounce Vowel",
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RecordActivity(
                                medicineAnswer: widget.medicineAnswer,
                                activityTitle: "Record Vowel Test",
                                instructionText:
                                    "Pronounce 'a' and hold for 5 seconds",
                                subInstructionsText: "")));
                    // '/recordbreath': (context) => RecordActivity(activityTitle: "Record Breath Test",instructionText:"Take a deep breath three times",subInstructionsText: "Inhale for four seconds each breath!"),
                    // '/recordsentence': (context) => RecordActivity(activityTitle:"Record Sentence Test",instructionText:"Read the following sentence:",subInstructionsText: "When the sunlight strikes raindrops in the air they act as a prism and form a rainbow. The rainbow is a division of white light into many beautiful colors."),
                  }),
              WideButton(
                  color: Colors.blue,
                  buttonText: "Deep Breath",
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RecordActivity(
                                medicineAnswer: widget.medicineAnswer,
                                activityTitle: "Record Breath Test",
                                instructionText:
                                    "Take a deep breath three times",
                                subInstructionsText:
                                    "Inhale for four seconds each breath")));
                  }),
              WideButton(
                  color: Colors.blue,
                  buttonText: "Read Sentence",
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RecordActivity(
                                medicineAnswer: widget.medicineAnswer,
                                activityTitle: "Record Sentence Test",
                                instructionText: "Read the following sentence",
                                subInstructionsText:
                                    "When the sunlight strikes raindrops in the air they act as a prism and form a rainbow. The rainbow is a division of white light into many beautiful colors.")));
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
