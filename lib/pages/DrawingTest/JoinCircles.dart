import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_painter/image_painter.dart';
import 'package:parkinsons_app/services/auth.dart';
import 'package:parkinsons_app/services/database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class JoinCircles extends StatefulWidget {
  String medicineAnswer;

  JoinCircles({required this.medicineAnswer});

  @override
  _JoinCirclesState createState() => _JoinCirclesState();
}

class _JoinCirclesState extends State<JoinCircles> {
  final _imageKey = GlobalKey<ImagePainterState>();
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Join Circles'),
        actions: [
          ElevatedButton(
              child: Text('Submit Drawing'),
              onPressed: submitImage
          )
        ],

      ),
      body: SafeArea(
        child: Stack(
            children:[
              ImagePainter.asset(
            "assets/squares_ciricles.png",
            scalable: true,
            initialPaintMode: PaintMode.freeStyle, key: _imageKey,
            colors: [Colors.red], ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                  children:[
                    SizedBox(height: screenSize.height * 0.1,),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.015),
                        child: Text("INSTRUCTIONS",style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold),)),
                    Container(
                        padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.025,horizontal: screenSize.width * 0.025),
                        child: Text("Please Join the circles together to form a letter (ignore the squares) ",style: TextStyle(fontSize: 15),)),
                  ]),
            ]

        ),
      ),
    );
  }


  void submitImage() async {
    final storageStatus = await Permission.storage.request();
    final image = await _imageKey.currentState!.exportImage();
    final directory = (await getApplicationDocumentsDirectory()).path;
    await Directory('$directory/sample').create(recursive: true);
    final fullPath = '$directory/sample/${DateTime
        .now()
        .millisecondsSinceEpoch}.png';
    final imgFile = File('$fullPath');
    imgFile.writeAsBytes(image!);
    String uid = AuthService()
        .getCurrentUser()
        .uid;
    DataBaseService db = DataBaseService(uid: uid);
    db.updateGeneric("Join Circles Test", widget.medicineAnswer);
    db.uploadFile(imgFile, "Join Circles Test", '.png');
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("image uploaded sucessfully!")));
  }
}




