import 'package:get/get.dart';
import 'courses_index.dart';


class CoursesBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<CoursesController>(CoursesController());
  }
}
