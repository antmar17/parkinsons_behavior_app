import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkinsons_app/services/Util.dart';
import 'package:parkinsons_app/services/auth.dart';
import 'package:parkinsons_app/services/database.dart';

class MDSUPDRS extends StatefulWidget {
  String participantAnswer;
  MDSUPDRS({required this.participantAnswer});

  @override
  _MDSUPDRSState createState() => _MDSUPDRSState();
}

class _MDSUPDRSState extends State<MDSUPDRS> {


  List<int>numInputSelected = [];

  List<String> questions = [
    "How good or bad is your health TODAY (0 means the worst health you can imagine, 100 means the best health you can imagine)?",
    "Over the past week, how many times did you do the following kinds of exercise for more than 15 minutes? Strenuous exercise (heart beats rapidly)",
    "Over the past week, how many times did you do the following kinds of exercise for more than 15 minutes? Moderate exercise (not exhausting)",
    "Over the past week, how many times did you do the following kinds of exercise for more than 15 minutes? Minimal effort",
    "During your leisure time in the past week, how often do you engage in any regular activity long enough to work up a sweat (heart beats rapidly)?",
    "Over the past week have you had problems remembering things, following conversations, paying attention, thinking clearly, or finding your way around the house or in town?",
    "Over the past week have you felt low, sad, hopeless, or unable to enjoy things?",
    "Over the past week have you felt nervous, worried or tense?",
    "Over the past week, have you felt indifferent to doing activities or being with people?",
    "Over the past week, have you had trouble going to sleep at night or staying asleep through the night? Consider how rested you felt after waking up in the morning.",
    "Over the past week, have you had trouble staying awake during the daytime?",
    "Over the past week, have you had problems with your speech?",
    "Over the past week, have you usually had troubles handling your food and using eating utensils? For example, do you have trouble handling finger foods or using forks, knives, spoons, chopsticks?",
    "Over the past week, have you usually had problems dressing? For example, are you slow or do you need help with buttoning, using zippers, putting on or taking off your clothes or jewelry?",
    "Over the past week, have you usually been slow or do you need help with washing, bathing, shaving, brushing teeth, combing your hair, or with other personal hygiene?",
    "Over the past week, have people usually had trouble reading your handwriting?",
    "Over the past week, have you usually had trouble doing your hobbies or other things that you like to do?",
    "Over the past week, do you usually have trouble turning over in bed?",
    "Over the past week, have you usually had shaking or tremor?",
    "Over the past week, have you usually had problems with balance and walking?",
    "Over the past week, on your usual day when walking, do you suddenly stop or freeze as if your feet are stuck to the floor?",
  ];
  List<int> selected = [];
  List<int> answers = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int i = 0; i < 21; i++) {
      selected.add(0);
    }

    for (int i = 0; i < 21; i++) {
      answers.add(-1);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Survey",
          style: TextStyle(fontSize: 15.0),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            //buildInstructions(),
            buildNumInputQuestion(0),
            buildNumInputQuestion(1),
            buildNumInputQuestion(2),
            buildNumInputQuestion(3),
            buildGELTQuestion(4),
            buildMDSQuestion(5),
            buildMDSQuestion(6),
            buildMDSQuestion(7),
            buildMDSQuestion(8),
            buildMDSQuestion(9),
            buildMDSQuestion(10),
            buildMDSQuestion(11),
            buildMDSQuestion(12),
            buildMDSQuestion(13),
            buildMDSQuestion(14),
            buildMDSQuestion(15),
            buildMDSQuestion(16),
            buildMDSQuestion(17),
            buildMDSQuestion(18),
            buildMDSQuestion(19),
             buildMDSQuestion(20),
            buildSubmitButton(screenSize)
          ],
        ),
      ),
    );
  }

  Widget buildInstructions() {
    return Container(

      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        children: [
          Text("THANK YOU",
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold)),
          Text(
              "Answer the questions carefully and honestly and press the submit button!")
        ],
      ),
    );
  }

  Widget buildNumInputQuestion(int index) {
    String Question = questions[index];
    int QuestionNumber = index + 1;
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Column(
          children: [

            Text(
              "QUESTION " + QuestionNumber.toString(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            Container(
                padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 5),
                child: Text(
                  Question,
                  style: TextStyle(fontSize: 15),
                )),

            TextField(
            decoration: new InputDecoration(labelText: "Enter your number here"),
    keyboardType: TextInputType.number,
    inputFormatters: <TextInputFormatter>[
    FilteringTextInputFormatter.digitsOnly
    ],
              onChanged: (value){answers[index] = int.parse(value); },// Only numbers can be entered ,
    ),
          ],
        ));

    }

  Widget buildGELTQuestion(int index) {
    String Question = questions[index];
    int QuestionNumber = index + 1;

    //choices that the user can pick
    String choice1 = "Often";
    String choice2 = "Sometimes";
    String choice3 = "Never/Rarely";

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        children: [
          Text(
            "QUESTION " + QuestionNumber.toString(),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 5),
              child: Text(
                Question,
                style: TextStyle(fontSize: 15),
              )),
          Divider(
            thickness: 2.0,
          ),
          RadioListTile(
              title: Text(choice1),
              value: 1,
              groupValue: selected[index],
              onChanged: (value) {
                setState(() {
                  selected[index] = value as int;
                  answers[index] = value - 1;
                });
              }),
          RadioListTile(
              title: Text(choice2),
              value: 2,
              groupValue: selected[index],
              onChanged: (value) {
                setState(() {
                  selected[index] = value as int;
                  answers[index] = value;
                });
              }),
          RadioListTile(
              title: Text(choice3),
              value: 3,
              groupValue: selected[index],
              onChanged: (value) {
                setState(() {
                  selected[index] = value as int;
                  answers[index] = value;
                });
              }),
          Divider(
            thickness: 2.0,
          ),
        ],
      ),
    );
  }
  Widget buildMDSQuestion(int index) {
    String Question = questions[index];
    int QuestionNumber = index + 1;

    //choices that the user can pick
    String choice1 = "Normal";
    String choice2 = "Slight";
    String choice3 = "Mild";
    String choice4 = "Moderate";
    String choice5 = "Severe";

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        children: [
          Text(
            "QUESTION " + QuestionNumber.toString(),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 5),
              child: Text(
                Question,
                style: TextStyle(fontSize: 15),
              )),
          Divider(
            thickness: 2.0,
          ),
          RadioListTile(
              title: Text(choice1),
              value: 1,
              groupValue: selected[index],
              onChanged: (value) {
                setState(() {
                  selected[index] = value as int;
                  answers[index] = value - 1;
                });
              }),
          RadioListTile(
              title: Text(choice2),
              value: 2,
              groupValue: selected[index],
              onChanged: (value) {
                setState(() {
                  selected[index] = value as int;
                  answers[index] = value-1;
                });
              }),
          RadioListTile(
              title: Text(choice3),
              value: 3,
              groupValue: selected[index],
              onChanged: (value) {
                setState(() {
                  selected[index] = value as int;
                  answers[index] = value-1;
                });
              }),
          RadioListTile(
              title: Text(choice4),
              value: 4,
              groupValue: selected[index],
              onChanged: (value) {
                setState(() {
                  selected[index] = value as int;
                  answers[index] = value-1;
                });
              }),
          RadioListTile(
              title: Text(choice5),
              value: 5,
              groupValue: selected[index],
              onChanged: (value) {
                setState(() {
                  selected[index] = value as int;
                  answers[index] = value;
                });
              }),
          Divider(
            thickness: 2.0,
          ),
        ],
      ),
    );
  }

 void onSubmitPressed() async {
    String uid = AuthService().getCurrentUser().uid;
    String timestamp = createTimeStamp();
    Map<String,dynamic> map= {};
    for(int i = 0;i < answers.length ; i++){
      map["Question "+(i+1).toString()] = answers[i];
    }
    map["Survey Participant"] = widget.participantAnswer;
    await DataBaseService(uid:uid).userCollection.doc(uid).collection("MDS-UPDRS").doc(timestamp).set(map);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Submission recorded")));
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


