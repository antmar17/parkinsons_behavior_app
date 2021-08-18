import 'dart:io';
import 'dart:ui';

import 'package:parkinsons_app/services/auth.dart';
import 'package:parkinsons_app/services/database.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ClockDraw extends StatefulWidget {
  @override
  _ClockDrawState createState() => _ClockDrawState();
}

class _ClockDrawState extends State<ClockDraw> {
  List <DrawingArea>points = [];
  double strokeWidth = 2.0;

  final controller = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: buildAppBar(screenSize),
        body: Stack(
          children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  buildSlider(screenSize),
                  SizedBox(height: 10),
                  buildInstructions(screenSize),
                  SizedBox(height: 10),
                  buildCanvas(screenSize),
                  SizedBox(height: 20),
                  buildSubmitButton(screenSize)
                ],
              ),
            )
          ],
        ));
  }


  PreferredSizeWidget buildAppBar(Size screenSize) {
    return AppBar(
      actions: [
        IconButton(onPressed: (){
          setState(() {
            points.clear();
          });
        }, icon: Icon(Icons.delete)),
        IconButton(onPressed: (){
          setState(() {
            if(points.isNotEmpty){
              points.removeLast();
            }
            while(points.isNotEmpty)
              if(points.removeLast().point != Offset.infinite){
                continue;
              }
              else{
                break;
              }
          });
        }, icon: Icon(Icons.undo))

      ],
      title: Text(
        "Clock Drawing Test",
        style: TextStyle(fontSize: 15.0),
      ),
      centerTitle: true,
    );

  }

  Widget buildSlider(Size screenSize) {
    return Container(
      width: screenSize.width * 0.8,
      height: screenSize.height * 0.05,
      decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: Row(
        children: [
          Expanded(child: Slider(
            min: 1.0,
            max: 7.0,
            value: strokeWidth,
            onChanged: (value){
              setState(() {
                strokeWidth = value;
              });
            },
            inactiveColor: Colors.white,
            activeColor: Colors.blue,)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
              child:Icon(Icons.edit,color: Colors.white,))
        ],
      ),
    );
  }

  Widget buildInstructions(Size screenSize) {
    return Container(
        width: screenSize.width * 0.8,
        child: Text(
          "1: Draw a clock with all the numbers and set the hands to 10 minutes after 11\n\n2:Press the submit button",
          style: TextStyle(fontSize: 15.0),
        ));
  }
  Widget buildCanvas(Size screenSize) {
    return Container(
      width: screenSize.width * 0.8,
      height: screenSize.height * 0.5,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          border: Border.all(width: 2.0),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 5.0,
                spreadRadius: 1.0)
          ]),
      child: GestureDetector(
        onPanDown: (details){
          setState(() {
            points.add(
                DrawingArea(
                point: details.localPosition,
                areaPaint: Paint()..strokeCap = StrokeCap.round
                ..isAntiAlias = true
                ..color = Colors.black
                ..strokeWidth = strokeWidth));
          });
        },
        onPanUpdate: (details){
          setState(() {
            points.add(
                DrawingArea(
                    point: details.localPosition,
                    areaPaint: Paint()..strokeCap = StrokeCap.round
                      ..isAntiAlias = true
                      ..color = Colors.black
                      ..strokeWidth = strokeWidth));
          });
        },
        onPanEnd: (details){
          setState(() {
            points.add(DrawingArea(point: Offset.infinite, areaPaint: Paint()));
          });
        },

        child: ClipRRect(
         borderRadius: BorderRadius.all(Radius.circular(20.0)),

          child: CustomPaint(
            painter: new MyCustomPainter(points: points),
          ),
        ),
      ),
    );
  }

  void onSubmitPressed(Size screenSize) async {

    final storageStatus = await Permission.storage.request();

    if(storageStatus == PermissionStatus.granted) {
      final imageBytes = await controller.captureFromWidget(buildCanvas(screenSize));
      final directory = await getApplicationDocumentsDirectory();
      final image = File('${directory.path}/clock.png');
      image.writeAsBytes(imageBytes);
      String uid = AuthService().getCurrentUser().uid;
      DataBaseService(uid:uid).uploadFile(image,"Clock Drawing Test",'.png');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("image uploaded sucessfully!")));
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Storage Permission not granted")));
    }
  }
  Widget buildSubmitButton(Size screenSize) {
    return Container(
      width: screenSize.width * 0.8,
      height: screenSize.height * 0.05,
      child: ElevatedButton(
        onPressed: () => onSubmitPressed(screenSize),
        child: Text("Submit Drawing"),
        style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)))),
      ),
    );
  }
}



class MyCustomPainter extends CustomPainter{
  List <DrawingArea>points;

  MyCustomPainter({required this.points});
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    Paint background = Paint();
    background.color= Colors.white;

    Rect rect = Rect.fromLTRB(0, 0, size.width, size.height);
    canvas.drawRect(rect, background);

    // set paint properties
    Paint paint = Paint();
    paint.color = Colors.black;
    paint.strokeWidth = 2.0;
    paint.isAntiAlias = true;
    paint.strokeCap = StrokeCap.round;

    //check if is a point or a line
    for(int i = 0; i < points.length - 1; i++){

      //if line draw line
      if(points[i].point != Offset.infinite && points[i+1].point != Offset.infinite){
        Paint paint = points[i].areaPaint;
        canvas.drawLine(points[i].point, points[i + 1].point, paint);
      }
      //if point draw a point
      else if(points[i].point != Offset.infinite && points[i+1].point == Offset.infinite){
        Paint paint = points[i].areaPaint;
        canvas.drawPoints(PointMode.points, [points[i].point], paint);
      }
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}


class DrawingArea{
  Offset point;
  Paint areaPaint;
  DrawingArea({required this.point,required this.areaPaint});

  Offset getPoint(){
    return this.point;
  }
}
