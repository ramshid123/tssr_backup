import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/constants/colors.dart';
import 'package:tssr_ctrl/pages/ADMIN/gallery_upload/controller.dart';
import 'package:tssr_ctrl/widgets/app_bar.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:tssr_ctrl/widgets/drawer.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class GalleryPage extends GetView<GalleryController> {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar('Gallery'),
        body: LayoutBuilder(
          builder: (context, constraints) {
            bool isMobile = Get.width <= 768 ? true : false;
            return isMobile
                ? Obx(() {
                    return controller.state.imageList.length == 0
                        ? Container(
                            margin: EdgeInsets.symmetric(horizontal: 30),
                            child: controller.state.filePath.value == ''
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Select image to be show cased on the official website. It is recommended to select a photo with landscape, so the site\' alignment will look correct.',
                                        style: TextStyle(fontSize: 17),
                                      ),
                                      SizedBox(height: 20),
                                      GestureDetector(
                                        onTap: () async {
                                          await controller.getFileAndSetPath();
                                        },
                                        child: DottedBorder(
                                          color: Colors.grey.shade500,
                                          strokeWidth: 5,
                                          radius: Radius.circular(30),
                                          dashPattern: [20],
                                          borderType: BorderType.RRect,
                                          child: Container(
                                            height: 160,
                                            width: Get.width,
                                            decoration: BoxDecoration(
                                              color: Colors.black12,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.upload_file_outlined,
                                                  size: 60,
                                                  color:
                                                      ColorConstants.purple_clr,
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  'Select image',
                                                  style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.w900,
                                                    color: ColorConstants
                                                        .blachish_clr,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: !controller.state.isLoading.value
                                            ? ElevatedButton(
                                                onPressed: () async {
                                                  await controller
                                                      .getImageList();
                                                },
                                                child: Text('Show Case'),
                                              )
                                            : CircularProgressIndicator(),
                                      )
                                    ],
                                  )
                                : SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        SizedBox(height: 30),
                                        kIsWeb
                                            ? Image.memory(
                                                controller.state.bytes!,
                                                fit: BoxFit.contain,
                                              )
                                            : Image.file(
                                                File(controller
                                                    .state.filePath.value),
                                                fit: BoxFit.contain,
                                                height: Get.height * 0.3,
                                                width: Get.height * 0.3,
                                              ),
                                        SizedBox(height: 20),
                                        !controller.state.isLoading.value
                                            ? ElevatedButton(
                                                onPressed: () async {
                                                  await controller
                                                      .confirmAndUpload();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    fixedSize: Size(
                                                        Get.width, 50),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20))),
                                                child:
                                                    Text('Confirm and Upload'),
                                              )
                                            : LinearProgressIndicator(),
                                      ],
                                    ),
                                  ),
                          )
                        : ListView.separated(
                            cacheExtent: 999999,
                            separatorBuilder: (context, index) => Divider(),
                            itemBuilder: (context, index) {
                              final item =
                                  controller.state.imageList.value[index];
                              return GestureDetector(
                                onTap: () async => controller.deleteImage(item),
                                child: Image.network(item),
                              );
                            },
                            itemCount: controller.state.imageList.value.length,
                          );
                  })
                : Obx(() {
                    return controller.state.imageList.length == 0
                        ? Container(
                            margin: EdgeInsets.symmetric(horizontal: 30),
                            child: controller.state.filePath.value == ''
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: Get.width / 2,
                                        child: Text(
                                          'Select image to be show cased on the official website. It is recommended to select a photo with landscape, so the site\' alignment will look correct.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 17),
                                        ),
                                      ),
                                      SizedBox(height: 40),
                                      GestureDetector(
                                        onTap: () async {
                                          await controller.getFileAndSetPath();
                                        },
                                        child: DottedBorder(
                                          color: Colors.grey.shade500,
                                          strokeWidth: 5,
                                          radius: Radius.circular(30),
                                          dashPattern: [20],
                                          borderType: BorderType.RRect,
                                          child: Container(
                                            height: 160,
                                            width: Get.width * 0.3,
                                            decoration: BoxDecoration(
                                              color: Colors.black12,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.upload_file_outlined,
                                                  size: 60,
                                                  color:
                                                      ColorConstants.purple_clr,
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  'Select image',
                                                  style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.w900,
                                                    color: ColorConstants
                                                        .blachish_clr,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: !controller.state.isLoading.value
                                            ? ElevatedButton(
                                                onPressed: () async {
                                                  await controller
                                                      .getImageList();
                                                },
                                                child: Text('Show Case'),
                                              )
                                            : CircularProgressIndicator(),
                                      )
                                    ],
                                  )
                                : SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        SizedBox(height: 30),
                                        kIsWeb
                                            ? Image.memory(
                                                controller.state.bytes!,
                                                fit: BoxFit.contain,
                                              )
                                            : Image.file(
                                                File(controller
                                                    .state.filePath.value),
                                                fit: BoxFit.contain,
                                                height: Get.height * 0.3,
                                                width: Get.height * 0.3,
                                              ),
                                        SizedBox(height: 20),
                                        !controller.state.isLoading.value
                                            ? ElevatedButton(
                                                onPressed: () async {
                                                  await controller
                                                      .confirmAndUpload();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    fixedSize: Size(
                                                        Get.width, 50),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20))),
                                                child:
                                                    Text('Confirm and Upload'),
                                              )
                                            : LinearProgressIndicator(),
                                      ],
                                    ),
                                  ),
                          )
                        : ListView.separated(
                            cacheExtent: 999999,
                            separatorBuilder: (context, index) => Divider(),
                            itemBuilder: (context, index) {
                              final item =
                                  controller.state.imageList.value[index];
                              return GestureDetector(
                                onTap: () async => controller.deleteImage(item),
                                child: Image.network(item),
                              );
                            },
                            itemCount: controller.state.imageList.value.length,
                          );
                  });
          },
        ));
  }
}
