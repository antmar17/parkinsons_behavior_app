import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkinsons_app/pages/SurveyTest/MultipleChoiceQuestion.dart';
import 'package:parkinsons_app/pages/SurveyTest/NumberInputQuestion.dart';
import 'package:parkinsons_app/pages/SurveyTest/Question.dart';
import 'package:parkinsons_app/pages/SurveyTest/SelectMultipleQuestion.dart';
import 'package:parkinsons_app/services/Util.dart';
import 'package:parkinsons_app/services/auth.dart';
import 'package:parkinsons_app/services/database.dart';

class DemoGraphicSurvey extends StatefulWidget {
  String participantAnswer;

  DemoGraphicSurvey({required this.participantAnswer});

  @override
  _DemoGraphicSurveyState createState() => _DemoGraphicSurveyState();
}

class _DemoGraphicSurveyState extends State<DemoGraphicSurvey> {
  List<String> questions = [
    "How old are you?",
    "What is your sex?",
    "Which race do you identify with?",
    "What is the highest level of education that you have completed?",
    "What is your current employment status?",
    "What is your current marital status?",
    "Are you a spouse, partner or care-partner of someone who has Parkinson disease?",
    "Are you a spouse, partner or care-partner of someone who has Alzheimer's  disease?",
    "Have you ever participated in a research study or clinical trial on Parkinson disease or Alzheimer's disease before?",
    "How easy is it for you to use your smartphone?",
    "Do you ever use your smartphone to look for health or medical information online?",
    "Do you use the Internet or email at home?",
    "Do you ever use the Internet to look for health or medical information online?",
    "Do you ever use your smartphone to participate in a video call or video chat?",
    "Have you been diagnosed by a medical professional with Parkinson disease?",
    "In what year did your movement symptoms begin?",
    "In what year were you diagnosed with Parkinson disease?",
    "In what year did you begin taking Parkinson disease medication? Type in 0 if you have not started to take Parkinson medication.",
    "What kind of health care provider currently cares for your Parkinson disease?",
    "Have you ever had Deep Brain Stimulation?",
    "Have you ever had any surgery for Parkinson disease, other than DBS?",
    "Have you been diagnosed by a medical professional with Alzheimer's disease?",
    "In what year did your cognitive-related symptoms begin?",
    "In what year were you diagnosed with Alzheimer's disease?",
    "In what year did you begin taking Alzheimer's disease medication? Type in 0 if you have not started to take Alzheimer's medication.",
    "What kind of health care provider currently cares for your Alzheimer's disease?",
    "Have you ever smoked?",
    "How many years have you smoked?",
    "On average, how many packs did you smoke each day?",
    "When is the last time you smoked (put today’s date if you are still smoking)?",
    "Has a doctor ever told you that you have any of the following conditions? Please check all that apply. ",
  ];

  List<List<String>> choices_array = [
    ["integer"],
    ["Female", "Male", "Prefer not to answer"],
    [
      "",
      "Black or African",
      "Latino/Hispanic",
      "Native American",
      "Pacific Islander",
      "Middle Eastern",
      "Caribbean",
      "South Asian",
      "East Asian",
      "White or Caucasian",
      "Mixed"
    ],
    [
      "A homemaker",
      "A student",
      "Employment for wages",
      "Out of work",
      "Retired",
      "Self-employed",
      "Unable to work"
    ],
    [
      "2-year college degree",
      "4-year college degree",
      "Doctoral Degree",
      "High School Diploma/GED",
      "Master's Degree",
      "Some college",
      "Some graduate school",
      "Some high school"
    ],
    [
      "Divorced",
      "Married or domestic partnership",
      "Other",
      "Separated",
      "Single, never married",
      "Widowed"
    ],
    ["true", "false"],
    ["true", "false"],
    ["true", "false"],
    [
      "Difficult",
      "Easy",
      "Neither easy nor difficult",
      "Very Difficult",
      "Very easy"
    ],
    ["true", "false", "Not sure"],
    ["true", "false"],
    ["true", "false"],
    ["true", "false"],
    ["true", "false"],
    ["integer"],
    ["integer"],
    ["integer"],
    [
      "Don't know",
      "General Neurologist (non-Parkinson Disease specialist)",
      "Nurse Practitioner or Physician's Assistant",
      "Other",
      "Parkinson Disease/Movement Disorder Specialist",
      "Primary Care Doctor"
    ],
    ["true", "false"],
    ["true", "false"],
    ["true", "false"],
    ["integer"],
    ["integer"],
    ["integer"],
    [
      "Don't know",
      "General Neurologist (non-Parkinson Disease specialist)",
      "Nurse Practitioner or Physician's Assistant",
      "Other",
      "Parkinson Disease/Movement Disorder Specialist",
      "Primary Care Doctor"
    ],
    ["true", "false"],
    ["integer"],
    ["1", "2", "3", "4", "5"],
    ["integer"],
    [
      "",
      "Acute Myocardial Infarction/Heart Attack",
      "Alzheimer Disease or Alzheimer dementia",
      "Atrial Fibrillation",
      "Anxiety",
      "Cataract",
      "Kidney Disease",
      "Chronic Obstructive Pulmonary Disease or Asthma",
      "Heart Failure/Congestive Heart Failure",
      "Diabetes or Pre­diabetes or High Blood Sugar",
      "Glaucoma",
      "Hip/Pelvic Fracture",
      "Ischemic Heart Disease",
      "Depression",
      "Osteoporosis",
      "Rheumatoid Arthritis",
      "Dementia",
      "Stroke/Transient Ischemic Attack",
      "Breast Cancer",
      "Colorectal Cancer",
      "Prostate Cancer",
      "Lung Cancer",
      "Endometrial/Uterine Cancer",
      "Any other kind of cancer OR tumor",
      "Head Injury with Loss of Consciousness/Concussion",
      "Urinary Tract infections",
      "Obstructive Sleep Apnea",
      "Schizophrenia or Bipolar Disorder",
      "Peripheral Vascular Disease"
    ],
  ];

  List<Widget> widget_array = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget_array = List.generate(questions.length, (index) {
      if (choices_array[index][0] == "integer") {
        NumberInputQuestion question = NumberInputQuestion(
            question: questions[index], questionNumber: index + 1);
        return question;
      } else if (choices_array[index][0] == "") {
        choices_array[index].removeAt(0);
        SelectMultipleQuestion question = SelectMultipleQuestion(
            question: questions[index],
            questionNumber: index + 1,
            choices: choices_array[index]);
        return question;
      } else {
        MultipleChoiceQuestion question = MultipleChoiceQuestion(
            question: questions[index],
            questionNumber: index + 1,
            choices: choices_array[index]);
        return question;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: Text('Demographic survey'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: screenSize.height,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: ListView(
              children: [
                Column(
                  children: widget_array,
                ),
                buildSubmitButton(screenSize)
              ],
            ),
          ),
        ));
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
    map["Survey Participant"] = widget.participantAnswer;
    await DataBaseService(uid: uid)
        .userCollection
        .doc(uid)
        .collection("Demographic Survey")
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
