// To parse this JSON data, do
//
//     final studentDetailModel = studentDetailModelFromJson(jsonString);

import 'dart:convert';

class StudentDetailModel {
    List<Sheet1> sheet1;

    StudentDetailModel({
        required this.sheet1,
    });

    factory StudentDetailModel.fromRawJson(String str) => StudentDetailModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory StudentDetailModel.fromJson(Map<String, dynamic> json) => StudentDetailModel(
        sheet1: List<Sheet1>.from(json["Sheet1"].map((x) => Sheet1.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "Sheet1": List<dynamic>.from(sheet1.map((x) => x.toJson())),
    };
}

class Sheet1 {
    String regNo;
    String name;
    String dob;
    String age;
    String gender;
    String aadhaar;
    String address;
    String pincode;
    String mobileNo;
    String email;
    String dateOfAdmission;
    String dateOfCourseStart;
    String course;
    String district;

    Sheet1({
        required this.regNo,
        required this.name,
        required this.dob,
        required this.age,
        required this.gender,
        required this.aadhaar,
        required this.address,
        required this.pincode,
        required this.mobileNo,
        required this.email,
        required this.dateOfAdmission,
        required this.dateOfCourseStart,
        required this.course,
        required this.district,
    });

    factory Sheet1.fromRawJson(String str) => Sheet1.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Sheet1.fromJson(Map<String, dynamic> json) => Sheet1(
        regNo: json["reg_no"],
        name: json["name"],
        dob: json["dob"],
        age: json["age"],
        gender: json["gender"],
        aadhaar: json["aadhaar"],
        address: json["address"],
        pincode: json["pincode"],
        mobileNo: json["mobile_no"],
        email: json["email"],
        dateOfAdmission: json["date_of_admission"],
        dateOfCourseStart: json["date_of_course_start"],
        course: json["course"],
        district: json["district"],
    );

    Map<String, dynamic> toJson() => {
        "reg_no": regNo,
        "name": name,
        "dob": dob,
        "age": age,
        "gender": gender,
        "aadhaar": aadhaar,
        "address": address,
        "pincode": pincode,
        "mobile_no": mobileNo,
        "email": email,
        "date_of_admission": dateOfAdmission,
        "date_of_course_start": dateOfCourseStart,
        "course": course,
        "district": district,
    };
}
