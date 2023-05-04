import 'package:get/get.dart';
import 'tbooks_index.dart';


class TBooksBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<TBooksController>(TBooksController());
  }
}
