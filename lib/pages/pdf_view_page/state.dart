import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:pdfx/pdfx.dart' as pdfx;
import 'package:pdf_render/pdf_render_widgets.dart' as pdf_render;

class PdfViewScreenState {
  final pdfController = pdf_render.PdfViewerController();
  TapDownDetails? doubleTapDetails;

  final pdfNameController = TextEditingController();
}
