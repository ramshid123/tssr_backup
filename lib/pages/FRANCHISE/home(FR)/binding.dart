import 'package:get/get.dart';
import 'homefr_index.dart';


class HomeFrBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<HomeFrController>(HomeFrController());
  }
}
