import 'package:get/get.dart';
import 'tssrpage_index.dart';


class TssrPageBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<TssrPageController>(TssrPageController());
  }
}
