import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/pages/ADMIN/notification_admin/notificationsadmin_index.dart';
import 'package:tssr_ctrl/services/database_service.dart';
import 'package:tssr_ctrl/widgets/app_bar.dart';
import 'package:intl/intl.dart';

class NotificationsClientPage extends StatelessWidget {
  const NotificationsClientPage({super.key});

  String calculateTime(int value) {
    String finalTime = '';
    final time = DateTime.fromMillisecondsSinceEpoch(value);
    final d = DateFormat.MMMEd().format(time);
    final y = DateFormat.y().format(time);
    final t = DateFormat.jm().format(time);
    finalTime = '$d, $y $t';
    return finalTime;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      bool isMobile = Get.width <= 768 ? true : false;
      return Scaffold(
          backgroundColor: Colors.grey[100],
          // appBar: isMobile ? CustomAppBar('Notifications') : null,
          appBar: CustomAppBar('Notifications'),
          body: FirestoreListView(
            physics: BouncingScrollPhysics(),
            query: DatabaseService.Notifications.orderBy('time_lapse',
                descending: true),
            emptyBuilder: (context) => Center(
              child: Text(
                'No notifications',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            itemBuilder: (context, doc) {
              final time = calculateTime(
                  int.parse(doc.data()['time_lapse'].toString()));
              return GestureDetector(
                onTap: () async {
                  await Get.defaultDialog(
                    title: doc.data()['title'],
                    middleText: doc.data()['message'],
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  padding: EdgeInsets.all(5),
                  color: Colors.white,
                  width: Get.width,
                  child: Row(
                    children: [
                      Icon(
                        Icons.message,
                        size: 50,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 10),
                      SizedBox(
                        width: Get.width - 90,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              doc.data()['title'],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(height: 10),
                            Text(
                              doc.data()['message'],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                time,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
            pageSize: 5,
          ));
    });
  }
}
