import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tssr_ctrl/constants/colors.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/pages/ADMIN/T%20Store(admin)/books/controller.dart';
import 'package:tssr_ctrl/routes/names.dart';
import 'package:tssr_ctrl/services/database_service.dart';
import 'package:tssr_ctrl/widgets/tssr.dart';

Widget TStoreCardAdmin(BuildContext context, Map<String, dynamic> doc) {
  return Dismissible(
    key: Key(doc['doc_id']),
    background: Container(
      color: Colors.red,
      child: Row(
        children: [
          Icon(
            Icons.delete,
            size: 50,
            color: Colors.white,
          ),
          Spacer(),
        ],
      ),
    ),
    secondaryBackground: Container(
      color: Colors.blue,
      child: Row(
        children: [
          Spacer(),
          Icon(
            Icons.edit,
            size: 50,
            color: Colors.white,
          ),
        ],
      ),
    ),
    onDismissed: (val) async {
      try {
        await DatabaseService.StoreCollection.doc(doc['doc_id']).delete();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            duration: 10.seconds,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Undo the delete',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                IconButton(
                    color: Colors.white,
                    onPressed: () async {
                      await DatabaseService.StoreCollection.doc(doc['doc_id'])
                          .set({
                        'doc_id': doc['doc_id'],
                        'course': doc['course'],
                        'desc': doc['desc'],
                        'name': doc['name'],
                        'price': doc['price'],
                      }).then((value) => ScaffoldMessenger.of(context)
                              .hideCurrentSnackBar());
                    },
                    icon: Icon(Icons.undo))
              ],
            ),
          ),
        );
      } catch (e) {
        print(e);
      }
    },
    confirmDismiss: (direction) async {
      if (direction == DismissDirection.endToStart) {
        final homectrl = TBooksController();
        await Get.bottomSheet(
          Container(
            padding: EdgeInsets.all(20),
            height: Get.height * 0.75,
            color: Color.fromRGBO(255, 255, 255, 1),
            child: SingleChildScrollView(
              child: Form(
                key: homectrl.state.editFormKey,
                child: Column(
                  children: [
                    EditBoxFormField('Name', homectrl.state.name, doc['name']),
                    EditBoxFormField(
                        'Course', homectrl.state.course, doc['course']),
                    EditBoxFormField(
                        'Description', homectrl.state.desc, doc['desc']),
                    EditBoxFormField(
                        'Price', homectrl.state.price, doc['price']),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (homectrl.state.editFormKey.currentState!
                            .validate()) {
                          try {
                            await DatabaseService.StoreCollection.doc(
                                    doc['doc_id'])
                                .update({
                              'name': homectrl.state.name.text,
                              'course': homectrl.state.course.text,
                              'desc': homectrl.state.desc.text,
                              'price': homectrl.state.price.text,
                            }).then((value) => Navigator.of(context).pop());
                          } catch (e) {
                            print(e);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(Get.width, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      child: Text('Submit'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        return false;
      } else {
        return true;
      }
    },
    direction: DismissDirection.horizontal,
    child: GestureDetector(
      onTap: () {
        Get.bottomSheet(Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                BottomSheetItem('Book', doc['name']),
                BottomSheetItem('Course', doc['course']),
                BottomSheetItem('Description', doc['desc']),
                BottomSheetItem('Price', doc['price']),
              ],
            ),
          ),
        ));
      },
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        width: Get.width,
        decoration: BoxDecoration(
          color: ColorConstants.purple_clr.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: Get.width / 3 - 40,
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage('assets/book.png'),
                    fit: BoxFit.cover,
                  )),
            ),
            SizedBox(width: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: Get.width * 0.6,
                  child: Text(
                    doc['name'],
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: Get.width * 0.6,
                  child: Text(
                    doc['course'],
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 17,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: Get.width / 3,
                  child: Text(
                    doc['price'],
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}
