import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/constants/colors.dart';
import 'package:intl/intl.dart';
import 'package:tssr_ctrl/pages/ADMIN/T%20Store(admin)/orders/controller.dart';
import 'package:tssr_ctrl/widgets/tssc.dart';

Widget TOrderCard(Map<String, dynamic> info, TOrdersController controller) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    width: Get.width,
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
    child: Column(
      children: [
        Container(
          padding: EdgeInsets.all(5),
          width: Get.width,
          decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10))),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: ColorConstants.blachish_clr,
                child: Icon(Icons.playlist_add_check_circle_outlined),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: Get.width * 0.6,
                    child: Text(
                      info['buyer_name'],
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(DateFormat.yMMMd().format(info['date'].toDate())),
                  SizedBox(height: 5),
                  Text(DateFormat.jm().format(info['date'].toDate())),
                ],
              )
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          color: Colors.white,
          child: Column(
            children: [
              singeItem('Item', info['book']),
              singeItem('Centre Head', info['buyer_head']),
              singeItem('Place', info['buyer_place']),
              SizedBox(height: 5),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  info['total'].toString(),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(builder: (context) {
                    return ElevatedButton(
                      onPressed: () {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (context) => bottomSheet(info));
                      },
                      child: Text('View'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: ColorConstants.purple_clr,
                        side: BorderSide(
                          color: ColorConstants.purple_clr,
                          width: 2,
                        ),
                      ),
                    );
                  }),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Cancel'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                  SizedBox(width: 5),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Accept'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget singeItem(String title, String info) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 3),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(
          width: Get.width * 0.66,
          child: Text(
            info,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget bottomSheet(Map<String, dynamic> info) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        padding:
            EdgeInsets.symmetric(horizontal: Get.width / 2 - 50, vertical: 10),
        height: 30,
        width: Get.width,
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
              color: ColorConstants.blachish_clr,
              borderRadius: BorderRadius.circular(20)),
        ),
      ),
      SizedBox(
        height: Get.height - 150,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                color: Colors.blue[50],
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: ColorConstants.blachish_clr,
                      child: Icon(Icons.playlist_add_check_circle_outlined),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: Get.width - 100,
                          child: Text(
                            info['buyer_name'],
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.email,
                            size: 30, color: ColorConstants.purple_clr),
                        SizedBox(width: 20),
                        SizedBox(
                          width: Get.width - 100,
                          child: Text(
                            info['buyer_email'],
                            style: TextStyle(fontSize: 17),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.place,
                            size: 30, color: ColorConstants.purple_clr),
                        SizedBox(width: 20),
                        SizedBox(
                          width: Get.width - 100,
                          child: Text(
                            info['buyer_place'],
                            style: TextStyle(fontSize: 17),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.format_color_text_rounded,
                            size: 30, color: ColorConstants.purple_clr),
                        SizedBox(width: 20),
                        SizedBox(
                          width: Get.width - 100,
                          child: Text(
                            info['buyer_atc'],
                            style: TextStyle(fontSize: 17),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.person,
                            size: 30, color: ColorConstants.purple_clr),
                        SizedBox(width: 20),
                        SizedBox(
                          width: Get.width - 100,
                          child: Text(
                            info['buyer_head'],
                            style: TextStyle(fontSize: 17),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.date_range,
                            size: 30, color: ColorConstants.purple_clr),
                        SizedBox(width: 20),
                        SizedBox(
                          width: Get.width - 100,
                          child: Text(
                            "${DateFormat.yMMMd().format(info['date'].toDate())} - ${DateFormat.jm().format(info['date'].toDate())}",
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    BottomSheetItem('Item', info['book']),
                    BottomSheetItem('Course', info['course']),
                    BottomSheetItem('Single', info['single']),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Qty : ${info['quantity']}',
                          style: TextStyle(
                            fontSize: 21,
                          ),
                        ),
                        Spacer(),
                        // SizedBox(width: 10),
                        Text(
                          '\$${info['total']}',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 20),
                      ],
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Cancel'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, fixedSize: Size(150, 40)),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Accept'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        fixedSize: Size(150, 40)),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    ],
  );
}
