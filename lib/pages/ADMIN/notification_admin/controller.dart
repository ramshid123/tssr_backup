import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/services/database_service.dart';
import 'package:intl/intl.dart';
import 'notificationsadmin_index.dart';

class NotificationsAdminController extends GetxController {
  NotificationsAdminController();
  final state = NotificationsAdminState();

  Future createNotification() async {
    try {
      await Get.defaultDialog(
          title: 'New notification',
          content: Form(
            key: state.formKey,
            child: Column(
              children: [
                kNotificationTextField(
                    hintText: 'Title', controller: state.titleCont),
                kNotificationTextField(
                    hintText: 'Message', controller: state.messageCont),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async => await createNotificationFunction(),
                  child: Text('Create'),
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(Get.width, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                )
              ],
            ),
          ));
    } catch (e) {
      print(e);
    }
  }

  String calculateTime(int value) {
    String finalTime = '';
    final time = DateTime.fromMillisecondsSinceEpoch(value);
    final d = DateFormat.MMMEd().format(time);
    final y = DateFormat.y().format(time);
    final t = DateFormat.jm().format(time);
    finalTime = '$d, $y $t';
    return finalTime;
  }

  Future createNotificationFunction() async {
    if (state.formKey.currentState!.validate()) {
      final newDoc = DatabaseService.Notifications.doc();
      await DatabaseService.Notifications.doc(newDoc.id).set({
        'title': state.titleCont.text,
        'message': state.messageCont.text,
        'time_lapse': DateTime.now().millisecondsSinceEpoch,
      });
      Get.back();
      Get.showSnackbar(GetSnackBar(
        title: 'Notification Created',
        message: 'Notification has been created',
        backgroundColor: Colors.green,
        duration: 3.seconds,
      ));
    }
  }

  Future deleteNotification(
      {required QueryDocumentSnapshot<Map<String, dynamic>> doc,
      required BuildContext context}) async {
    try {
      await DatabaseService.Notifications.doc(doc.id).delete();
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          duration: 10.seconds,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Undo the delete',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              IconButton(
                  color: Colors.white,
                  onPressed: () async {
                    await DatabaseService.Notifications.doc(doc.id).set({
                      'title': doc['title'],
                      'message': doc['message'],
                      'time_lapse': doc['time_lapse'],
                    }).then((value) =>
                        ScaffoldMessenger.of(context).hideCurrentSnackBar());
                  },
                  icon: Icon(Icons.undo))
            ],
          ),
        ),
      );
    } catch (e) {
      print(e);
    }
  }
}
