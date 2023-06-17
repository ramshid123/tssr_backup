import 'dart:typed_data';

import 'package:get/get.dart';

class GalleryState{
  var filePath = ''.obs;
  var isLoading = false.obs;
  Uint8List? bytes;

  var imageList = [].obs;
}
