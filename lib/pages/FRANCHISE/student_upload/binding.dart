import 'package:get/get.dart';
import 'studentupload_index.dart';


class StudentUploadBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<StudentUploadController>(StudentUploadController());
  }
}
