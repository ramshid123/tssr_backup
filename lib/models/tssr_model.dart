// To parse this JSON data, do
//
//     final TssrDataModel = TssrDataModelFromJson(jsonString);

import 'dart:convert';

class TssrDataModel {
    TssrDataModel({
        required this.sheet1,
    });

    List<Sheet1> sheet1;

    factory TssrDataModel.fromRawJson(String str) => TssrDataModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory TssrDataModel.fromJson(Map<String, dynamic> json) => TssrDataModel(
        sheet1: List<Sheet1>.from(json["Sheet1"].map((x) => Sheet1.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "Sheet1": List<dynamic>.from(sheet1.map((x) => x.toJson())),
    };
}

class Sheet1 {
    Sheet1({
        required this.registerNo,
        required this.name,
        required this.course,
        required this.studyCentre,
        required this.duration,
        required this.examDate,
        required this.result,
        required this.grade,
    });

    String registerNo;
    String name;
    String course;
    String studyCentre;
    String duration;
    String examDate;
    String result;
    String grade;

    factory Sheet1.fromRawJson(String str) => Sheet1.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Sheet1.fromJson(Map<String, dynamic> json) => Sheet1(
        registerNo: json["register_no"].toString(),
        name: json["name"].toString(),
        course: json["course"].toString(),
        studyCentre: json["study_centre"].toString(),
        duration: json["duration"].toString(),
        examDate: json["exam_date"].toString(),
        result: json["result"].toString(),
        grade: json["grade"].toString(),
    );

    Map<String, dynamic> toJson() => {
        "register_no": registerNo,
        "name": name,
        "course": course,
        "study_centre": studyCentre,
        "duration": duration,
        "exam_date": examDate,
        "result": result,
        "grade": grade,
    };
}
