import 'package:get/get.dart';
import 'reportfranchise_index.dart';


class ReportFranchiseBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<ReportFranchiseController>(ReportFranchiseController());
  }
}
