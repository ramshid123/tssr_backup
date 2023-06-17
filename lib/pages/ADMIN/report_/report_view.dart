// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:tssr_ctrl/constants/colors.dart';
// import 'package:tssr_ctrl/services/database_service.dart';
// import 'package:tssr_ctrl/services/pdf_service.dart';
// import 'package:tssr_ctrl/widgets/app_bar.dart';
// import 'package:tssr_ctrl/routes/names.dart';
// import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';

// class ReportHomePage extends StatelessWidget {
//   const ReportHomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar('Report'),
//       body: SizedBox(
//         height: Get.height,
//         width: Get.width,
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               SizedBox(height: 60),
//               Text(
//                 'Report Services',
//                 style: TextStyle(
//                   fontSize: 20,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Container(
//                 height: 1,
//                 width: 100,
//                 color: ColorConstants.blachish_clr,
//               ),
//               SizedBox(height: 30),
//               Wrap(
//                 alignment: WrapAlignment.center,
//                 runSpacing: 20,
//                 spacing: 20,
//                 children: [
//                   ReportPageButton(
//                     'Student Details',
//                     pgmd: pageMode.potrait,
//                     gdmd: GetDataMode.studentDetails,
//                   ),
//                   ReportPageButton(
//                     'PPTC Camp Report',
//                     pgmd: pageMode.potrait,
//                     gdmd: GetDataMode.pptcCamp,
//                   ),
//                   ReportPageButton(
//                     'PPTC Class Test',
//                     pgmd: pageMode.landscape,
//                     gdmd: GetDataMode.pptcClassTest,
//                   ),
//                   ReportPageButton(
//                     'PPTC Commision',
//                     pgmd: pageMode.potrait,
//                     gdmd: GetDataMode.pptcCommision,
//                   ),
//                   ReportPageButton(
//                     'PPTC Craft Report',
//                     pgmd: pageMode.landscape,
//                     gdmd: GetDataMode.pptcCraft,
//                   ),
//                   ReportPageButton(
//                     'PPTC Fest Report',
//                     pgmd: pageMode.potrait,
//                     gdmd: GetDataMode.pptcFest,
//                   ),
//                   ReportPageButton(
//                     'PPTC Practical',
//                     pgmd: pageMode.landscape,
//                     gdmd: GetDataMode.pptcPractical,
//                   ),
//                   ReportPageButton(
//                     'PPTC Teaching Practice',
//                     pgmd: pageMode.landscape,
//                     gdmd: GetDataMode.pptcTeachingPractice,
//                   ),
//                   ReportPageButton(
//                     'PPTC Tour',
//                     pgmd: pageMode.potrait,
//                     gdmd: GetDataMode.pptcTour,
//                   ),
//                   SizedBox(width: Get.width, height: 10),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// Widget ReportPageButton(String title,
//     {required pageMode pgmd, required GetDataMode gdmd}) {
//   return ElevatedButton(
//     onPressed: () async {
//       await Get.defaultDialog(
//           title: 'Options',
//           content: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               ElevatedButton(
//                 onPressed: () async => await PdfApi().generateDocument(
//                     orgName: '', pgMode: pgmd, dataMode: gdmd, isPPTC: false),
//                 child: Text('All Centre'),
//                 style: ElevatedButton.styleFrom(
//                     backgroundColor: ColorConstants.purple_clr,
//                     foregroundColor: Colors.white,
//                     fixedSize: Size(150, 50),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     )),
//               ),
//               SizedBox(width: 10),
//               ElevatedButton(
//                 onPressed: () async {
//                   final query = DatabaseService.FranchiseCollection.where(
//                       'isAdmin',
//                       isEqualTo: 'false');
//                   await Get.bottomSheet(
//                     backgroundColor: Colors.white,
//                     Container(
//                       height: Get.height / 2,
//                       child: FirestoreListView(
//                         query: query,
//                         itemBuilder: (context, doc) {
//                           final item = doc.data();
//                           return ListTile(
//                             title: Text(item['centre_name']),
//                             onTap: () async {
//                               await PdfApi().generateDocument(
//                                   orgName: item['centre_name'],
//                                   isPPTC: false,
//                                   pgMode: pgmd,
//                                   dataMode: gdmd);
//                             },
//                           );
//                         },
//                       ),
//                     ),
//                   );
//                 },
//                 child: Text('Select Centre'),
//                 style: ElevatedButton.styleFrom(
//                     backgroundColor: ColorConstants.purple_clr,
//                     foregroundColor: Colors.white,
//                     fixedSize: Size(150, 50),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     )),
//               ),
//             ],
//           ));
//     },
//     child: SizedBox(
//       width: Get.width * 0.4,
//       child: Text(
//         title,
//         textAlign: TextAlign.center,
//         style: TextStyle(
//           fontSize: 22,
//           fontWeight: FontWeight.w400,
//         ),
//       ),
//     ),
//     style: ElevatedButton.styleFrom(
//       fixedSize: Size(Get.width * 0.4, Get.width * 0.4),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//     ),
//   );
// }
