import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jsaver/jSaver.dart';
import 'pdfviewscreen_index.dart';

class PdfViewScreenController extends GetxController {
  PdfViewScreenController();
  final state = PdfViewScreenState();

  Future saveAsPopup({required Uint8List bytes}) async {
    await Get.defaultDialog(
        title: 'Save As',
        content: Column(
          children: [
            TextFormField(
              controller: state.pdfNameController,
              decoration: InputDecoration(
                hintText: 'File name...',
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                await downloadPdf(
                    bytes: bytes, fileName: state.pdfNameController.text);
                Get.back();
              },
              child: Text('Done'),
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(Get.width, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
          ],
        ));
  }

  Future downloadPdf(
      {required Uint8List bytes, required String fileName}) async {
    await JSaver.instance.saveFromData(
        data: bytes,
        name: '${fileName.isNotEmpty ? fileName : 'TSSR'}.pdf',
        type: JSaverFileType.PDF);
  }
}
