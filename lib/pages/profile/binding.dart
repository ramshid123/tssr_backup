import 'package:get/get.dart';
import 'profile_index.dart';


class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<ProfileController>(ProfileController());
  }
}
