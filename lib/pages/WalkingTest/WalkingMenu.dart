import 'package:flutter/material.dart';
import 'package:parkinsons_app/pages/WalkingTest/StraightWalking.dart';
import 'package:parkinsons_app/services/Util.dart';
import 'package:parkinsons_app/widgets/WideButton.dart';

import 'Turning.dart';

class WalkingMenu extends StatefulWidget {
  @override
  _WalkingMenuState createState() => _WalkingMenuState();
}

class _WalkingMenuState extends State<WalkingMenu> {

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
              Navigator.push(context, MaterialPageRoute(builder: (context) => StraightWalking() ));
            }),
            WideButton(color: Colors.blue, buttonText: "Turning Walking Test", onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => TurnWalking() ));
            }),
          ]),
        ),
      ),
    );
  }

  PreferredSizeWidget buildAppBar() {
    return AppBar(
      title: Text("Walking Test"),
      centerTitle: true,
    );
  }
}
