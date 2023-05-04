import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
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
      allowedExtensions: ['jpg', 'png','jpge'],
    );
    state.filePath.value =
        result == null ? '' : result.files.single.path.toString();
  }

  Future confirmAndUpload() async {
    state.isLoading.value = true;
    try {
      final s = await StorageService()
          .instance
          .ref()
          .child('gallery/${DateTime.now().millisecondsSinceEpoch}');
      await s.putFile(File(state.filePath.value)).whenComplete(() {
        state.isLoading.value = false;
        state.filePath.value = '';
      });
    } catch (e) {
      print(e);
      state.isLoading.value = false;
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
      print(state.imageList.value);
      // print(state.imageList.value.length);
    } catch (e) {
      print(e);
    } finally {
      state.isLoading.value = false;
    }
  }
}
