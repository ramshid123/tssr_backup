import 'package:get/get.dart';
import 'testpage_index.dart';


class TestPageBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<TestPageController>(TestPageController());
  }
}
