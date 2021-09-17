/***This file is for commonly used Functions and Constants ***/
String lastMedicineAnswer = "";
String createTimeStamp(){
  DateTime now = new DateTime.now();
  DateTime date = new DateTime(
      now.year, now.month, now.day, now.hour, now.minute, now.second,now.millisecond,now.microsecond);
  return date.toString();

}