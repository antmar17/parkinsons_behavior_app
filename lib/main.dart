import 'package:flutter/material.dart';
import 'package:parkinsons_app/pages/AuditoryMemoryTest/AuditorMemory.dart';
import 'package:parkinsons_app/pages/AuditoryMemoryTest/AuditoryDifficulty.dart';
import 'package:parkinsons_app/pages/RecordActivity.dart';
import 'package:parkinsons_app/pages/SurveyTest/Survey.dart';
import 'package:parkinsons_app/pages/TremorTest/Tremor.dart';
import 'package:parkinsons_app/pages/VoiceRecordingTest/recordmenu.dart';
import 'package:parkinsons_app/pages/RhythmTest/RhythmIntro.dart';
import 'package:parkinsons_app/pages/VisualMemoryTest/difficulty.dart';
import 'package:parkinsons_app/pages/DrawingTest/clock.dart';
import 'package:parkinsons_app/pages/VoiceRecordingTest/recordmenu.dart';
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
    return MaterialApp(initialRoute: '/login', routes: {
      '/login': (context) => Login(),
     '/signup': (context) => SignUp(),

      '/home': (context) => Home(),

      '/rhythmIntro':(context) => RhythmIntro(),
      '/rhythm': (context) => Rhythm(),


      '/walkingMenu': (context) => WalkingMenu(),
      '/walking': (context) => StraightWalking(),

      '/difficulty': (context) => Difficulty(),
      '/memory1': (context) => Memory(gridDimension: 2),
      '/memory2': (context) => Memory(gridDimension: 3),
      '/memory3': (context) => Memory(gridDimension: 4),
      '/memory4': (context) => Memory(gridDimension: 5),
      '/memory5': (context) => Memory(gridDimension: 6),


      '/recordmenu': (context) => RecordMenu(),
      '/recordvowel': (context) => RecordActivity(activityTitle: "Record Vowel Test",instructionText:"Pronounce 'a' and hold for 5 seconds",subInstructionsText: "",),
      '/recordbreath': (context) => RecordActivity(activityTitle: "Record Breath Test",instructionText:"Take a deep breath three times",subInstructionsText: "Inhale for four seconds each breath!"),
      '/recordsentence': (context) => RecordActivity(activityTitle:"Record Sentence Test",instructionText:"Read the following sentence:",subInstructionsText: "When the sunlight strikes raindrops in the air they act as a prism and form a rainbow. The rainbow is a division of white light into many beautiful colors."),

      '/auditorydifficulty':(context) => AuditoryDifficulty(),
      '/auditory3':(context) => AuditoryMemory(mp3Path: "three_words.mp3",recordActivityPath: "/recordauditory3"),
      '/auditory4':(context) => AuditoryMemory(mp3Path: "four_words.mp3",recordActivityPath: "/recordauditory4"),
      '/auditory5':(context) => AuditoryMemory(mp3Path: "five_words.mp3",recordActivityPath: "/recordauditory5"),
      "/recordauditory3":(context) => RecordActivity(activityTitle: "Auditory Memory Test 1", instructionText:"Speak clearly and recall the words you just heard" , subInstructionsText: ""),
      "/recordauditory4":(context)=>RecordActivity(activityTitle: "Auditory Memory Test 2",instructionText:"Speak clearly and recall the words you just heard" , subInstructionsText: ""),
      "/recordauditory5":(context)=>RecordActivity(activityTitle: "Auditory Memory Test 3", instructionText:"Speak clearly and recall the words you just heard" , subInstructionsText: ""),

      "/clockdraw":(context) => ClockDraw(),

      '/Tremor':(context) => Tremor(),
      "/Survey":(context) => Survey(),


    });
  }
}
