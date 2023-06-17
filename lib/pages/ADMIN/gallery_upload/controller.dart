import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'gallery_index.dart';
import 'package:file_picker/file_picker.dart';
import 'package:tssr_ctrl/services/storage_service.dart';

class GalleryController extends GetxController {
  GalleryController();
  final state = GalleryState();

  Future getFileAndSetPath() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpge'],
    );
    if (kIsWeb) {
      state.bytes = result!.files.first.bytes;
      state.filePath.value = 'abcd';
    } else {
      state.filePath.value =
          result == null ? '' : result.files.single.path.toString();
    }
  }

  Future confirmAndUpload() async {
    state.isLoading.value = true;
    try {
      final s = await StorageService()
          .instance
          .ref()
          .child('gallery/${DateTime.now().millisecondsSinceEpoch}');
      if (kIsWeb) {
        await s.putData(state.bytes!,SettableMetadata(contentType: 'image/png'));
      } else {
        await s.putFile(File(state.filePath.value)).whenComplete(() {
          state.isLoading.value = false;
          state.filePath.value = '';
        });
      }
    } catch (e) {
      print(e);
    } finally {
      state.isLoading.value = false;
    }
  }

  Future deleteImage(String ref) async {
    try {
      Get.defaultDialog(
          title: 'Delete',
          onConfirm: () async =>
              await StorageService().instance.refFromURL(ref).delete().then(
                    (value) => Get.showSnackbar(
                      GetSnackBar(
                        title: 'Deleted',
                        message: 'Photo deleted Successfully',
                        backgroundColor: Colors.green,
                        duration: 3.seconds,
                      ),
                    ),
                  ),
          onCancel: () {},
          middleText: 'Do you want to delete this photo from gallery?');
    } catch (e) {
      print(e);
    }
  }

  Future getImageList() async {
    state.isLoading.value = true;
    try {
      final n = await StorageService().instance.ref('gallery/').listAll();
      final list = [];
      for (var i in n.items) {
        list.add(await i.getDownloadURL());
        // print(await i.getDownloadURL());
      }
      state.imageList.value = list;
      // print(state.imageList.value.length);
    } catch (e) {
      print(e);
    } finally {
      state.isLoading.value = false;
    }
  }
}
