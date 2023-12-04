import 'package:get/get.dart';
import 'atcrequestspage_index.dart';


class AtcRequestsPageBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<AtcRequestsPageController>(AtcRequestsPageController());
  }
}
