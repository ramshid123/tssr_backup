import 'package:get/get.dart';
import 'resultview_index.dart';


class ResultViewBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<ResultViewController>(ResultViewController());
  }
}
