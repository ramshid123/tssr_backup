import 'package:get/get.dart';
import 'reportadminpage_index.dart';


class ReportAdminPageBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<ReportAdminPageController>(ReportAdminPageController());
  }
}
