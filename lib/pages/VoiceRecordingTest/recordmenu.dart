import 'package:flutter/material.dart';
import 'package:parkinsons_app/services/Util.dart';
import 'package:parkinsons_app/widgets/WideButton.dart';

class RecordMenu extends StatefulWidget {

  @override
  _RecordMenuState createState() => _RecordMenuState();
}

class _RecordMenuState extends State<RecordMenu> {

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
        title: Text('Voice Record Test'),
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
                  buttonText: "Pronounce Vowel",
                  onPressed: () {
                    Navigator.pushNamed(context, "/recordvowel");
                  }),
              WideButton(
                  color: Colors.blue,
                  buttonText: "Deep Breath",
                  onPressed: () {
                    Navigator.pushNamed(context, "/recordbreath");
                  }),
              WideButton(
                  color: Colors.blue,
                  buttonText: "Read Sentence",
                  onPressed: () {
                    Navigator.pushNamed(context, "/recordsentence");
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
