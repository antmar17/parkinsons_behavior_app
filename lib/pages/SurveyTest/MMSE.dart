import 'package:flutter/material.dart';
import 'package:parkinsons_app/pages/SurveyTest/HorizontalMultipleChoiceQuestion.dart';
import 'package:parkinsons_app/pages/SurveyTest/MultipleChoiceQuestion.dart';
import 'package:parkinsons_app/services/Util.dart';
import 'package:parkinsons_app/services/auth.dart';
import 'package:parkinsons_app/services/database.dart';

import 'Question.dart';

class MMSE extends StatefulWidget {
  @override
  _MMSEState createState() => _MMSEState();
}

class _MMSEState extends State<MMSE> {
  List<String> questions = [
    "“What is the year? Season? Date? Day? Month?”",
    "“Where are we now? State? County? Town/city? Hospital? Floor?”",
    "The examiner names three unrelated objects clearly and slowly, then the instructor asks the patient to name all three of them. The patient’sresponse is used for scoring. The examiner repeats them until patient learns all of them, if possible",
    "“I would like you to count backward from 100 by sevens.” (93, 86, 79,72, 65, …) \nAlternative: “Spell WORLD backwards.” (D-L-R-O-W)",
    "“Earlier I told you the names of three things. Can you tell me whatthose were?”",
    "Show the patient two simple objects, such as a wristwatch and a pencil, and ask the patient to name them.",
    "“Repeat the phrase: ‘No ifs, ands, or buts.’”",
    "“Take the paper in your right hand, fold it in half, and put it on the floor.”\n(The examiner gives the patient a piece of blank paper.)",
    "“Please read this and do what it says.” (Written instruction is “Closeyour eyes.”)",
    "Make up and write a sentence about anything.”\n(This sentence must contain a noun and a verb.)"
  ];

  List<List<String>> choices = [
    ['0', '1', '2', '3', '4', '5'],
    ['0', '1', '2', '3', '4', '5'],
    ['0', '1', '2', '3'],
    ['0', '1', '2', '3', '4', '5'],
    ['0', '1', '2', '3'],
    ['0', '1', '2'],
    ['0', '1'],
    ['0', '1', '2', '3'],
    ['0', '1'],
    ['0', '1'],
  ];

  List<Widget> widget_array = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget_array = List.generate(questions.length, (index) {
      return MultipleChoiceQuestion(
          question: questions[index],
          questionNumber: index + 1,
          choices: choices[index]);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text("MMSE"),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: screenSize.height,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: ListView(
              children: [
                buildInstructions(),
                    Column(
                  children: widget_array,
                ),
                buildSubmitButton(screenSize)
              ],
            ),
          ),
        ));
  }

  Widget buildInstructions() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        children: [
          Text(
            "Instructions: Score one point for each correct response within each question or activity.",
            style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic),
          )
        ],
      ),
    );
  }

  void onSubmitPressed() async {
    List<String> answers = [];
    for (int i = 0; i < widget_array.length; i++) {
      Question question = widget_array[i] as Question;
      String answer = question.getAnswer();
      if (answer == "") {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Please answer all Questions")));
        return;
      }
      answers.add(answer);
    }
    String uid = AuthService().getCurrentUser().uid;
    String timestamp = createTimeStamp();
    Map<String, dynamic> map = {};
    for (int i = 0; i < answers.length; i++) {
      map["Question " + (i + 1).toString()] = answers[i];
    }
    await DataBaseService(uid: uid)
        .userCollection
        .doc(uid)
        .collection("MMSE")
        .doc(timestamp)
        .set(map);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Submission recorded")));
  }

  Widget buildSubmitButton(Size screenSize) {
    return Container(
      width: screenSize.width * 0.8,
      height: screenSize.height * 0.05,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: ElevatedButton(
        onPressed: onSubmitPressed,
        child: Text("Submit Answers"),
        style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)))),
      ),
    );
  }
}
