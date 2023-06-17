import 'package:get/get.dart';
import 'resultupload_index.dart';


class ResultUploadBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<ResultUploadController>(ResultUploadController());
  }
}
