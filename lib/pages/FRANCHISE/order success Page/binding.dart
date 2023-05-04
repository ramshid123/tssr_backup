import 'package:get/get.dart';
import 'ordersuccess_index.dart';


class OrderSuccessBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<OrderSuccessController>(OrderSuccessController());
  }
}
