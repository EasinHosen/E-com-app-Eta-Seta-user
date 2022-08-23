import 'package:cloud_firestore/cloud_firestore.dart';

const String dateTimeStamp = 'timestamp';
const String dateDay = 'day';
const String dateMonth = 'month';
const String dateYear = 'year';

class DateModel {
  Timestamp timestamp;
  int day, month, year;

  DateModel(
      {required this.timestamp,
      required this.day,
      required this.month,
      required this.year});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      dateTimeStamp: timestamp,
      dateDay: day,
      dateMonth: month,
      dateYear: year,
    };
  }

  factory DateModel.fromMap(Map<String, dynamic> map) {
    return DateModel(
        timestamp: map[dateTimeStamp],
        day: map[dateDay],
        month: map[dateMonth],
        year: map[dateYear]);
  }

  @override
  String toString() {
    return 'DateModel{timestamp: $timestamp, day: $day, month: $month, year: $year}';
  }
}
