import 'package:get/get.dart';
import 'studentpage_index.dart';


class StudentPageBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<StudentPageController>(StudentPageController());
  }
}
