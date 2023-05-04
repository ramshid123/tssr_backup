import 'package:get/get.dart';
import 'loginpage_index.dart';


class LoginPageBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<LoginPageController>(LoginPageController());
  }
}
