import 'package:get/get.dart';
import 'homepage_index.dart';


class HomePageBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<HomePageController>(HomePageController());
  }
}
