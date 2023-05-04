import 'package:get/get.dart';
import 'tsscpage_index.dart';


class TsscPageBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<TsscPageController>(TsscPageController());
  }
}
