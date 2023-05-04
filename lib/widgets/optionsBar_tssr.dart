import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/constants/colors.dart';
import 'package:tssr_ctrl/pages/ADMIN/TSSR%20Page/tssrpage_index.dart';
import 'package:tssr_ctrl/services/authentication_service.dart';
import 'package:tssr_ctrl/services/database_service.dart';

Widget OptionsBar(BuildContext context, controller, List sortOpts) {
  final textCtrl = TextEditingController();
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
                  controller: textCtrl,
                  style: TextStyle(fontSize: 17),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () async {
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
                final sortOption = await showMenu<String>(
                  context: context,
                  position: RelativeRect.fromLTRB(100, 100, 0, 0),
                  items: [
                    PopupMenuItem<String>(
                        child: const Text(
                          'Delete All',
                          style: TextStyle(color: Colors.red),
                        ),
                        value: '1'),
                    PopupMenuItem<String>(
                        child: const Text(
                          'Refresh',
                          style: TextStyle(color: Colors.blue),
                        ),
                        value: '2'),
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
                final sortOption = await showMenu<String>(
                  context: context,
                  position: RelativeRect.fromLTRB(100, 200, 0, 0),
                  items: [
                    PopupMenuItem<String>(
                        child: Text('By ${sortOpts[0]}'),
                        value: '${sortOpts[1]}'),
                    PopupMenuItem<String>(
                        child: Text('By ${sortOpts[2]}'),
                        value: '${sortOpts[3]}'),
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
