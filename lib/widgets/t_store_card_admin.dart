import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tssr_ctrl/constants/colors.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/routes/names.dart';
import 'package:tssr_ctrl/widgets/tssr.dart';

Widget TStoreCardAdmin(Map<String, dynamic> doc) {
  return GestureDetector(
    onTap: () {
      Get.bottomSheet(Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            BottomSheetItem('Book', doc['name']),
            BottomSheetItem('Course', doc['course']),
            BottomSheetItem('Description', doc['desc']),
            BottomSheetItem('Price', doc['price']),
          ],
        ),
      ));
    },
    child: Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      width: Get.width,
      decoration: BoxDecoration(
        color: ColorConstants.purple_clr.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 100,
            width: Get.width / 3 - 40,
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: AssetImage('assets/book.png'),
                  fit: BoxFit.cover,
                )),
          ),
          SizedBox(width: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: Get.width * 0.6,
                child: Text(
                  doc['name'],
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: Get.width * 0.6,
                child: Text(
                  doc['course'],
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 17,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(
                    width: Get.width / 3,
                    child: Text(
                      doc['price'],
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: 60),
                  Icon(Icons.navigate_next_outlined)
                ],
              ),
            ],
          )
        ],
      ),
    ),
  );
}
