import 'package:get/get.dart';
import 'pdfviewscreen_index.dart';


class PdfViewScreenBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<PdfViewScreenController>(PdfViewScreenController());
  }
}
