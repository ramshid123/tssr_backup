import 'package:get/get.dart';
import 'hallticketupload_index.dart';


class HallTicketUploadBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<HallTicketUploadController>(HallTicketUploadController());
  }
}
