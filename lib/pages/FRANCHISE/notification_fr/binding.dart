import 'package:get/get.dart';
import 'notificationsclient_index.dart';


class NotificationsClientBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<NotificationsClientController>(NotificationsClientController());
  }
}
