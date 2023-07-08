import 'package:get/get.dart';
import 'notificationsadmin_index.dart';


class NotificationsAdminBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<NotificationsAdminController>(NotificationsAdminController());
  }
}
