// To parse this JSON data, do
//
//     final studentDetailModel = studentDetailModelFromJson(jsonString);

import 'dart:convert';
import 'package:intl/intl.dart';

class StudentDetailModel {
  List<Sheet1> sheet1;

  StudentDetailModel({
    required this.sheet1,
  });

  factory StudentDetailModel.fromRawJson(String str) =>
      StudentDetailModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StudentDetailModel.fromJson(Map<String, dynamic> json) =>
      StudentDetailModel(
        sheet1:
            List<Sheet1>.from(json["Sheet1"].map((x) => Sheet1.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Sheet1": List<dynamic>.from(sheet1.map((x) => x.toJson())),
      };
}

class Sheet1 {
  String name;
  String dob;
  String parentName;
  String age;
  String gender;
  String aadhaar;
  String address;
  String pincode;
  String mobileNo;
  String email;
  String dateOfAdmission;
  String courseBatch;
  String course;
  String district;

  Sheet1({
    required this.name,
    required this.dob,
    required this.parentName,
    required this.age,
    required this.gender,
    required this.aadhaar,
    required this.address,
    required this.pincode,
    required this.mobileNo,
    required this.email,
    required this.dateOfAdmission,
    required this.courseBatch,
    required this.course,
    required this.district,
  });

  factory Sheet1.fromRawJson(String str) => Sheet1.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Sheet1.fromJson(Map<String, dynamic> json) => Sheet1(
        name: json["name"].toString(),
        // dob: json["dob"].toString(),
        dob: DateTime.tryParse(json['dob']) != null
            ? DateFormat('dd/MM/yyyy').format(DateTime.parse(json['dob']))
            : json['dob'],
        parentName: json["parent_name"].toString(),
        age: json["age"].toString(),
        gender: json["gender"].toString(),
        aadhaar: json["aadhaar"].toString(),
        address: json["address"].toString(),
        pincode: json["pincode"].toString(),
        mobileNo: json["mobile_no"].toString(),
        email: json["email"].toString(),
        // dateOfAdmission: json["date_of_admission"].toString(),
        dateOfAdmission: DateTime.tryParse(json['dob']) != null
            ? DateFormat('dd/MM/yyyy')
                .format(DateTime.parse(json['date_of_admission']))
            : json['date_of_admission'],
        courseBatch: json["course_batch"].toString(),
        course: json["course"].toString(),
        district: json["district"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "dob": dob,
        "parent_name": parentName,
        "age": age,
        "gender": gender,
        "aadhaar": aadhaar,
        "address": address,
        "pincode": pincode,
        "mobile_no": mobileNo,
        "email": email,
        "date_of_admission": dateOfAdmission,
        "course_batch": courseBatch,
        "course": course,
        "district": district,
      };
}
