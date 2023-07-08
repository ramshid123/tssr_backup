// To parse this JSON data, do
//
//     final resultModel = resultModelFromJson(jsonString);

import 'dart:convert';

class ResultModel {
  List<Sheet1> sheet1;

  ResultModel({
    required this.sheet1,
  });

  factory ResultModel.fromRawJson(String str) =>
      ResultModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ResultModel.fromJson(Map<String, dynamic> json) => ResultModel(
        sheet1:
            List<Sheet1>.from(json["Sheet1"].map((x) => Sheet1.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Sheet1": List<dynamic>.from(sheet1.map((x) => x.toJson())),
      };
}

class Sheet1 {
  String regNo;
  String name;
  String course;
  String studyCentre;
  String examCentre;
  String duration;
  String examDate;
  String result;
  String grade;

  Sheet1({
    required this.regNo,
    required this.name,
    required this.course,
    required this.studyCentre,
    required this.examCentre,
    required this.duration,
    required this.examDate,
    required this.result,
    required this.grade,
  });

  factory Sheet1.fromRawJson(String str) => Sheet1.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Sheet1.fromJson(Map<String, dynamic> json) => Sheet1(
        regNo: json["reg_no"].toString(),
        name: json["name"].toString(),
        course: json["course"].toString(),
        studyCentre: json["study_centre"].toString(),
        examCentre: json["exam_centre"].toString(),
        duration: json["duration"].toString(),
        examDate: json["exam_date"].toString(),
        result: json["result"].toString(),
        grade: json["grade"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "reg_no": regNo,
        "name": name,
        "course": course,
        "study_centre": studyCentre,
        "exam_centre": examCentre,
        "duration": duration,
        "exam_date": examDate,
        "result": result,
        "grade": grade,
      };
}
