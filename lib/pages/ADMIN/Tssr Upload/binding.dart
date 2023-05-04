import 'package:get/get.dart';
import 'tssruploadpage_index.dart';


class TssrUploadPageBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<TssrUploadPageController>(TssrUploadPageController());
  }
}
