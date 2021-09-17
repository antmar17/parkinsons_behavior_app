import 'package:flutter/material.dart';
import 'package:parkinsons_app/services/Util.dart';
import 'package:parkinsons_app/widgets/WideButton.dart';


class AuditoryDifficulty extends StatefulWidget {


  @override
  _AuditoryDifficultyState createState() => _AuditoryDifficultyState();
}

class _AuditoryDifficultyState extends State<AuditoryDifficulty> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    lastMedicineAnswer = "";
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Auditory Memory Test",style: TextStyle(fontSize: 15.0),),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: screenSize.height,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              WideButton(color: Colors.blue, buttonText: "Recall three words", onPressed: (){
                Navigator.pushNamed(context, '/auditory3');

              }),
              WideButton(color: Colors.blue, buttonText: "Recall four words", onPressed: (){
                Navigator.pushNamed(context, '/auditory4');
              }),
              WideButton(color: Colors.blue, buttonText: "Recall five words", onPressed: (){
                Navigator.pushNamed(context, '/auditory5');
              }),

            ],
          ),
        ),
      ),
    );
  }
}

