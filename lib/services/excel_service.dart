import 'dart:io';

import 'package:excel/excel.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jsaver/jSaver.dart';
import 'package:tssr_ctrl/services/database_service.dart';
import 'package:tssr_ctrl/services/pdf_service.dart';

class ExcelService {
  Future<void> createExcel(
      {required List<String> titles,
      required BuildContext context,
      required List<String> fields,
      required List dataList,
      required String fileName}) async {
    try {
      final isConnected = await DatabaseService.checkInternetConnection();
      if (isConnected) {
        final excel = Excel.createExcel();

        final sheet = excel[excel.getDefaultSheet()!];

        for (int i = 0; i < titles.length; i++) {
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
              .value = titles[i];

          for (int j = 0; j < dataList.length; j++) {
            sheet
                .cell(CellIndex.indexByColumnRow(
                  columnIndex: i,
                  rowIndex: j + 1,
                ))
                .value = dataList[j][fields[i]];
          }
        }

        if (kIsWeb) {
          final bytes = excel.save(
              fileName: '${fileName.isEmpty ? "All_Centre" : fileName}.xlsx');

          // final uint8list = Uint8List.fromList(bytes!);
          // final s = await JSaver.instance.saveFromData(
          //     data: uint8list,
          //     name: '${fileName.isEmpty ? "All_Centre" : fileName}.xlsx',
          //     type: JSaverFileType.MICROSOFTEXCEL);
        } else {
          final bytes = excel.save(
              fileName: '${fileName.isEmpty ? "All_Centre" : fileName}.xlsx');

          final downloadsPath =
              await ExternalPath.getExternalStoragePublicDirectory(
                  ExternalPath.DIRECTORY_DOWNLOADS);

          File(
              "${downloadsPath}/${fileName.isEmpty ? "All_Centre" : fileName}.xlsx")
            ..createSync(recursive: false)
            ..writeAsBytesSync(bytes!);
        }

        showSnackBar(
            context: context,
            isError: false,
            title: 'Success',
            subtitle: 'XLSX file saved to Downloads');
        Get.back();
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
      showSnackBar(
          context: context,
          isError: false,
          title: 'Success',
          subtitle: 'PDF saved to Downloads');
    }
  }

  Future createSkeletonExcelFiles(
      {required List<String> titles,
      required String fileName,
      required BuildContext context}) async {
    try {
      final excel = Excel.createExcel();

      final sheet = excel[excel.getDefaultSheet()!];

      for (int i = 0; i < titles.length; i++) {
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
            .value = titles[i];
      }

      if (kIsWeb) {
        final bytes = excel.save(
          fileName: '$fileName.xlsx',
        );
      } else {
        final bytes = excel.save(
          fileName: '$fileName.xlsx',
        );
        final downloadsPath =
            await ExternalPath.getExternalStoragePublicDirectory(
                ExternalPath.DIRECTORY_DOWNLOADS);

        File(
            "${downloadsPath}/${fileName.isEmpty ? "All_Centre" : fileName}.xlsx")
          ..createSync(recursive: false)
          ..writeAsBytesSync(bytes!);
      }
      showSnackBar(
          context: context,
          isError: false,
          title: 'Success',
          subtitle: 'XLSX file saved to Downloads');
    } catch (e) {
      print(e);
      showSnackBar(
          context: context,
          isError: true,
          title: 'Oops',
          subtitle: 'Something went wrong');
    }
  }
}
