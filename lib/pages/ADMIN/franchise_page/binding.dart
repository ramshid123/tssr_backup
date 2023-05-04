import 'package:get/get.dart';
import 'franchisepage_index.dart';


class FranchisePageBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<FranchisePageController>(FranchisePageController());
  }
}
