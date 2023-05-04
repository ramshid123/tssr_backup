// To parse this JSON data, do
//
//     final tsscDataModel = tsscDataModelFromJson(jsonString);

import 'dart:convert';

class TsscDataModel {
    List<Sheet1> sheet1;

    TsscDataModel({
        required this.sheet1,
    });

    factory TsscDataModel.fromRawJson(String str) => TsscDataModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory TsscDataModel.fromJson(Map<String, dynamic> json) => TsscDataModel(
        sheet1: List<Sheet1>.from(json["Sheet1"].map((x) => Sheet1.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "Sheet1": List<dynamic>.from(sheet1.map((x) => x.toJson())),
    };
}

class Sheet1 {
    String regNo;
    String name;
    String skill;
    String skillCentre;
    String examDate;

    Sheet1({
        required this.regNo,
        required this.name,
        required this.skill,
        required this.skillCentre,
        required this.examDate,
    });

    factory Sheet1.fromRawJson(String str) => Sheet1.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Sheet1.fromJson(Map<String, dynamic> json) => Sheet1(
        regNo: json["reg_no"],
        name: json["name"],
        skill: json["skill"],
        skillCentre: json["skill_centre"],
        examDate: json["exam_date"],
    );

    Map<String, dynamic> toJson() => {
        "reg_no": regNo,
        "name": name,
        "skill": skill,
        "skill_centre": skillCentre,
        "exam_date": examDate,
    };
}
