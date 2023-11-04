import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:tssr_ctrl/routes/names.dart';
import 'package:tssr_ctrl/services/database_service.dart';
import 'package:flutter/material.dart' as material;
// import 'package:pdfx/pdfx.dart' as pdfx;

import 'dart:io';

import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:tssr_ctrl/services/excel_service.dart';

class PdfApi {
  Future generateDocument({
    required String orgName,
    required wd.BuildContext context,
    required controller,
    required bool isPPTC,
    required pageMode pgMode,
    required String course,
    required GetDataMode dataMode,
    required OutputFormat outputFormat,
  }) async {
    try {
      controller.state.isLoading.value = true;
      controller.update();
      final isConnected = await DatabaseService.checkInternetConnection();
      if (isConnected) {
        // final dataList = isPPTC
        //     ? await getDataFromDBForPPTC(orgName: orgName, dataMode: dataMode)
        //     : await getDataFromDB(
        //         orgName: orgName, dataMode: dataMode, course: course);
        final dataList = await getDataFromDB(
            orgName: orgName, dataMode: dataMode, course: course);
        if (outputFormat == OutputFormat.pdf) {
          final doc = await createDocument(dataList, orgName, pgMode, dataMode);
          await saveDocument(doc, orgName, context);
        } else {
          ExcelService().createExcel(
              fileName: orgName,
              context: context,
              titles: ['Reg No', 'Name', 'Course', 'Study Centre'],
              fields: ['reg_no', 'st_name', 'course', 'study_centre'],
              groupedMap: dataList);
        }
      } else {
        Get.back();

        showSnackBar(
            context: context,
            isError: true,
            title: 'Network Error',
            subtitle: 'No stable internet connection detected');
      }
    } catch (e) {
      print(e);

      Get.back();

      showSnackBar(
          context: context,
          isError: true,
          title: 'Error',
          subtitle: 'Something went wrong');
    } finally {
      controller.state.isLoading.value = false;
      controller.update();
    }
  }

  Future saveDocument(
      Document doc, String orgName, material.BuildContext context) async {
    if (kIsWeb) {
      final bytes = await doc.save();
      await Get.toNamed(AppRouteNames.PDF_VIEW_SCREEN, arguments: bytes);
      // final pdfViewController =
      // pdfx.PdfController(document: pdfx.PdfDocument.openData(bytes));
      //  await  Get.toNamed(AppRouteNames.PDF_VIEW_SCREEN, arguments: pdfViewController);
      ////////////////////////////////////////
      // final s = await JSaver.instance.saveFromData(
      //     data: bytes,
      //     name: '${orgName.isEmpty ? "All_Centre" : orgName}.pdf',
      //     type: JSaverFileType.PDF);
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

        final file =
            File('${dir}/${orgName.isEmpty ? "All_Centre" : orgName}.pdf');
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

  Future getDataFromDB(
      {required String orgName,
      required GetDataMode dataMode,
      required String course}) async {
    final snapshot = orgName.isEmpty
        ? await DatabaseService.StudentDetailsCollection.where('course',
                isEqualTo: course)
            // .orderBy('course')
            .orderBy('st_name')
            .get()
        : await DatabaseService.StudentDetailsCollection.where('study_centre',
                isEqualTo: orgName)
            .where('course', isEqualTo: course)
            // .orderBy('course')
            .orderBy('st_name')
            .get();
    final dataList = snapshot.docs;
    // final foo = dataList.
    return sortAsStudyCentre(dataList);
    // return dataList;
  }

  Future getDataFromDBForPPTC({
    required String orgName,
    required GetDataMode dataMode,
  }) async {
    final snapshot = orgName.isEmpty
        ? await DatabaseService.StudentDetailsCollection.where('course',
                isEqualTo: 'PRE PRIMARY TTC')
            .orderBy('study_centre')
            .orderBy('st_name')
            .get()
        : await DatabaseService.StudentDetailsCollection.where('study_centre',
                isEqualTo: orgName)
            .where('course', isEqualTo: 'PRE PRIMARY TTC')
            .orderBy('st_name')
            .get();
    final dataList = snapshot.docs;
    return sortAsStudyCentre(dataList);
    // return dataList;
  }

  Map<dynamic, dynamic> sortAsStudyCentre(var dataList) {
    Map groupedMap = {};

    for (var item in dataList) {
      final studyCentre = item.data()['study_centre'];
      if (!groupedMap.containsKey(studyCentre)) {
        groupedMap[studyCentre] = [];
      }

      groupedMap[studyCentre].add(item);
    }
    return groupedMap;
  }

  Future createDocument(Map groupedMap, String orgName, pageMode pgMode,
      GetDataMode dtMode) async {
    final format = pgMode == pageMode.landscape
        ? PdfPageFormat.a4.landscape
        : PdfPageFormat.a4.portrait;
    final doc = pw.Document(pageMode: PdfPageMode.outlines);

    final font1 = await PdfGoogleFonts.openSansRegular();
    final font2 = await PdfGoogleFonts.openSansBold();

    final headerImage = pw.MemoryImage(
      (await rootBundle.load('assets/TSSR_header.png')).buffer.asUint8List(),
    );

    doc.addPage(pw.MultiPage(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        maxPages: 100,
        theme: pw.ThemeData.withFont(
          base: font1,
          bold: font2,
        ),
        pageFormat: format.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
        orientation: pgMode == pageMode.landscape
            ? pw.PageOrientation.landscape
            : pw.PageOrientation.portrait,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        footer: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child:
                  pw.Text('Page ${context.pageNumber} of ${context.pagesCount}',
                      style: pw.Theme.of(context).defaultTextStyle.copyWith(
                            color: PdfColors.grey,
                            font: font1,
                          )));
        },
        build: (pw.Context context) => <pw.Widget>[
              // pw.Header(text: 'TSSR Council', level: 1),
              pw.Padding(
                padding: pw.EdgeInsets.symmetric(horizontal: 10),
                child: pw.Image(headerImage),
              ),
              pw.SizedBox(height: 5),
              orgName.isEmpty
                  ? pw.Header(
                      text: 'All centre details',
                      padding: pw.EdgeInsets.symmetric(horizontal: 5),
                      decoration: pw.BoxDecoration(
                          shape: pw.BoxShape.rectangle,
                          border: pw.Border.all(color: PdfColors.black)))
                  : pw.SizedBox(),

              // pw.Header(
              //     text:
              //         'Centre : ${orgName.isEmpty ? "All Centres" : orgName}'),

              /////////////Student Details

              if (dtMode == GetDataMode.studentDetails) ...[
                pw.Divider(),
                pw.Header(text: 'STUDENTS REGISTRATION DETAILS', level: 4),
                pw.Divider(),
                pw.Header(
                    text:
                        'TSSR COUNCIL ${groupedMap[groupedMap.entries.first.key].first['course']} COURSE (Year :        ) ',
                    level: 5),
                pw.Divider(),
                for (var entry in groupedMap.entries) ...[
                  pw.Header(text: 'Centre : ${entry.key}'),
                  StudentDataHeader(font1),
                  for (int i = 0; i < groupedMap[entry.key].length; i += 100)
                    StudentsDataTable(font1, groupedMap[entry.key], i, i + 100),
                ],
              ],

              /////////////Attendence Register

              if (dtMode == GetDataMode.attendanceRegister) ...[
                pw.Divider(),
                pw.Header(text: 'ATTENDANCE REGISTER', level: 4),
                pw.Divider(),
                pw.Header(
                    text:
                        'TSSR COUNCIL ${groupedMap[groupedMap.entries.first.key].first['course']} COURSE (Year :        ) ',
                    level: 5),
                pw.Divider(),
                for (var entry in groupedMap.entries) ...[
                  pw.Header(text: 'Centre : ${entry.key}'),
                  AttendenceRegisterHeader(font1),
                  for (int i = 0; i < groupedMap[entry.key].length; i += 100)
                    AttendenceRegisterTable(
                        font1, groupedMap[entry.key], i, i + 100),
                ],
              ],

              /////////////Camp Report
              if (dtMode == GetDataMode.pptcCamp) ...[
                pw.Divider(),
                pw.Header(text: 'Reports', level: 4),
                pw.Divider(),
                pw.Header(
                    text:
                        'TSSR COUNCIL ${groupedMap[groupedMap.entries.first.key].first['course']} COURSE (Year :        ) ',
                    level: 5),
                pw.Divider(),
                for (var entry in groupedMap.entries) ...[
                  pw.Header(text: 'Centre : ${entry.key}'),
                  CampReportHeader(font1),
                  for (int i = 0; i < groupedMap[entry.key].length; i += 100)
                    CampReportTable(font1, groupedMap[entry.key], i, i + 100),
                ],
              ],

              /////////////Class Test
              if (dtMode == GetDataMode.pptcClassTest) ...[
                pw.Divider(),
                pw.Header(text: 'CLASS TEST MARKSHEET', level: 4),
                pw.Divider(),
                pw.Header(
                    text:
                        'TSSR COUNCIL ${groupedMap[groupedMap.entries.first.key].first['course']} COURSE (Year :        ) ',
                    level: 5),
                pw.Divider(),
                for (var entry in groupedMap.entries) ...[
                  pw.Header(text: 'Centre : ${entry.key}'),
                  ClassTestHeader(font1),
                  for (int i = 0; i < groupedMap[entry.key].length; i += 100)
                    ClassTestTable(font1, groupedMap[entry.key], i, i + 100),
                ]
              ],

              /////////////Commision
              if (dtMode == GetDataMode.pptcCommision) ...[
                pw.Divider(),
                pw.Header(text: 'COMMISSION', level: 4),
                pw.Divider(),
                pw.Header(
                    text:
                        'TSSR COUNCIL ${groupedMap[groupedMap.entries.first.key].first['course']} COURSE (Year :        ) ',
                    level: 5),
                pw.Divider(),
                for (var entry in groupedMap.entries) ...[
                  pw.Header(text: 'Centre : ${entry.key}'),
                  CommisionHeader(font1),
                  for (int i = 0; i < groupedMap[entry.key].length; i += 100)
                    CommisionTable(font1, groupedMap[entry.key], i, i + 100),
                ]
              ],

              /////////////Craft Report
              if (dtMode == GetDataMode.pptcCraft) ...[
                pw.Divider(),
                pw.Header(text: 'Craft Marksheet', level: 4),
                pw.Divider(),
                pw.Header(
                    text:
                        'TSSR COUNCIL ${groupedMap[groupedMap.entries.first.key].first['course']} COURSE (Year :        ) ',
                    level: 5),
                pw.Divider(),
                for (var entry in groupedMap.entries) ...[
                  pw.Header(text: 'Centre : ${entry.key}'),
                  CraftReportHeader(font1),
                  for (int i = 0; i < groupedMap[entry.key].length; i += 100)
                    CraftReportTable(font1, groupedMap[entry.key], i, i + 100),
                ]
              ],

              /////////////Fest Report
              if (dtMode == GetDataMode.pptcFest) ...[
                pw.Divider(),
                pw.Header(text: 'Fest Marksheet', level: 4),
                pw.Divider(),
                pw.Header(
                    text:
                        'TSSR COUNCIL ${groupedMap[groupedMap.entries.first.key].first['course']} COURSE (Year :        ) ',
                    level: 5),
                pw.Divider(),
                for (var entry in groupedMap.entries) ...[
                  pw.Header(text: 'Centre : ${entry.key}'),
                  FestReportHeader(font1),
                  for (int i = 0; i < groupedMap[entry.key].length; i += 100)
                    FestReportTable(font1, groupedMap[entry.key], i, i + 100),
                ]
              ],

              /////////////Practical
              if (dtMode == GetDataMode.pptcPractical) ...[
                pw.Divider(),
                pw.Header(
                    text: 'CRAFT,ALBUM, CHART, & WASTE MATERIAL WORK etc….',
                    level: 4),
                pw.Divider(),
                pw.Header(
                    text:
                        'TSSR COUNCIL ${groupedMap[groupedMap.entries.first.key].first['course']} COURSE (Year :        ) ',
                    level: 5),
                pw.Divider(),
                for (var entry in groupedMap.entries) ...[
                  pw.Header(text: 'Centre : ${entry.key}'),
                  PracticalHeader(font1),
                  for (int i = 0; i < groupedMap[entry.key].length; i += 100)
                    PracticalTable(font1, groupedMap[entry.key], i, i + 100),
                ]
              ],

              /////////////Teachine Practice
              if (dtMode == GetDataMode.pptcTeachingPractice) ...[
                pw.Divider(),
                pw.Header(text: 'TEACHING PRACTICE MARK SHEET', level: 4),
                pw.Divider(),
                pw.Header(
                    text:
                        'TSSR COUNCIL ${groupedMap[groupedMap.entries.first.key].first['course']} COURSE (Year :        ) ',
                    level: 5),
                pw.Divider(),
                for (var entry in groupedMap.entries) ...[
                  pw.Header(text: 'Centre : ${entry.key}'),
                  TeachingPracticeHeader(font1),
                  for (int i = 0; i < groupedMap[entry.key].length; i += 100)
                    TeachingPracticeTable(
                        font1, groupedMap[entry.key], i, i + 100),
                ]
              ],

              /////////////Tour
              if (dtMode == GetDataMode.pptcTour) ...[
                pw.Divider(),
                pw.Header(text: 'Tour Marksheet', level: 4),
                pw.Divider(),
                pw.Header(
                    text:
                        'TSSR COUNCIL ${groupedMap[groupedMap.entries.first.key].first['course']} COURSE (Year :        ) ',
                    level: 5),
                pw.Divider(),
                for (var entry in groupedMap.entries) ...[
                  pw.Header(text: entry.key),
                  TourHeader(font1),
                  for (int i = 0; i < groupedMap[entry.key].length; i += 100)
                    TourTable(font1, groupedMap[entry.key], i, i + 100),
                ]
              ],
            ]));

    return doc;
  }
}

void showSnackBar({
  required material.BuildContext context,
  required bool isError,
  required String title,
  required String subtitle,
}) {
  material.ScaffoldMessenger.of(context).showSnackBar(
    material.SnackBar(
        duration: 5.seconds,
        backgroundColor: isError ? material.Colors.red : material.Colors.green,
        content: material.Column(
          children: [
            material.Text(
              title,
              style: material.TextStyle(
                color: material.Colors.white,
                fontWeight: material.FontWeight.bold,
              ),
            ),
            material.SizedBox(height: 5),
            material.Text(
              subtitle,
              style: material.TextStyle(
                color: material.Colors.white,
                fontWeight: material.FontWeight.bold,
              ),
            ),
          ],
        )),
  );
}

enum pageMode { potrait, landscape }

enum GetDataMode {
  studentDetails,
  attendanceRegister,
  pptcCamp,
  pptcClassTest,
  pptcCommision,
  pptcCraft,
  pptcFest,
  pptcPractical,
  pptcTeachingPractice,
  pptcTour,
}

enum OutputFormat { pdf, excel }

Widget StudentDataHeader(Font font1) {
  final CWU = PdfPageFormat.a4.availableWidth / 12;
  return Table(
      tableWidth: TableWidth.max,
      border: TableBorder.all(color: PdfColors.black),
      columnWidths: {
        0: FixedColumnWidth(CWU),
        1: FixedColumnWidth(CWU * 3),
        2: FixedColumnWidth(CWU * 4),
        3: FixedColumnWidth(CWU * 4),
        // 4: FixedColumnWidth(CWU * 3),
      },
      children: [
        TableRow(
          repeat: true,
          verticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('No',
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Reg No',
                  style: TextStyle(font: font1, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Name',
                  style: TextStyle(font: font1, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Course',
                  style: TextStyle(font: font1, fontWeight: FontWeight.bold)),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            //   child: Text('Study Centre',
            //       style: TextStyle(font: font1, fontWeight: FontWeight.bold)),
            // ),
          ],
        ),
      ]);
}

Widget StudentsDataTable(
    Font font1, dynamic dataList, int firstCount, int lastCount) {
  final CWU = PdfPageFormat.a4.availableWidth / 12;
  return Table(
    tableWidth: TableWidth.max,
    border: TableBorder.all(color: PdfColors.black),
    columnWidths: {
      0: FixedColumnWidth(CWU),
      1: FixedColumnWidth(CWU * 3),
      2: FixedColumnWidth(CWU * 4),
      3: FixedColumnWidth(CWU * 4),
      // 4: FixedColumnWidth(CWU * 3),
    },
    children: [
      // for (var val in dataList)
      for (int i = firstCount; i < dataList.length && i < lastCount; i++)
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(
                '${i + 1}',
                style: TextStyle(font: font1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(
                dataList[i]['reg_no'],
                style: TextStyle(font: font1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(
                dataList[i]['st_name'],
                style: TextStyle(font: font1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(
                dataList[i]['course'],
                style: TextStyle(font: font1),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            //   child: Text(
            //     dataList[i]['study_centre'],
            //     style: TextStyle(font: font1),
            //   ),
            // ),
          ],
        )
    ],
  );
}

///////////////////////////////////////////

Widget AttendenceRegisterHeader(Font font1) {
  final CWU = PdfPageFormat.a4.availableWidth / 12;
  return Table(
      tableWidth: TableWidth.max,
      border: TableBorder.all(color: PdfColors.black),
      columnWidths: {
        0: FixedColumnWidth(CWU * 2),
        1: FixedColumnWidth(CWU * 3),
        2: FixedColumnWidth(CWU * 6),
        3: FixedColumnWidth(CWU * 2),
        4: FixedColumnWidth(CWU * 2),
        5: FixedColumnWidth(CWU * 2),
        6: FixedColumnWidth(CWU * 2),
        7: FixedColumnWidth(CWU * 2),
        8: FixedColumnWidth(CWU * 2),
        9: FixedColumnWidth(CWU * 2),
        10: FixedColumnWidth(CWU * 2),
        // 4: FixedColumnWidth(CWU * 3),
      },
      children: [
        TableRow(
          repeat: true,
          verticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('No',
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Reg No',
                  style: TextStyle(font: font1, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Name',
                  style: TextStyle(font: font1, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Date',
                  style: TextStyle(font: font1, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Subject\n:',
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Subject\n:',
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Subject\n:',
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Subject\n:',
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Subject\n:',
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Subject\n:',
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Online/Offline',
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            //   child: Text('Study Centre',
            //       style: TextStyle(font: font1, fontWeight: FontWeight.bold)),
            // ),
          ],
        ),
      ]);
}

Widget AttendenceRegisterTable(
    Font font1, dynamic dataList, int firstCount, int lastCount) {
  final CWU = PdfPageFormat.a4.availableWidth / 12;
  return Table(
    tableWidth: TableWidth.max,
    border: TableBorder.all(color: PdfColors.black),
    columnWidths: {
      0: FixedColumnWidth(CWU * 2),
      1: FixedColumnWidth(CWU * 3),
      2: FixedColumnWidth(CWU * 6),
      3: FixedColumnWidth(CWU * 2),
      4: FixedColumnWidth(CWU * 2),
      5: FixedColumnWidth(CWU * 2),
      6: FixedColumnWidth(CWU * 2),
      7: FixedColumnWidth(CWU * 2),
      8: FixedColumnWidth(CWU * 2),
      9: FixedColumnWidth(CWU * 2),
      10: FixedColumnWidth(CWU * 2),
      // 4: FixedColumnWidth(CWU * 3),
    },
    children: [
      // for (var val in dataList)
      for (int i = firstCount; i < dataList.length && i < lastCount; i++)
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(
                '${i + 1}',
                style: TextStyle(font: font1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(
                dataList[i]['reg_no'],
                style: TextStyle(font: font1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(
                dataList[i]['st_name'],
                style: TextStyle(font: font1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            //   child: Text(
            //     dataList[i]['study_centre'],
            //     style: TextStyle(font: font1),
            //   ),
            // ),
          ],
        )
    ],
  );
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////

Widget CampReportHeader(Font font1) {
  final CWU = PdfPageFormat.a4.availableWidth / 17;
  return Table(
      tableWidth: TableWidth.max,
      border: TableBorder.all(color: PdfColors.black),
      columnWidths: {
        0: FixedColumnWidth(CWU),
        1: FixedColumnWidth(CWU * 2.5),
        2: FixedColumnWidth(CWU * 5),
        3: FixedColumnWidth(CWU * 1.5),
        4: FixedColumnWidth(CWU * 1.5),
        5: FixedColumnWidth(CWU * 1.5),
        6: FixedColumnWidth(CWU * 1.5),
        7: FixedColumnWidth(CWU * 1.5),
        8: FixedColumnWidth(CWU * 1.5),
      },
      children: [
        TableRow(
          repeat: true,
          verticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('No',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Reg No',
                  textAlign: TextAlign.center,
                  style: TextStyle(font: font1, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Name',
                  textAlign: TextAlign.center,
                  style: TextStyle(font: font1, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Camp',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Tour',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Fest',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Social Work',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Day Calibrations',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Total',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
          ],
        ),
      ]);
}

Widget CampReportTable(
    Font font1, dynamic dataList, int firstCount, int lastCount) {
  final CWU = PdfPageFormat.a4.availableWidth / 17;
  return Table(
    tableWidth: TableWidth.max,
    border: TableBorder.all(color: PdfColors.black),
    columnWidths: {
      0: FixedColumnWidth(CWU),
      1: FixedColumnWidth(CWU * 2.5),
      2: FixedColumnWidth(CWU * 5),
      3: FixedColumnWidth(CWU * 1.5),
      4: FixedColumnWidth(CWU * 1.5),
      5: FixedColumnWidth(CWU * 1.5),
      6: FixedColumnWidth(CWU * 1.5),
      7: FixedColumnWidth(CWU * 1.5),
      8: FixedColumnWidth(CWU * 1.5),
    },
    children: [
      // for (var val in dataList)
      TableRow(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            child: Text(''),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            child: Text(''),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            child: Text(''),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            child: Text('20'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            child: Text('20'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            child: Text('20'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            child: Text('20'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            child: Text('20'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            child: Text('100'),
          ),
        ],
      ),

      for (int i = firstCount; i < dataList.length && i < lastCount; i++)
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(
                '${i + 1}',
                style: TextStyle(font: font1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(
                dataList[i]['reg_no'],
                style: TextStyle(font: font1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(
                dataList[i]['st_name'],
                style: TextStyle(font: font1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
          ],
        ),
    ],
  );
}

///////////////////////////////////////////

Widget ClassTestHeader(Font font1) {
  final CWU = PdfPageFormat.a4.availableWidth / 24;
  return Table(
      tableWidth: TableWidth.max,
      border: TableBorder.all(color: PdfColors.black),
      columnWidths: {
        0: FixedColumnWidth(CWU),
        1: FixedColumnWidth(CWU * 3),
        2: FixedColumnWidth(CWU * 6),
        3: FixedColumnWidth(CWU * 2),
        4: FixedColumnWidth(CWU * 2),
        5: FixedColumnWidth(CWU * 2),
        6: FixedColumnWidth(CWU * 2),
        7: FixedColumnWidth(CWU * 2),
        8: FixedColumnWidth(CWU * 2),
        9: FixedColumnWidth(CWU * 2),
      },
      children: [
        TableRow(
          repeat: true,
          verticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('No',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Reg No',
                  textAlign: TextAlign.center,
                  style: TextStyle(font: font1, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Name',
                  textAlign: TextAlign.center,
                  style: TextStyle(font: font1, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Child Psychology',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Health And Nutrition',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Teaching Methdology',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('School Management',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Malayalam',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Communicative English',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Total',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
          ],
        ),
      ]);
}

Widget ClassTestTable(
    Font font1, dynamic dataList, int firstCount, int lastCount) {
  final CWU = PdfPageFormat.a4.availableWidth / 17;
  return Table(
    tableWidth: TableWidth.max,
    border: TableBorder.all(color: PdfColors.black),
    columnWidths: {
      0: FixedColumnWidth(CWU),
      1: FixedColumnWidth(CWU * 3),
      2: FixedColumnWidth(CWU * 6),
      3: FixedColumnWidth(CWU * 2),
      4: FixedColumnWidth(CWU * 2),
      5: FixedColumnWidth(CWU * 2),
      6: FixedColumnWidth(CWU * 2),
      7: FixedColumnWidth(CWU * 2),
      8: FixedColumnWidth(CWU * 2),
      9: FixedColumnWidth(CWU * 2),
    },
    children: [
      // for (var val in dataList)
      for (int i = firstCount; i < dataList.length && i < lastCount; i++)
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(
                '${i + 1}',
                style: TextStyle(font: font1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(
                dataList[i]['reg_no'],
                style: TextStyle(font: font1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(
                dataList[i]['st_name'],
                style: TextStyle(font: font1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
          ],
        )
    ],
  );
}

///////////////////////////////////////////

Widget CommisionHeader(Font font1) {
  final CWU = PdfPageFormat.a4.availableWidth / 19;
  return Table(
      tableWidth: TableWidth.max,
      border: TableBorder.all(color: PdfColors.black),
      columnWidths: {
        0: FixedColumnWidth(CWU),
        1: FixedColumnWidth(CWU * 3),
        2: FixedColumnWidth(CWU * 6),
        3: FixedColumnWidth(CWU * 2),
        4: FixedColumnWidth(CWU * 2),
        5: FixedColumnWidth(CWU * 2),
        6: FixedColumnWidth(CWU * 2),
        7: FixedColumnWidth(CWU * 2),
      },
      children: [
        TableRow(
          repeat: true,
          verticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('No',
                  textAlign: TextAlign.center,
                  style: TextStyle(font: font1, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Reg No',
                  textAlign: TextAlign.center,
                  style: TextStyle(font: font1, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Name',
                  textAlign: TextAlign.center,
                  style: TextStyle(font: font1, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Craft',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Teaching',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Reports',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Commision & Viva',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Total',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
          ],
        ),
      ]);
}

Widget CommisionTable(
    Font font1, dynamic dataList, int firstCount, int lastCount) {
  final CWU = PdfPageFormat.a4.availableWidth / 17;
  return Table(
    tableWidth: TableWidth.max,
    border: TableBorder.all(color: PdfColors.black),
    columnWidths: {
      0: FixedColumnWidth(CWU),
      1: FixedColumnWidth(CWU * 3),
      2: FixedColumnWidth(CWU * 6),
      3: FixedColumnWidth(CWU * 2),
      4: FixedColumnWidth(CWU * 2),
      5: FixedColumnWidth(CWU * 2),
      6: FixedColumnWidth(CWU * 2),
      7: FixedColumnWidth(CWU * 2),
    },
    children: [
      // for (var val in dataList)
      TableRow(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            child: Text(''),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            child: Text(''),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            child: Text(''),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            child: Text('100'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            child: Text('100'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            child: Text('100'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            child: Text('100'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            child: Text('400'),
          ),
        ],
      ),

      for (int i = firstCount; i < dataList.length && i < lastCount; i++)
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(
                '${i + 1}',
                style: TextStyle(font: font1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(
                dataList[i]['reg_no'],
                style: TextStyle(font: font1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(
                dataList[i]['st_name'],
                style: TextStyle(font: font1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
          ],
        )
    ],
  );
}

///////////////////////////////////////////

Widget CraftReportHeader(Font font1) {
  final CWU = PdfPageFormat.a4.availableWidth / 30;
  return Table(
      tableWidth: TableWidth.max,
      border: TableBorder.all(color: PdfColors.black),
      columnWidths: {
        0: FixedColumnWidth(CWU),
        1: FixedColumnWidth(CWU * 3),
        2: FixedColumnWidth(CWU * 6),
        3: FixedColumnWidth(CWU * 2),
        4: FixedColumnWidth(CWU * 2),
        5: FixedColumnWidth(CWU * 2),
        6: FixedColumnWidth(CWU * 2),
        7: FixedColumnWidth(CWU * 2),
        8: FixedColumnWidth(CWU * 2),
        9: FixedColumnWidth(CWU * 2),
        10: FixedColumnWidth(CWU * 2),
        11: FixedColumnWidth(CWU * 2),
        12: FixedColumnWidth(CWU * 2),
      },
      children: [
        TableRow(
          repeat: true,
          verticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('No',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Reg No',
                  textAlign: TextAlign.center,
                  style: TextStyle(font: font1, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Name',
                  textAlign: TextAlign.center,
                  style: TextStyle(font: font1, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Dolls',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Story',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Shapes',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Models',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Language',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Number',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Memory Items',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Sensory Items',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Fancy',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Total',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
          ],
        ),
      ]);
}

Widget CraftReportTable(
    Font font1, dynamic dataList, int firstCount, int lastCount) {
  final CWU = PdfPageFormat.a4.availableWidth / 17;
  return Table(
    tableWidth: TableWidth.max,
    border: TableBorder.all(color: PdfColors.black),
    columnWidths: {
      0: FixedColumnWidth(CWU),
      1: FixedColumnWidth(CWU * 3),
      2: FixedColumnWidth(CWU * 6),
      3: FixedColumnWidth(CWU * 2),
      4: FixedColumnWidth(CWU * 2),
      5: FixedColumnWidth(CWU * 2),
      6: FixedColumnWidth(CWU * 2),
      7: FixedColumnWidth(CWU * 2),
      8: FixedColumnWidth(CWU * 2),
      9: FixedColumnWidth(CWU * 2),
      10: FixedColumnWidth(CWU * 2),
      11: FixedColumnWidth(CWU * 2),
      12: FixedColumnWidth(CWU * 2),
    },
    children: [
      // for (var val in dataList)
      for (int i = firstCount; i < dataList.length && i < lastCount; i++)
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(
                '${i + 1}',
                style: TextStyle(font: font1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(
                dataList[i]['reg_no'],
                style: TextStyle(font: font1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(
                dataList[i]['st_name'],
                style: TextStyle(font: font1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
          ],
        )
    ],
  );
}

///////////////////////////////////////////

Widget FestReportHeader(Font font1) {
  final CWU = PdfPageFormat.a4.availableWidth / 17;
  return Table(
      tableWidth: TableWidth.max,
      border: TableBorder.all(color: PdfColors.black),
      columnWidths: {
        0: FixedColumnWidth(CWU),
        1: FixedColumnWidth(CWU * 2.5),
        2: FixedColumnWidth(CWU * 6),
        3: FixedColumnWidth(CWU * 2),
        4: FixedColumnWidth(CWU * 2),
        5: FixedColumnWidth(CWU * 2),
        6: FixedColumnWidth(CWU * 2),
      },
      children: [
        TableRow(
          repeat: true,
          verticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('No',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Reg No',
                  textAlign: TextAlign.center,
                  style: TextStyle(font: font1, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Name',
                  textAlign: TextAlign.center,
                  style: TextStyle(font: font1, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Fest Diray',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Active Participation In Program',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Overall Involvement',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Total',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
          ],
        ),
      ]);
}

Widget FestReportTable(
    Font font1, dynamic dataList, int firstCount, int lastCount) {
  final CWU = PdfPageFormat.a4.availableWidth / 17;
  return Table(
    tableWidth: TableWidth.max,
    border: TableBorder.all(color: PdfColors.black),
    columnWidths: {
      0: FixedColumnWidth(CWU),
      1: FixedColumnWidth(CWU * 2.5),
      2: FixedColumnWidth(CWU * 6),
      3: FixedColumnWidth(CWU * 2),
      4: FixedColumnWidth(CWU * 2),
      5: FixedColumnWidth(CWU * 2),
      6: FixedColumnWidth(CWU * 2),
    },
    children: [
      // for (var val in dataList)
      for (int i = firstCount; i < dataList.length && i < lastCount; i++)
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(
                '${i + 1}',
                style: TextStyle(font: font1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(
                dataList[i]['reg_no'],
                style: TextStyle(font: font1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(
                dataList[i]['st_name'],
                style: TextStyle(font: font1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
          ],
        )
    ],
  );
}

//////////////////////////////////////////

Widget PracticalHeader(Font font1) {
  final CWU = PdfPageFormat.a4.availableWidth / 38;
  return Table(
      tableWidth: TableWidth.max,
      border: TableBorder.all(color: PdfColors.black),
      columnWidths: {
        0: FixedColumnWidth(CWU * 2),
        1: FixedColumnWidth(CWU * 3),
        2: FixedColumnWidth(CWU * 6),
        3: FixedColumnWidth(CWU * 2),
        4: FixedColumnWidth(CWU * 2),
        5: FixedColumnWidth(CWU * 2),
        6: FixedColumnWidth(CWU * 2),
        7: FixedColumnWidth(CWU * 2),
        8: FixedColumnWidth(CWU * 2),
        9: FixedColumnWidth(CWU * 2),
        10: FixedColumnWidth(CWU * 2),
        11: FixedColumnWidth(CWU * 2),
        12: FixedColumnWidth(CWU * 2),
        13: FixedColumnWidth(CWU * 2),
        14: FixedColumnWidth(CWU * 2),
        15: FixedColumnWidth(CWU * 2),
        16: FixedColumnWidth(CWU * 2),
      },
      children: [
        TableRow(
          repeat: true,
          verticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('No',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Reg No',
                  textAlign: TextAlign.center,
                  style: TextStyle(font: font1, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Name',
                  textAlign: TextAlign.center,
                  style: TextStyle(font: font1, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Teaching Record',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 6)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Assaignments',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 7)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Seminar',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 7)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Chart',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 7)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Flash Card',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 7)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Waste Material Work',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 7)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Collection',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 7)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Natural/Scrap Album',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 7)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Picture Album',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 7)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Cutout',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 7)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Records',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 7)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('LOTTO',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 7)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Number Wheel',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 7)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Total',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 7)),
            ),
          ],
        ),
      ]);
}

Widget PracticalTable(
    Font font1, dynamic dataList, int firstCount, int lastCount) {
  final CWU = PdfPageFormat.a4.availableWidth / 17;
  return Table(
    tableWidth: TableWidth.max,
    border: TableBorder.all(color: PdfColors.black),
    columnWidths: {
      0: FixedColumnWidth(CWU * 2),
      1: FixedColumnWidth(CWU * 3),
      2: FixedColumnWidth(CWU * 6),
      3: FixedColumnWidth(CWU * 2),
      4: FixedColumnWidth(CWU * 2),
      5: FixedColumnWidth(CWU * 2),
      6: FixedColumnWidth(CWU * 2),
      7: FixedColumnWidth(CWU * 2),
      8: FixedColumnWidth(CWU * 2),
      9: FixedColumnWidth(CWU * 2),
      10: FixedColumnWidth(CWU * 2),
      11: FixedColumnWidth(CWU * 2),
      12: FixedColumnWidth(CWU * 2),
      13: FixedColumnWidth(CWU * 2),
      14: FixedColumnWidth(CWU * 2),
      15: FixedColumnWidth(CWU * 2),
      16: FixedColumnWidth(CWU * 2),
    },
    children: [
      // for (var val in dataList)
      TableRow(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            child: Text(''),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            child: Text(''),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            child: Text(''),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            child: Text('10'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            child: Text('10'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            child: Text('10'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            child: Text('10'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            child: Text('5'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            child: Text('10'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            child: Text('5'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            child: Text('10'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            child: Text('10'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            child: Text('5'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            child: Text('5'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            child: Text('5'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            child: Text('5'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            child: Text('100'),
          ),
        ],
      ),
      for (int i = firstCount; i < dataList.length && i < lastCount; i++)
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(
                '${i + 1}',
                style: TextStyle(font: font1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(
                dataList[i]['reg_no'],
                style: TextStyle(font: font1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(
                dataList[i]['st_name'],
                style: TextStyle(font: font1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
          ],
        )
    ],
  );
}

//////////////////////////////////////////

Widget TeachingPracticeHeader(Font font1) {
  final CWU = PdfPageFormat.a4.availableWidth / 17;
  return Table(
      tableWidth: TableWidth.max,
      border: TableBorder.all(color: PdfColors.black),
      columnWidths: {
        0: FixedColumnWidth(CWU),
        1: FixedColumnWidth(CWU * 2.5),
        2: FixedColumnWidth(CWU * 6),
        3: FixedColumnWidth(CWU * 2),
        4: FixedColumnWidth(CWU * 2),
        5: FixedColumnWidth(CWU * 2),
        6: FixedColumnWidth(CWU * 2),
        7: FixedColumnWidth(CWU * 2),
        8: FixedColumnWidth(CWU * 2),
      },
      children: [
        TableRow(
          repeat: true,
          verticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('No',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Reg No',
                  textAlign: TextAlign.center,
                  style: TextStyle(font: font1, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Name',
                  textAlign: TextAlign.center,
                  style: TextStyle(font: font1, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Introduction',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Presentation',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Teaching Aids',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Language Clarity',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Extra Curricular',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Total',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
          ],
        ),
      ]);
}

Widget TeachingPracticeTable(
    Font font1, dynamic dataList, int firstCount, int lastCount) {
  final CWU = PdfPageFormat.a4.height / 17;
  return Table(
    tableWidth: TableWidth.max,
    border: TableBorder.all(color: PdfColors.black),
    columnWidths: {
      0: FixedColumnWidth(CWU),
      1: FixedColumnWidth(CWU * 2.5),
      2: FixedColumnWidth(CWU * 6),
      3: FixedColumnWidth(CWU * 2),
      4: FixedColumnWidth(CWU * 2),
      5: FixedColumnWidth(CWU * 2),
      6: FixedColumnWidth(CWU * 2),
      7: FixedColumnWidth(CWU * 2),
      8: FixedColumnWidth(CWU * 2),
    },
    children: [
      // for (var val in dataList)
      TableRow(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            child: Text(''),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            child: Text(''),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            child: Text(''),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            child: Text('10'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            child: Text('50'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            child: Text('20'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            child: Text('10'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            child: Text('10'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            child: Text('100'),
          ),
        ],
      ),
      for (int i = firstCount; i < dataList.length && i < lastCount; i++)
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(
                '${i + 1}',
                style: TextStyle(font: font1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(
                dataList[i]['reg_no'],
                style: TextStyle(font: font1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(
                dataList[i]['st_name'],
                style: TextStyle(font: font1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
          ],
        )
    ],
  );
}

//////////////////////////////////////////

Widget TourHeader(Font font1) {
  final CWU = PdfPageFormat.a4.availableWidth / 17;
  return Table(
      tableWidth: TableWidth.max,
      border: TableBorder.all(color: PdfColors.black),
      columnWidths: {
        0: FixedColumnWidth(CWU),
        1: FixedColumnWidth(CWU * 2.5),
        2: FixedColumnWidth(CWU * 6),
        3: FixedColumnWidth(CWU * 2),
        4: FixedColumnWidth(CWU * 2),
        5: FixedColumnWidth(CWU * 2),
        6: FixedColumnWidth(CWU * 2),
      },
      children: [
        TableRow(
          repeat: true,
          verticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('No',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Reg No',
                  textAlign: TextAlign.center,
                  style: TextStyle(font: font1, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Name',
                  textAlign: TextAlign.center,
                  style: TextStyle(font: font1, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Tour Diray',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Active Participation In Program',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Overall Involvement',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text('Total',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      font: font1, fontWeight: FontWeight.bold, fontSize: 8)),
            ),
          ],
        ),
      ]);
}

Widget TourTable(Font font1, dynamic dataList, int firstCount, int lastCount) {
  final CWU = PdfPageFormat.a4.availableWidth / 17;
  return Table(
    tableWidth: TableWidth.max,
    border: TableBorder.all(color: PdfColors.black),
    columnWidths: {
      0: FixedColumnWidth(CWU),
      1: FixedColumnWidth(CWU * 2.5),
      2: FixedColumnWidth(CWU * 6),
      3: FixedColumnWidth(CWU * 2),
      4: FixedColumnWidth(CWU * 2),
      5: FixedColumnWidth(CWU * 2),
      6: FixedColumnWidth(CWU * 2),
    },
    children: [
      // for (var val in dataList)
      for (int i = firstCount; i < dataList.length && i < lastCount; i++)
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(
                '${i + 1}',
                style: TextStyle(font: font1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(
                dataList[i]['reg_no'],
                style: TextStyle(font: font1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(
                dataList[i]['st_name'],
                style: TextStyle(font: font1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Text(''),
            ),
          ],
        )
    ],
  );
}
