import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:parkinsons_app/pages/RhythmTest/RhythmIntro.dart';
import 'package:parkinsons_app/pages/RhythmTest/rhythm.dart';
import 'package:parkinsons_app/services/Util.dart';
import 'package:parkinsons_app/services/auth.dart';

class MedicineQuestion extends StatefulWidget {
  String routeNameOfNextWidget;

  MedicineQuestion({required this.routeNameOfNextWidget});

  @override
  _MedicineQuestionState createState() => _MedicineQuestionState();
}

class _MedicineQuestionState extends State<MedicineQuestion> {
  int selectedRadio = 0;
  String medicineAnswer= "";

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
                Divider(thickness: 2.0,),
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
        Text("We would like to understand how your performance on this activity could be affected by the timing of your medication.",style: TextStyle(fontSize: 20.0),),
        SizedBox(
          height: screenSize.height * 0.025,
        ),
        Text(
          "When are you preforming this activity?",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget buildQuestions() {

    //choices that the user can pick
    String choice1 = "Immediately before taking parkinson's medication";
    String choice2 = "Just after taking Parkinson's medication(at your best)";
    String choice3 = "Another time";
    String choice4 = "I don't take Parkinson's medication";

    return Column(
      children: [
        RadioListTile(
            title: Text(choice1),
            value: 1,
            groupValue: selectedRadio,
            onChanged: (value) {
              setState(() {
                medicineAnswer = choice1;
                selectedRadio = value as int;
              });
            }),
        RadioListTile(
            title: Text(choice2),
            value: 2,
            groupValue: selectedRadio,
            onChanged: (value) {
              setState(() {
                medicineAnswer = choice2;
                selectedRadio = value as int;
              });
            }),
        RadioListTile(
            title: Text(choice3),
            value: 3,
            groupValue: selectedRadio,
            onChanged: (value) {
              setState(() {
                medicineAnswer = choice3;
                selectedRadio = value as int;
              });
            }),
        RadioListTile(
            title: Text(choice4),
            value: 4,
            groupValue: selectedRadio,
            onChanged: (value) {
              setState(() {
                medicineAnswer = choice4;
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
    if(medicineAnswer != ""){
      Navigator.of(context).pushReplacementNamed(widget.routeNameOfNextWidget,arguments: {'medicineAnswer':medicineAnswer});
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please answer the question"),));
    }
  }

}
