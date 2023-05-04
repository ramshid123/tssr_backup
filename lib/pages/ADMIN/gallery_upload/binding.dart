import 'package:get/get.dart';
import 'gallery_index.dart';


class GalleryBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<GalleryController>(GalleryController());
  }
}
