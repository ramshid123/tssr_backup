// To parse this JSON data, do
//
//     final hallTicketModel = hallTicketModelFromJson(jsonString);

import 'dart:convert';

class HallTicketModel {
    List<Sheet1> sheet1;

    HallTicketModel({
        required this.sheet1,
    });

    factory HallTicketModel.fromRawJson(String str) => HallTicketModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory HallTicketModel.fromJson(Map<String, dynamic> json) => HallTicketModel(
        sheet1: List<Sheet1>.from(json["Sheet1"].map((x) => Sheet1.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "Sheet1": List<dynamic>.from(sheet1.map((x) => x.toJson())),
    };
}

class Sheet1 {
    String admissionNo;
    String name;
    String course;
    String studyCentre;
    String examCentre;
    String examDate;
    String examTime;

    Sheet1({
        required this.admissionNo,
        required this.name,
        required this.course,
        required this.studyCentre,
        required this.examCentre,
        required this.examDate,
        required this.examTime,
    });

    factory Sheet1.fromRawJson(String str) => Sheet1.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Sheet1.fromJson(Map<String, dynamic> json) => Sheet1(
        admissionNo: json["admission_no"].toString(),
        name: json["name"].toString(),
        course: json["course"].toString(),
        studyCentre: json["study_centre"].toString(),
        examCentre: json["exam_centre"].toString(),
        examDate: json["exam_date"].toString(),
        examTime: json["exam_time"].toString(),
    );

    Map<String, dynamic> toJson() => {
        "admission_no": admissionNo,
        "name": name,
        "course": course,
        "study_centre": studyCentre,
        "exam_centre": examCentre,
        "exam_date": examDate,
        "exam_time": examTime,
    };
}
