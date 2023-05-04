import 'package:get/get.dart';
import 'torders_index.dart';


class TOrdersBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<TOrdersController>(TOrdersController());
  }
}
