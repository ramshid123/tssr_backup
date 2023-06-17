import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/constants/colors.dart';
import 'package:tssr_ctrl/pages/ADMIN/T%20Store(admin)/orders/torders_index.dart';
import 'package:tssr_ctrl/pages/ADMIN/TSSR/TSSR%20View/tssrpage_index.dart';
import 'package:tssr_ctrl/services/authentication_service.dart';
import 'package:tssr_ctrl/services/database_service.dart';

Widget OptionsBar(BuildContext context, controller, List sortOpts) {
  final textCtrl = TextEditingController();
  final focusNode = FocusNode();
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: Column(
      children: [
        SizedBox(height: 10),
        Row(
          children: [
            Container(
              width: Get.width - 68,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 3,
                      spreadRadius: 1.5,
                    ),
                  ]),
              child: SizedBox(
                child: TextFormField(
                  focusNode: focusNode,
                  controller: textCtrl,
                  style: TextStyle(fontSize: 17),
                  onTap: () => focusNode.requestFocus(),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () async {
                          focusNode.unfocus();
                          textCtrl.clear();
                          // FocusScope.of(context).unfocus();
                        },
                        icon: Icon(Icons.clear, color: Colors.grey)),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    hintText: 'Search by Name..',
                    prefixIcon: Icon(
                      Icons.search,
                      color: ColorConstants.greenish_clr,
                    ),
                    hintStyle: TextStyle(
                      wordSpacing: 2,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () async {
                focusNode.unfocus();
                final sortOption = await showMenu<String>(
                  context: context,
                  position: RelativeRect.fromLTRB(100, 100, 0, 0),
                  items: [
                    PopupMenuItem<String>(
                        onTap: () async {
                          try {
                            await controller.deleteAll();
                          } catch (e) {
                            Get.defaultDialog(
                              title: 'Error',
                              middleText: 'Something went wrong',
                            );
                            Get.defaultDialog(
                              title: 'Error',
                              middleText: 'Something went wrong',
                            );
                          }
                        },
                        value: '1',
                        child: const Text(
                          'Delete All',
                          style: TextStyle(color: Colors.red),
                        )),
                    PopupMenuItem<String>(
                        onTap: () => print('refresh'),
                        value: '2',
                        child: const Text(
                          'Refresh',
                          style: TextStyle(color: Colors.blue),
                        )),
                  ],
                  elevation: 8.0,
                );
              },
              icon: Icon(Icons.more_vert),
              padding: EdgeInsets.zero,
            )
          ],
        ),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                controller.searchByString(textCtrl.text);
              },
              icon: Icon(Icons.manage_search_sharp),
              label: Text(
                'Search',
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                  foregroundColor: Colors.black,
                  shadowColor: Colors.grey,
                  fixedSize: Size(Get.width / 2 - 30, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
            ),
            Container(
              color: Colors.grey[300],
              width: 2,
              height: 50,
            ),
            ElevatedButton.icon(
              onPressed: () async {
                focusNode.unfocus();
                final sortOption = await showMenu<String>(
                  context: context,
                  position: RelativeRect.fromLTRB(100, 200, 0, 0),
                  items: [
                    PopupMenuItem<String>(
                        value: '${sortOpts[1]}',
                        child: Text('By ${sortOpts[0]}')),
                    PopupMenuItem<String>(
                        value: '${sortOpts[3]}',
                        child: Text('By ${sortOpts[2]}')),
                  ],
                  elevation: 8.0,
                );
                if (sortOption != null)
                  controller.changeSortOptions(sortOption);
              },
              icon: Icon(Icons.sort_sharp),
              label: Text(
                'Sort',
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                  foregroundColor: Colors.black,
                  shadowColor: Colors.grey,
                  fixedSize: Size(Get.width / 2 - 30, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
            )
          ],
        ),
        SizedBox(height: 20),
        Container(
          color: ColorConstants.greenish_clr,
          width: Get.width - 100,
          height: 2,
        ),
      ],
    ),
  );
}

Widget OptionsBarForTstore(
    BuildContext context, TOrdersController controller, List sortOpts) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: Column(
      children: [
        SizedBox(height: 10),
        Obx(() {
          return CupertinoSegmentedControl(
            padding: EdgeInsets.zero,
            borderColor: Color(0xfffafafa),
            pressedColor: Color(0xfffafafa),
            selectedColor: ColorConstants.blachish_clr,
            unselectedColor: Color(0xfffafafa),
            groupValue: controller.state.stepIndex.value,
            children: {
              0: buildSegment('InComing'),
              '': buildSegment('OR'),
              1: buildSegment('OnGoing'),
            },
            onValueChanged: (val) {
              if (val.toString().length > 0)
                controller.state.stepIndex.value = int.parse(val.toString());
            },
          );
        }),
      ],
    ),
  );
}

Widget buildSegment(String text) {
  return Container(
    // width: Get.width/3,
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    child: Text(
      text,
      style: TextStyle(
          fontSize: 20,
          color: text == 'OR' ? ColorConstants.purple_clr : null,
          fontWeight: text == 'OR' ? FontWeight.bold : null),
    ),
  );
}
