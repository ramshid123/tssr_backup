import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/services/database_service.dart';

class PDFTestView extends StatelessWidget {
  PDFTestView({super.key});

  final CWU = Get.width / 6;

  final dummy = [
    {
      'reg_no': 'reg no 6',
      'skill': ' skill 8',
      'name': 'name 8',
      'skill_centre': 'centre 8',
      'exam_date': 'date 8',
      'doc_id': '2zktvbvdvfk27vTvKn7K'
    },
    {
      'reg_no': 'reg_no 4',
      'skill': 'skill 10',
      'name': 'name 10',
      'skill_centre': 'centre 10',
      'doc_id': '4XxErveX1WMSJ7PsjgYZ',
      'exam_date': 'date 10'
    },
    {
      'reg_no': 'reg no 3',
      'skill': ' skill 3',
      'name': 'name 3',
      'skill_centre': 'centre 3',
      'exam_date': 'date 3',
      'doc_id': '8rcD97FcNyO2So7NOabf'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     final s = await DatabaseService.tsscCollection.get();
      //     // s.docs.forEach((element) {print(element.data());});
      //     print(s.docs);
      //   },
      // ),
      body: Column(
        children: [
          Container(
            color: Color(0xffbbe197),
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'TSSR Council',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'An Autonomous organisation registered under Government of India',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 10),
                Text('ISO 9001 : 2015,2001:2018 CERTIFIED ORGANISATION'),
                SizedBox(height: 5),
                Text(
                    'Rgd Office:- B - 38 UGF, Vishal Enclave, Rajouri Garden, New Delhi - 110027',
                    textAlign: TextAlign.center),
                SizedBox(height: 5),
                Text('Head Office :- Calicut, Kerala, India,673586'),
              ],
            ),
          ),
          Container(
            color: Color(0xffbfbfbf),
            child: Text(
                'TSSR DIPLOMA IN PRE-PRIMARY TEACHERS TRAINIG COURSE (2022-2023)'),
          ),
          Container(
            color: Color(0xffc1c294),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    child: Center(child: Text('CENTRE NAME')),
                  ),
                ),
                Container(
                  height: 40,
                  width: 2,
                  color: Colors.black,
                ),
                Expanded(
                  child: Container(
                    child: Center(
                      child: Text(
                        "CKMM TEACHER'S TRAINING CENTER Panakkad",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 40,
            color: Color(0xffbbe197),
            child: Center(
              child: Text('STUDENTS REGISTRATION DETAILS '),
            ),
          ),
          Expanded(
            child: Container(
              color: Color(0xffb9ba8e),
              child: Table(
                border: TableBorder.all(color: Colors.black),
                columnWidths: {
                  0: FixedColumnWidth(CWU),
                  1: FixedColumnWidth(CWU * 2),
                  2: FixedColumnWidth(CWU * 3),
                },
                children: [
                  TableRow(
                    children: [
                      Text('Reg No'),
                      Text('Skill'),
                      Text('Name'),
                    ],
                  ),
                  for (var val in dummy)
                    TableRow(
                      children: [
                        Text(val['reg_no']!),
                        Text(val['skill']!),
                        Text(val['name']!),
                      ],
                    )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}



// class PdfApi {
//   Future getDataFromDB({String? filter, required bool getAll}) async {
//     final snapshot = getAll
//         ? await DatabaseService.StudentDetailsCollection.get()
//         : await DatabaseService.StudentDetailsCollection.where('study_centre',
//                 isEqualTo: filter)
//             .get();
//     final dataList = snapshot.docs;
//     return dataList;
//   }

//   Future createPdfModel(List dataList, String filter) async {
//     final pdf = Document();
//     final font = await PdfGoogleFonts.openSansRegular();

//     // dataList = List.generate(
//     //   63,
//     //   (index) => {
//     //     'reg_no': 'reg $index',
//     //     'name': 'Abdul Fathah Muhammed KP $index'
//     //     //       Abdul fathah muhammed kattippara
//     //   },
//     // );

//     final CWU = PdfPageFormat.a4.availableWidth / 12;

//     pdf.addPage(Page(
//       pageFormat: PdfPageFormat.a4,
//       build: (context) {
//         return Column(
//           children: [
//             Container(
//               width: double.infinity,
//               color: PdfColor.fromHex('bbe197'),
//               padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     'TSSR Council',
//                     style: TextStyle(
//                       font: font,
//                       fontSize: 30,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     'An Autonomous organisation registered under Government of India',
//                     style: TextStyle(fontSize: 12, font: font),
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     'ISO 9001 : 2015,2001:2018 CERTIFIED ORGANISATION',
//                     style: TextStyle(font: font),
//                   ),
//                   SizedBox(height: 5),
//                   Text(
//                       'Rgd Office:- B - 38 UGF, Vishal Enclave, Rajouri Garden, New Delhi - 110027',
//                       style: TextStyle(font: font),
//                       textAlign: TextAlign.center),
//                   SizedBox(height: 5),
//                   Text(
//                     'Head Office :- Calicut, Kerala, India,673586',
//                     style: TextStyle(font: font),
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//                 width: double.infinity, height: 1, color: PdfColors.black),
//             Container(
//               padding: EdgeInsets.symmetric(vertical: 1),
//               width: double.infinity,
//               color: PdfColor.fromHex('bfbfbf'),
//               child: Text(
//                 'TSSR DIPLOMA IN PRE-PRIMARY TEACHERS TRAINIG COURSE (2022-2023)',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(font: font),
//               ),
//             ),
//             Container(
//                 width: double.infinity, height: 1, color: PdfColors.black),
//             Container(
//               width: double.infinity,
//               color: PdfColor.fromHex('c1c294'),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Container(
//                       child: Center(
//                           child: Text(
//                         'CENTRE NAME',
//                         style: TextStyle(font: font),
//                       )),
//                     ),
//                   ),
//                   Container(
//                     height: 40,
//                     width: 2,
//                     color: PdfColors.black,
//                   ),
//                   Expanded(
//                     child: Container(
//                       child: Center(
//                         child: Text(
//                           filter == null || filter.isEmpty
//                               ? 'All'
//                               : "${filter}",
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             font: font,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//                 width: double.infinity, height: 1, color: PdfColors.black),
//             Container(
//               width: double.infinity,
//               height: 40,
//               color: PdfColor.fromHex('bbe197'),
//               child: Center(
//                 child: Text(
//                   'STUDENTS REGISTRATION DETAILS ',
//                   style: TextStyle(font: font),
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Container(
//                 color: PdfColor.fromHex('b9ba8e'),
//                 child: Table(
//                   tableWidth: TableWidth.max,
//                   border: TableBorder.all(color: PdfColors.black),
//                   columnWidths: {
//                     0: FixedColumnWidth(CWU),
//                     1: FixedColumnWidth(CWU * 3),
//                     2: FixedColumnWidth(CWU * 8),
//                   },
//                   children: [
//                     TableRow(
//                       repeat: true,
//                       verticalAlignment: TableCellVerticalAlignment.middle,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 5, vertical: 1),
//                           child: Text('No',
//                               style: TextStyle(
//                                   font: font, fontWeight: FontWeight.bold)),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 5, vertical: 1),
//                           child: Text('Reg No',
//                               style: TextStyle(
//                                   font: font, fontWeight: FontWeight.bold)),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 5, vertical: 1),
//                           child: Text('Name',
//                               style: TextStyle(
//                                   font: font, fontWeight: FontWeight.bold)),
//                         ),
//                       ],
//                     ),
//                     // for (var val in dataList)
//                     for (int i = 0; i < 20 && i < dataList.length; i++)
//                       TableRow(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 5, vertical: 1),
//                             child: Text(
//                               '${i + 1}',
//                               style: TextStyle(font: font),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 5, vertical: 1),
//                             child: Text(
//                               dataList[i]['reg_no'],
//                               style: TextStyle(font: font),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 5, vertical: 1),
//                             child: Text(
//                               dataList[i]['st_name'],
//                               style: TextStyle(font: font),
//                             ),
//                           ),
//                         ],
//                       )
//                   ],
//                 ),
//               ),
//             )
//           ],
//         );
//       },
//     ));

//     if (dataList.length > 20) {
//       List<List> subLists = [];
//       for (int i = 20; i < dataList.length; i += 30) {
//         subLists.add(dataList.sublist(
//             i, i + 30 < dataList.length ? i + 30 : dataList.length));
//       }
//       for (List subList in subLists) {
//         pdf.addPage(Page(
//           build: (context) {
//             return Expanded(
//               child: Container(
//                 color: PdfColor.fromHex('b9ba8e'),
//                 child: Table(
//                   border: TableBorder.all(color: PdfColors.black),
//                   columnWidths: {
//                     0: FixedColumnWidth(CWU),
//                     1: FixedColumnWidth(CWU * 2),
//                     2: FixedColumnWidth(CWU * 3),
//                   },
//                   children: [
//                     for (var val in subList)
//                       TableRow(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 5, vertical: 1),
//                             child: Text(
//                               (dataList.indexOf(val) + 1).toString(),
//                               style: TextStyle(font: font),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 5, vertical: 1),
//                             child: Text(
//                               val['reg_no'],
//                               style: TextStyle(font: font),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 5, vertical: 1),
//                             child: Text(
//                               val['st_name'],
//                               style: TextStyle(font: font),
//                             ),
//                           ),
//                         ],
//                       )
//                   ],
//                 ),
//               ),
//             );
//           },
//         ));
//       }
//     }

//     return pdf;
//   }

//   Future SavePdfFile(Document pdf, String filter) async {
//     var status = await Permission.storage.request();
//     if (status.isDenied) {
//       Get.defaultDialog(
//         title: 'Storage permission required!',
//         middleText:
//             'The permission for storage is manditory for saving the pdf files to the local storage',
//       );
//     } else {
//       final bytes = await pdf.save();
//       final dir = await ExternalPath.getExternalStoragePublicDirectory(
//           ExternalPath.DIRECTORY_DOWNLOADS);
//       final file = File(
//           '${dir}/${filter == null || filter.isEmpty ? "All_Centre" : filter}.pdf');
//       await file.writeAsBytes(bytes);
//       print('done');
//     }
//   }

//   Future generatePDF(String filter, bool getAll) async {
//     final dataList = await getDataFromDB(filter: filter, getAll: getAll);
//     final pdf = await createPdfModel(dataList, filter);
//     await SavePdfFile(pdf, filter);
//   }
// }
