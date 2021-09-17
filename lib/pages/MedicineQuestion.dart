import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:parkinsons_app/pages/RhythmTest/RhythmIntro.dart';
import 'package:parkinsons_app/pages/RhythmTest/rhythm.dart';
import 'package:parkinsons_app/services/Util.dart';
import 'package:parkinsons_app/services/auth.dart';

class MedicineQuestion extends StatefulWidget {
  String nextActivityRoute;

  MedicineQuestion({required this.nextActivityRoute});

  @override
  _MedicineQuestionState createState() => _MedicineQuestionState();
}

class _MedicineQuestionState extends State<MedicineQuestion> {
  int selectedRadio = 0;

  @override
  void initState() {
    // TODO: implement initState
    String lastMedicineAnswer = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: SafeArea(
            child: Container(
          width: double.infinity,
          height: screenSize.height,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(height: screenSize.height * 0.025),
                buildInstructions(screenSize),
                SizedBox(height: screenSize.height * 0.025),
                Divider(
                  thickness: 2.0,
                ),
                buildQuestions(),
                Divider(
                  thickness: 2.0,
                ),
                SizedBox(height: screenSize.height * 0.025),
                buildNextButton(context, screenSize)
              ],
            ),
          ),
        )),
      ),
    );
  }

  Widget buildInstructions(Size screenSize) {
    return Column(
      children: [
        SizedBox(
          height: screenSize.height * 0.025,
        ),
        Text(
          "We would like to understand how your performance on this activity could be affected by the timing of your medication.",
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(
          height: screenSize.height * 0.05,
        ),
        Text(
          "When did you last take Parkinson's medication?",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget buildQuestions() {
    return Column(
      children: [
        RadioListTile(
            title: Text("Immediately before taking this test "),
            value: 1,
            groupValue: selectedRadio,
            onChanged: (value) {
              setState(() {
                lastMedicineAnswer = "Immediately before taking this test ";
                selectedRadio = value as int;
              });
            }),
        RadioListTile(
            title: Text("Just after taking this test"),
            value: 2,
            groupValue: selectedRadio,
            onChanged: (value) {
              setState(() {
                lastMedicineAnswer = "Just after taking this test";
                selectedRadio = value as int;
              });
            }),
        RadioListTile(
            title: Text("Another Time"),
            value: 3,
            groupValue: selectedRadio,
            onChanged: (value) {
              setState(() {
                lastMedicineAnswer = "Another Time";
                selectedRadio = value as int;
              });
            }),
        RadioListTile(
            title: Text("I don't take Parkinson medication"),
            value: 4,
            groupValue: selectedRadio,
            onChanged: (value) {
              setState(() {
                lastMedicineAnswer = "I don't take Parkinson medication";
                selectedRadio = value as int;
              });
            }),
      ],
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
        onPressed: handleNextPressed);
  }

  void handleNextPressed() {
    if(lastMedicineAnswer != ""){
      Navigator.of(context).pushReplacementNamed(widget.nextActivityRoute);
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please answer the question"),));
    }
  }

}
