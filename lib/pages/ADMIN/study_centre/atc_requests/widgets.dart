import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/pages/ADMIN/study_centre/atc_requests/controller.dart';

Widget atcRequestTile({
  required QueryDocumentSnapshot<Map<String, dynamic>> doc,
  required AtcRequestsPageController controller,
}) {
  return Container(
    padding: EdgeInsets.all(20),
    margin: EdgeInsets.symmetric(vertical: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        atcRequestTileElement(
            title: 'Centre Name', content: doc.data()['centre_name']),
        SizedBox(height: 15),
        atcRequestTileElement(
            title: 'Centre Head', content: doc.data()['centre_head']),
        SizedBox(height: 15),
        atcRequestTileElement(title: 'City', content: doc.data()['city']),
        SizedBox(height: 15),
        atcRequestTileElement(
            title: 'District', content: doc.data()['district']),
        SizedBox(height: 15),
        atcRequestTileElement(title: 'Place', content: doc.data()['place']),
        SizedBox(height: 15),
        atcRequestTileElement(title: 'Pincode', content: doc.data()['pincode']),
        SizedBox(height: 15),
        atcRequestTileElement(
            title: 'Phone No', content: doc.data()['phone_no']),
        SizedBox(height: 15),
        Row(
          children: [
            acceptButton(controller: controller, doc: doc),
            SizedBox(width: 50),
            rejectButton(controller: controller, docId: doc.data()['id']),
          ],
        )
      ],
    ),
  );
}

Widget atcRequestTileElement({required String title, required String content}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
          color: Colors.grey[700],
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 7),
      Text(
        content,
        style: TextStyle(fontSize: 15),
      ),
      SizedBox(height: 7),
      Container(
        height: 1,
        width: Get.width,
        color: Colors.black,
      ),
    ],
  );
}

Widget acceptButton({
  required AtcRequestsPageController controller,
  required QueryDocumentSnapshot<Map<String, dynamic>> doc,
}) {
  return GestureDetector(
    onTap: () async => await controller.acceptRequest(doc: doc),
    child: Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        'Accept',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

Widget rejectButton(
    {required AtcRequestsPageController controller, required String docId}) {
  return GestureDetector(
    onTap: () async => await controller.deleteRequest(docId: docId),
    child: Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        'Reject',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
