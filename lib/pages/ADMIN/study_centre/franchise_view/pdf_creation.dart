import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' as wd;
import 'package:get/get.dart';
import 'package:jsaver/jSaver.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:external_path/external_path.dart';
import 'package:tssr_ctrl/pages/ADMIN/report_/controller.dart';
import 'package:tssr_ctrl/services/database_service.dart';
import 'package:flutter/material.dart' as material;

import 'dart:io';

import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:tssr_ctrl/services/excel_service.dart';
import 'package:tssr_ctrl/services/pdf_service.dart';

Future createFranchiseReport(
    {required wd.BuildContext context,
    required List<Map<String, dynamic>> DataList}) async {
  print('initialising pdf creation');
  final format = PdfPageFormat.a4.portrait;
  final doc = pw.Document(pageMode: PdfPageMode.outlines);

  final font1 = await PdfGoogleFonts.openSansRegular();
  final font2 = await PdfGoogleFonts.openSansBold();

  final headerImage = pw.MemoryImage(
    (await rootBundle.load('assets/TSSR_header.png')).buffer.asUint8List(),
  );

  doc.addPage(pw.MultiPage(
    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    maxPages: 100,
    theme: pw.ThemeData.withFont(
      base: font1,
      bold: font2,
    ),
    pageFormat: format.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
    orientation: pw.PageOrientation.portrait,
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    footer: (pw.Context context) {
      return pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
          child: pw.Text('Page ${context.pageNumber} of ${context.pagesCount}',
              style: pw.Theme.of(context).defaultTextStyle.copyWith(
                    color: PdfColors.grey,
                    font: font1,
                  )));
    },
    build: (pw.Context context) => <pw.Widget>[
      pw.Image(headerImage),
      pw.Header(text: 'Study Centre Details'),
      SizedBox(height: 10),
      for (var reportData in DataList) ...[
        SizedBox(height: 10),
        kReportTile(title: 'Centre Name', data: reportData['centre_name']!),
        kReportTile(title: 'Centre Head', data: reportData['centre_head']!),
        kReportTile(
            title: 'Centre Name', data: reportData['head_phone_no'] ?? ''),
        kReportTile(title: 'ATC Code', data: reportData['atc']!),
        kReportTile(title: 'Email', data: reportData['email']!),
        kReportTile(title: 'Password', data: reportData['password']!),
        // kReportTile(title: 'District', data: reportData['district']!),
        kReportTile(
            title: 'Address',
            data:
                '${reportData['place'] ?? ''}, ${reportData['city'] ?? ''}, ${reportData['district'] ?? ''}, ${reportData['pincode'] ?? ''}'),
        kReportTile(title: 'Renewal', data: reportData['renewal']!),
        SizedBox(height: 10),
        Divider(),
      ]
    ],
  ));

  await saveFranchiseReport(doc, 'Franchise Report', context);
}

Future saveFranchiseReport(
    Document doc, String orgName, material.BuildContext context) async {
  if (kIsWeb) {
    final bytes = await doc.save();
    final s = await JSaver.instance.saveFromData(
        data: bytes,
        name: '${orgName.isEmpty ? "All_Centre" : orgName}.pdf',
        type: JSaverFileType.PDF);
  } else {
    var status = await Permission.storage.request();
    if (status.isDenied) {
      Get.defaultDialog(
        title: 'Storage permission required!',
        middleText:
            'The permission for storage is manditory for saving the pdf files to the local storage',
      );
    } else {
      final bytes = await doc.save();
      final dir = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);

      final file = File('$dir/${orgName.isEmpty ? "All_Centre" : orgName}.pdf');
      await file.writeAsBytes(bytes);
      // print('done');
      showSnackBar(
          context: context,
          isError: false,
          title: 'Success',
          subtitle: 'PDF saved to Downloads');
      Get.back();
    }
  }
}

Widget kReportTile({required String title, required String data}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('$title :',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: PdfColors.grey,
          )),
      SizedBox(height: 5),
      Text(data,
          maxLines: 100,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: PdfColors.black,
          )),
      Divider(color: PdfColors.grey),
    ],
  );
}
