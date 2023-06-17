import 'package:get/get.dart';
import 'mycourses_index.dart';


class MyCoursesBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<MyCoursesController>(MyCoursesController());
  }
}
