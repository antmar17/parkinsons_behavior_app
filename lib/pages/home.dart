import 'package:flutter/material.dart';
import 'package:parkinsons_app/services/auth.dart';
import 'package:parkinsons_app/widgets/WideButton.dart';

class Home extends StatefulWidget {
  final AuthService _auth = AuthService();

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              buildLogout(),
              Center(
                child: Text(
                  "Parkinson's Behavior App!",
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
              children: [
                Text("Choose a test",style: TextStyle(fontSize: 15.0)),

                Divider(height: 45.0,thickness: 4.0,color: Colors.blueGrey),

                WideButton(color: Colors.blue, buttonText: "Rhythm Test", onPressed: (){
                  Navigator.pushNamed(context, '/rhythm');
                }),

                WideButton(color: Colors.blue, buttonText: "Visual Memory Test", onPressed: (){
                  Navigator.pushNamed(context, '/difficulty');}),

                  WideButton(color: Colors.blue, buttonText: "Voice Recording Test", onPressed: (){
                    Navigator.pushNamed(context, '/recordmenu');}),

                WideButton(color: Colors.blue, buttonText: "Walking Test", onPressed: (){
                  Navigator.pushNamed(context, '/walking');}),

                WideButton(color: Colors.blue, buttonText: "Auditory Memory Test", onPressed: (){
                  Navigator.pushNamed(context, '/auditorydifficulty');
                }),

                WideButton(color: Colors.blue, buttonText: "Drawing Test", onPressed: (){
                  Navigator.pushNamed(context, '/clockdraw');
                }),


                Divider(height: 40.0,thickness: 4.0,color: Colors.blueGrey,),
              ],)
          ),
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