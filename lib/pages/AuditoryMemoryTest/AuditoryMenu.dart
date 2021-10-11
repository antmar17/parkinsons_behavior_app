import 'package:flutter/material.dart';
import 'package:parkinsons_app/pages/AuditoryMemoryTest/AuditorMemory.dart';
import 'package:parkinsons_app/services/Util.dart';
import 'package:parkinsons_app/widgets/WideButton.dart';


class AuditoryMenu extends StatefulWidget {
  String medicineAnswer;
  AuditoryMenu({required this.medicineAnswer});


  @override
  _AuditoryMenuState createState() => _AuditoryMenuState();
}

class _AuditoryMenuState extends State<AuditoryMenu> {

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

                //'/auditory3':(context) => AuditoryMemory(mp3Path: "three_words.mp3",recordActivityPath: "/recordauditory3"),
                //'/auditory4':(context) => AuditoryMemory(mp3Path: "four_words.mp3",recordActivityPath: "/recordauditory4"),
                //'/auditory5':(context) => AuditoryMemory(mp3Path: "five_words.mp3",recordActivityPath: "/recordauditory5"),
                Navigator.push(context, MaterialPageRoute(builder: (context) => AuditoryMemory(medicineAnswer: widget.medicineAnswer , mp3Path:"three_words.mp3" ,activityTitle: "Auditory Memory Three Words")));

              }),
              WideButton(color: Colors.blue, buttonText: "Recall four words", onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => AuditoryMemory(medicineAnswer: widget.medicineAnswer , mp3Path:"four_words.mp3" ,activityTitle: "Auditory Memory Four Words")));
              }),
              WideButton(color: Colors.blue, buttonText: "Recall five words", onPressed: (){

                Navigator.push(context, MaterialPageRoute(builder: (context) => AuditoryMemory(medicineAnswer: widget.medicineAnswer , mp3Path:"five_words.mp3" ,activityTitle: "Auditory Memory Five Words")));
              }),

            ],
          ),
        ),
      ),
    );
  }
}

