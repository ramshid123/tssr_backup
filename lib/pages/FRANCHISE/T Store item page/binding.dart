import 'package:get/get.dart';
import 'tstoreitempage_index.dart';


class TStoreItemPageBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<TStoreItemPageController>(TStoreItemPageController());
  }
}
