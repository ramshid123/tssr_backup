import 'package:get/get.dart';
import 'hallticketpage_index.dart';


class HallTicketPageBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<HallTicketPageController>(HallTicketPageController());
  }
}
