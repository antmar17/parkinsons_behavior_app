import 'package:flutter/material.dart';
import 'package:parkinsons_app/pages/AuditoryMemoryTest/AuditorMemory.dart';
import 'package:parkinsons_app/pages/AuditoryMemoryTest/AuditoryMenu.dart';
import 'package:parkinsons_app/pages/DrawingTest/DrawingMenu.dart';
import 'package:parkinsons_app/pages/RecordActivity.dart';
import 'package:parkinsons_app/pages/SurveyTest/DemoGraphicSurvey.dart';
import 'package:parkinsons_app/pages/SurveyTest/MDS-UPDRS.dart';
import 'package:parkinsons_app/pages/SurveyTest/ParticipantQuestion.dart';
import 'package:parkinsons_app/pages/TremorTest/Tremor.dart';
import 'package:parkinsons_app/pages/VoiceRecordingTest/RecordMenu.dart';
import 'package:parkinsons_app/pages/RhythmTest/RhythmIntro.dart';
import 'package:parkinsons_app/pages/VisualMemoryTest/VisualMemoryTestMenu.dart';
import 'package:parkinsons_app/pages/DrawingTest/clock.dart';
import 'package:parkinsons_app/pages/VoiceRecordingTest/RecordMenu.dart';
import 'package:parkinsons_app/pages/WalkingTest/WalkingMenu.dart';
import 'package:parkinsons_app/pages/home.dart';
import 'package:parkinsons_app/pages/VisualMemoryTest/memory.dart';
import 'package:parkinsons_app/pages/RhythmTest/rhythm.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:parkinsons_app/pages/UserLogin/login.dart';
import 'package:parkinsons_app/pages/UserLogin/signup.dart';
import 'package:parkinsons_app/pages/WalkingTest/StraightWalking.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(initialRoute: '/login',
        onGenerateRoute: _getRoute,
        routes: {
      '/login': (context) => Login(),
     '/signup': (context) => SignUp(),
      '/home': (context) => Home(),


    });
  }

  MaterialPageRoute _buildRoute(RouteSettings settings, Widget builder) {
    return new MaterialPageRoute(
      settings: settings,
      builder: (context) => builder,
    );
  }
  Route<dynamic>? _getRoute(RouteSettings settings) {

    if (settings.name == '/MDS-UPRDS') {
      // FooRoute constructor expects SomeObject
      Map<dynamic,dynamic>arguments = settings.arguments as Map;
      return _buildRoute(settings, new MDSUPDRS(participantAnswer:arguments['participantAnswer']));
    }

    if (settings.name == '/DemoGraphicSurvey') {
      // FooRoute constructor expects SomeObject
      Map<dynamic,dynamic>arguments = settings.arguments as Map;
      return _buildRoute(settings, new DemoGraphicSurvey(participantAnswer:arguments['participantAnswer']));
    }

    if (settings.name == '/RhythmIntro') {
      // FooRoute constructor expects SomeObject
      Map<dynamic,dynamic>arguments = settings.arguments as Map;
      return _buildRoute(settings, new RhythmIntro(medicineAnswer: arguments['medicineAnswer']));
    }

    if (settings.name == '/VisualMemoryTestMenu') {
      // FooRoute constructor expects SomeObject
      Map<dynamic,dynamic>arguments = settings.arguments as Map;
      return _buildRoute(settings, new VisualMemoryTestMenu(medicineAnswer: arguments['medicineAnswer']));
    }

    if (settings.name == '/RecordMenu') {
      // FooRoute constructor expects SomeObject
      Map<dynamic,dynamic>arguments = settings.arguments as Map;
      return _buildRoute(settings, new RecordMenu(medicineAnswer: arguments['medicineAnswer']));
    }

    if (settings.name == '/WalkingMenu') {
      // FooRoute constructor expects SomeObject
      Map<dynamic,dynamic>arguments = settings.arguments as Map;
      return _buildRoute(settings, new WalkingMenu(medicineAnswer: arguments['medicineAnswer']));
    }

    if (settings.name == '/AuditoryMenu') {
      // FooRoute constructor expects SomeObject
      Map<dynamic,dynamic>arguments = settings.arguments as Map;
      return _buildRoute(settings, new AuditoryMenu(medicineAnswer: arguments['medicineAnswer']));
    }

    if (settings.name == '/DrawingMenu') {
      // FooRoute constructor expects SomeObject
      Map<dynamic,dynamic>arguments = settings.arguments as Map;
      return _buildRoute(settings, new DrawingMenu(medicineAnswer: arguments['medicineAnswer']));
    }

    if (settings.name == '/TremorTest') {
      // FooRoute constructor expects SomeObject
      Map<dynamic,dynamic>arguments = settings.arguments as Map;
      return _buildRoute(settings, new Tremor(medicineAnswer: arguments['medicineAnswer']));
    }

    return null;
  }
}
