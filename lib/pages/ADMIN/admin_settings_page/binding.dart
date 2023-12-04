import 'package:get/get.dart';
import 'adminsettings_index.dart';


class AdminSettingsBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<AdminSettingsController>(AdminSettingsController());
  }
}
