import 'package:file_picker/file_picker.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/pages/ADMIN/notification_admin/notificationsadmin_index.dart';
import 'package:tssr_ctrl/services/database_service.dart';
import 'package:tssr_ctrl/widgets/app_bar.dart';

class NotificationsAdminPage extends GetView<NotificationsAdminController> {
  const NotificationsAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      bool isMobile = Get.width <= 768 ? true : false;
      return Scaffold(
        backgroundColor: Colors.grey[100],
        // appBar: isMobile ? CustomAppBar('Notifications') : null,
        appBar: CustomAppBar('Notifications'),
        floatingActionButton: FloatingActionButton.extended(
          label: Text('Create'),
          icon: Icon(Icons.add),
          onPressed: () async => controller.createNotification(
              context: context, controller: controller),
        ),
        body: Obx(() {
          return FirestoreListView(
            physics: BouncingScrollPhysics(),
            query: controller.state.query.value,
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
              final time = controller.calculateTime(
                  int.parse(doc.data()['time_lapse'].toString()));
              return GestureDetector(
                onTap: () async {
                  await Get.defaultDialog(
                      title: doc.data()['title'],
                      middleText: doc.data()['message'],
                      actions: [
                        doc.data()['document_url'] != 'none' &&
                                doc.data()['document_url'] != null
                            ? ElevatedButton.icon(
                                onPressed: () async =>
                                    await controller.downloadDocument(
                                        doc.data()['document_url']),
                                label: Text('Download document'),
                                icon: Icon(Icons.download, color: Colors.white),
                              )
                            : const SizedBox(),
                      ]);
                },
                child: Dismissible(
                  key: Key(doc.id),
                  background: Container(
                    color: Colors.red,
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete,
                          size: 50,
                          color: Colors.white,
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                  onDismissed: (val) async =>
                      controller.deleteNotification(doc: doc, context: context),
                  direction: DismissDirection.startToEnd,
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
                ),
              );
            },
            pageSize: 5,
          );
        }),
      );
    });
  }
}

Widget kNotificationTextField(
    {required TextEditingController controller, required String hintText}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: hintText,
      ),
      validator: (val) {
        if (val!.isEmpty) {
          return 'Required field';
        }
        return null;
      },
    ),
  );
}

Widget kPhotoSelectionButton(
    {required Rx<PlatformFile> file,
    required String buttonText,
    required BuildContext context,
    required NotificationsAdminController controller,
    required Rx<Uint8List> compressedFile}) {
  return Obx(() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: () async {
            await controller.selectPhoto(
                file: file, fileBytes: compressedFile, context: context);
          },
          label: Text(buttonText),
          icon: Icon(
            Icons.upload,
            color: Colors.white,
          ),
        ),
        SizedBox(width: 10),
        Text(file.value.name.toString()),
      ],
    );
  });
}
