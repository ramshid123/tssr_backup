import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tssr_ctrl/constants/colors.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/routes/names.dart';

Widget TStoreCard(Map<String, dynamic> doc, bool isMobile) {
  return GestureDetector(
    onTap: () {
      Get.toNamed(AppRouteNames.T_STORE_ITEM_FR, arguments: doc);
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
            width:isMobile? Get.width / 3 - 40: Get.width / 6,
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: AssetImage('assets/book.png'),
                  fit: BoxFit.fill,
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
                    color: Colors.grey[600],
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
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    ),
  );
}
