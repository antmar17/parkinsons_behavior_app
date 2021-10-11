import 'package:flutter/material.dart';
import 'package:parkinsons_app/pages/WalkingTest/StraightWalking.dart';
import 'package:parkinsons_app/services/Util.dart';
import 'package:parkinsons_app/widgets/WideButton.dart';

import 'Turning.dart';

class WalkingMenu extends StatefulWidget {
  String medicineAnswer;
  WalkingMenu({required this.medicineAnswer});

  @override
  _WalkingMenuState createState() => _WalkingMenuState();
}

class _WalkingMenuState extends State<WalkingMenu> {

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: buildAppBar(),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: screenSize.height,
          padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
            WideButton(color: Colors.blue, buttonText: "Straight Walking Test", onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => StraightWalking(medicineAnswer: widget.medicineAnswer,) ));
            }),
            WideButton(color: Colors.blue, buttonText: "Turning Walking Test", onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Turning(medcineAnswer: widget.medicineAnswer,) ));
            }),
          ]),
        ),
      ),
    );
  }

  PreferredSizeWidget buildAppBar() {
    return AppBar(
      title: Text("Walking Test",style: TextStyle(fontSize: 15.0),),
      centerTitle: true,
    );
  }
}
