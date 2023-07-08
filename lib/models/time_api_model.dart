// To parse this JSON data, do
//
//     final timeApiModel = timeApiModelFromJson(jsonString);

import 'dart:convert';

class TimeApiModel {
    int year;
    int month;
    int day;
    int hour;
    int minute;
    int seconds;
    int milliSeconds;
    DateTime dateTime;
    String date;
    String time;
    String timeZone;
    String dayOfWeek;
    bool dstActive;

    TimeApiModel({
        required this.year,
        required this.month,
        required this.day,
        required this.hour,
        required this.minute,
        required this.seconds,
        required this.milliSeconds,
        required this.dateTime,
        required this.date,
        required this.time,
        required this.timeZone,
        required this.dayOfWeek,
        required this.dstActive,
    });

    factory TimeApiModel.fromRawJson(String str) => TimeApiModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory TimeApiModel.fromJson(Map<String, dynamic> json) => TimeApiModel(
        year: json["year"],
        month: json["month"],
        day: json["day"],
        hour: json["hour"],
        minute: json["minute"],
        seconds: json["seconds"],
        milliSeconds: json["milliSeconds"],
        dateTime: DateTime.parse(json["dateTime"]),
        date: json["date"],
        time: json["time"],
        timeZone: json["timeZone"],
        dayOfWeek: json["dayOfWeek"],
        dstActive: json["dstActive"],
    );

    Map<String, dynamic> toJson() => {
        "year": year,
        "month": month,
        "day": day,
        "hour": hour,
        "minute": minute,
        "seconds": seconds,
        "milliSeconds": milliSeconds,
        "dateTime": dateTime.toIso8601String(),
        "date": date,
        "time": time,
        "timeZone": timeZone,
        "dayOfWeek": dayOfWeek,
        "dstActive": dstActive,
    };
}
