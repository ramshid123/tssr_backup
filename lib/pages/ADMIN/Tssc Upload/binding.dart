import 'package:get/get.dart';
import 'tsscuploadpage_index.dart';


class TsscUploadPageBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<TsscUploadPageController>(TsscUploadPageController());
  }
}
