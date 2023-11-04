import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:pdfx/pdfx.dart' as pdfx;
import 'package:pdf_render/pdf_render.dart' as pdf_render;
import 'package:pdf_render/pdf_render_widgets.dart' as pdf_render_widgets;
import 'package:tssr_ctrl/pages/pdf_view_page/controller.dart';

class PdfViewScreenPage extends GetView<PdfViewScreenController> {
  const PdfViewScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () async => controller.saveAsPopup(bytes: Get.arguments),
            icon: Icon(Icons.download),
          ),
        ],
      ),
      body: GestureDetector(
        onDoubleTapDown: (details) =>
            controller.state.doubleTapDetails = details,
        onDoubleTap: () => controller.state.pdfController.ready?.setZoomRatio(
          zoomRatio: controller.state.pdfController.zoomRatio * 1.5,
          center: controller.state.doubleTapDetails!.localPosition,
        ),
        child: LayoutBuilder(builder: (context, c) {
          return Get.width <= 768
              ? pdf_render_widgets.PdfViewer.openData(
                  Get.arguments,
                  viewerController: controller.state.pdfController,
                )
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 200),
                  child: pdf_render_widgets.PdfViewer.openData(
                    Get.arguments,
                    viewerController: controller.state.pdfController,
                  ),
                );
        }),
      ),
    );
  }
}
