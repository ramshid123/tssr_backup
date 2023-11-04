import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/services/database_service.dart';
import 'package:intl/intl.dart';
import 'package:tssr_ctrl/services/pdf_service.dart';
import 'package:tssr_ctrl/services/storage_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'notificationsadmin_index.dart';

class NotificationsAdminController extends GetxController {
  NotificationsAdminController();
  final state = NotificationsAdminState();

  Future createNotification(
      {required BuildContext context,
      required NotificationsAdminController controller}) async {
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
                Align(
                  alignment: Alignment.center,
                  child: kPhotoSelectionButton(
                      context: context,
                      buttonText: 'Upload document',
                      compressedFile: controller.state.document_file,
                      controller: controller,
                      file: controller.state.document_path),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async => await createNotificationFunction(),
                  child: Text('Create'),
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(Get.width, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
              ],
            ),
          ));
    } catch (e) {
      print(e);
    }
  }

  Future<Uint8List?> selectPhoto(
      {required Rx<PlatformFile> file,
      required BuildContext context,
      required Rx<Uint8List> fileBytes}) async {
    FilePickerResult? filePicker;
    if (kIsWeb) {
      filePicker = await FilePickerWeb.platform.pickFiles(
        allowMultiple: false,
        dialogTitle: 'Select file',
      );
    } else {
      filePicker = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        dialogTitle: 'Select file',
      );
    }
    if (filePicker != null) {
      if (kIsWeb) {
        file.value = filePicker.files.first;
        fileBytes.value = filePicker.files.first.bytes!;
      } else {
        file.value = filePicker.files.first;
        fileBytes.value = filePicker.files.first.bytes!;
      }
    }
  }

  Future downloadDocument(String url) async {
    final dl_url = Uri.parse(url);
    await launchUrl(
      dl_url,
      mode: LaunchMode.externalApplication,
    );
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
      final downloadUrl = state.document_path.value.name.isNotEmpty
          ? await uploadDocument()
          : 'none';
      final newDoc = DatabaseService.Notifications.doc();
      await DatabaseService.Notifications.doc(newDoc.id).set({
        'title': state.titleCont.text,
        'message': state.messageCont.text,
        'time_lapse': DateTime.now().millisecondsSinceEpoch,
        'document_url': downloadUrl ?? 'none',
      });
      Get.back();
      Get.showSnackbar(GetSnackBar(
        title: 'Notification Created',
        message: 'Notification has been created',
        backgroundColor: Colors.green,
        duration: 3.seconds,
      ));
      state.titleCont.clear();
      state.messageCont.clear();
      state.document_file.value = Uint8List(0);
      state.document_path.value = PlatformFile(name: '', size: 0);
    }
  }

  Future<String?> uploadDocument() async {
    try {
      final ref = await StorageService()
          .instance
          .ref()
          .child('documents')
          .child(
              '${DateTime.now().millisecondsSinceEpoch}_${state.document_path.value.name}')
          .putData(state.document_file.value);
      return await ref.ref.getDownloadURL();
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future deleteDocument(String url) async {
    try {
      await StorageService().instance.refFromURL(url).delete();
    } catch (e) {
      print(e);
    }
  }

  Future deleteNotification(
      {required QueryDocumentSnapshot<Map<String, dynamic>> doc,
      required BuildContext context}) async {
    try {
      doc.data()['document_url'] != 'none'
          ? deleteDocument(doc.data()['document_url'])
          : null;
      await DatabaseService.Notifications.doc(doc.id).delete();
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    } catch (e) {
      print(e);
    }
  }
}
