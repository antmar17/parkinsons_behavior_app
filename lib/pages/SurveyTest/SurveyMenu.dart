import 'package:flutter/material.dart';
import 'package:parkinsons_app/pages/SurveyTest/MDS-UPDRS.dart';
import 'package:parkinsons_app/pages/SurveyTest/ParticipantQuestionDemographic.dart';
import 'package:parkinsons_app/pages/SurveyTest/ParticipantQuestionMDS.dart';
import 'package:parkinsons_app/services/Util.dart';
import 'package:parkinsons_app/widgets/WideButton.dart';




class SurveyMenu extends StatefulWidget {

  @override
  _SurveyMenuState createState() => _SurveyMenuState();
}

class _SurveyMenuState extends State<SurveyMenu> {


  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Surveys'),
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
                  buttonText: "MDS-UPDRS Survey",
                  onPressed: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context) => ParticipantQuestionMDS() ));
                  }),
              WideButton(
                  color: Colors.blue,
                  buttonText: "MMSE Survey",
                  onPressed: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context) => ParticipantQuestionDemographic() ));
                  }),
              WideButton(
                  color: Colors.blue,
                  buttonText: "Demographic Survey",
                  onPressed: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context) => ParticipantQuestionDemographic() ));
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
