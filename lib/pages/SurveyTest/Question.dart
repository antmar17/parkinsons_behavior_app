import 'package:flutter/material.dart';






abstract class Question{

  String answer = "";
  String getAnswer(){
    return this.answer;
}
}