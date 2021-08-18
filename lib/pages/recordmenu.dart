import 'package:flutter/material.dart';
import 'package:parkinsons_app/widgets/WideButton.dart';

class RecordMenu extends StatelessWidget {
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
