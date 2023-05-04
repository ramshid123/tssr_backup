import 'package:get/get.dart';
import 'tstorepage_index.dart';


class TStorePageBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<TStorePageController>(TStorePageController());
  }
}
