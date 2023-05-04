import 'package:get/get.dart';
import 'franchiseupload_index.dart';


class FranchiseUploadBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<FranchiseUploadController>(FranchiseUploadController());
  }
}
