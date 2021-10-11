import 'package:flutter/material.dart';
import 'package:parkinsons_app/pages/DrawingTest/clock.dart';
import 'package:parkinsons_app/pages/MedicineQuestion.dart';
import 'package:parkinsons_app/pages/SurveyTest/MDS-UPDRS.dart';
import 'package:parkinsons_app/pages/SurveyTest/SurveyMenu.dart';
import 'package:parkinsons_app/services/Util.dart';
import 'package:parkinsons_app/services/auth.dart';
import 'package:parkinsons_app/widgets/WideButton.dart';

import 'JoinCircles.dart';

class DrawingMenu extends StatefulWidget {
  final AuthService _auth = AuthService();
  String medicineAnswer;
  DrawingMenu({required this.medicineAnswer});

  @override
  _DrawingMenuState createState() => _DrawingMenuState();
}

class _DrawingMenuState extends State<DrawingMenu> {


  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Center(
              child: Text(
                "Drawing Test!",
                style: TextStyle(fontSize: 12.0),
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
            width: double.infinity,
            height: screenSize.height,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                        WideButton(color: Colors.blue, buttonText: "Clock Drawing", onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ClockDraw(medicineAnswer: widget.medicineAnswer,)));
                        }),

                        WideButton(color: Colors.blue, buttonText: "Join the circles", onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => JoinCircles(medicineAnswer: widget.medicineAnswer,)));
                        }),
                      ],
                    )),


      ),
    );
  }


  Widget buildLogout() {
    return FlatButton.icon(
      onPressed: () async {
        await widget._auth.signOut();
        Navigator.pushReplacementNamed(context, '/login');
      },
      icon: Icon(Icons.person),
      label: Text(
        'logout',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
