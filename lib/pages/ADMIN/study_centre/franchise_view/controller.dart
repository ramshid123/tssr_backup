import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tssr_ctrl/pages/ADMIN/study_centre/franchise_view/pdf_creation.dart';
import 'package:tssr_ctrl/routes/names.dart';
import 'package:tssr_ctrl/routes/shared_pref_strings.dart';
import 'package:tssr_ctrl/services/authentication_service.dart';
import 'package:tssr_ctrl/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'franchisepage_index.dart';

class FranchisePageController extends GetxController {
  FranchisePageController();
  final state = FranchisePageState();

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    //
    state.query.value =
        DatabaseService.FranchiseCollection.orderBy('centre_name');
    // update();
  }

  void changeSortOptions(String sortOption) {
    if (sortOption != null) {
      state.query.value =
          DatabaseService.FranchiseCollection.orderBy(sortOption);
    }
  }

  void searchByString(String searchString) {
    state.query.value =
        DatabaseService.FranchiseCollection.orderBy('centre_name')
            .where('centre_name',
                isGreaterThanOrEqualTo: '${searchString.toUpperCase()}')
            .where('centre_name',
                isLessThanOrEqualTo: '${searchString.toUpperCase()}\uf8ff');

    // .where('reg_no', isEqualTo: '$searchString')
    // .where('reg_no', isEqualTo: '$searchString\uf8ff');
  }

  // Future editCourse() async {
  //   final tempMyCourses = await DatabaseService.FranchiseCollection.where('atc',
  //           isEqualTo: state.atc.text)
  //       .get();
  //   state.docIdOfFranchise = tempMyCourses.docs.first.id;
  // }

  Future addCourseToList(String course, String doc_id) async {
    try {
      await DatabaseService.FranchiseCollection.doc(doc_id).update({
        'courses': FieldValue.arrayUnion([course])
      }).then((value) => print('done'));
    } catch (e) {
      print(e);
    }
  }

  Future removeCourseFromList(String course, String doc_id) async {
    try {
      await DatabaseService.FranchiseCollection.doc(doc_id).update({
        'courses': FieldValue.arrayRemove([course])
      }).then((value) => print('done'));
    } catch (e) {
      print(e);
    }
  }

  Future searchCourseUsingGivenString(String searchString) async {
    state.allCourseQuery = DatabaseService.CourseCollection.orderBy('course')
        .where('course',
            isGreaterThanOrEqualTo: '${searchString.toUpperCase()}')
        .where('course',
            isLessThanOrEqualTo: '${searchString.toUpperCase()}\uf8ff');
    update();
  }

  Future deleteAll() async {
    int maxSubListSize = 400;

    final dataSnapshot = await DatabaseService.FranchiseCollection.get();

    for (int i = 0; i < dataSnapshot.docs.length; i += maxSubListSize) {
      int endIndex = (i + maxSubListSize < dataSnapshot.docs.length)
          ? i + maxSubListSize
          : dataSnapshot.docs.length;
      List<QueryDocumentSnapshot<Map<String, dynamic>>> subList =
          dataSnapshot.docs.sublist(i, endIndex);

      final batch = DatabaseService.db.batch();

      for (int i = 0; i < subList.length; i++) {
        batch.delete(subList[i].reference);
      }
      await batch.commit();
    }
    Get.showSnackbar(GetSnackBar(
      title: 'Deleted',
      message: 'All Data Deleted',
      backgroundColor: Colors.green,
      duration: 5.seconds,
    ));
  }

  Future downloadAtcReport(BuildContext context) async {
    print('collecting data');
    final franchiseListSnapshot =
        await DatabaseService.FranchiseCollection.where('atc',
                isNotEqualTo: 'ADMIN')
            .get();
    print('data collection complted');
    final franchiseList =
        franchiseListSnapshot.docs.map((e) => e.data()).toList();
    if (context.mounted) {
      await createFranchiseReport(context: context, DataList: franchiseList);
    }
  }

  Future loginAsFranchise(
      {required String email, required String password}) async {
    try {
      AuthService().logout();
      await Future.delayed(1.seconds);
      await AuthService().login(email, password);
      final sf = await SharedPreferences.getInstance();
      await sf.setBool(SharedPrefStrings.FROM_ADMIN, true);
    } catch (e) {
      print(e);
    }
  }

  Future changePassword(
      {required String email,
      required String password,
      required String docId}) async {
    final passwordCont = TextEditingController();
    await Get.defaultDialog(
        title: 'Change password',
        content: Column(
          children: [
            TextFormField(
              controller: passwordCont,
              decoration: InputDecoration(
                hintText: 'New Password',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (passwordCont.text.isNotEmpty &&
                    passwordCont.text.length > 6) {
                  final sf = await SharedPreferences.getInstance();
                  final adminPassword =
                      sf.getString(SharedPrefStrings.PASSWORD);
                  final adminEmail = sf.getString(SharedPrefStrings.EMAIL);
                  try {
                    // final sf = await SharedPreferences.getInstance();
                    // final adminPassword =
                    //     sf.getString(SharedPrefStrings.PASSWORD);
                    // final adminEmail = sf.getString(SharedPrefStrings.EMAIL);

                    await DatabaseService.FranchiseCollection.doc(docId)
                        .update({
                      'password': passwordCont.text,
                    });

                    await AuthService().logout();
                    await Future.delayed(100.milliseconds);
                    await AuthService().login(email, password);
                    await Future.delayed(100.milliseconds);
                    await AuthService.auth.currentUser!
                        .updatePassword(passwordCont.text);
                    await Future.delayed(100.milliseconds);
                    await AuthService().logout();
                    await Future.delayed(100.milliseconds);
                    await AuthService().login(
                        adminEmail ?? 'admin@support.com', adminPassword ?? '12341234');
                    await Future.delayed(100.milliseconds);
                    await Get.toNamed(AppRouteNames.FRANCHISE_DATA);
                  } catch (e) {
                    await DatabaseService.FranchiseCollection.doc(docId)
                        .update({'password': password});
                    await Future.delayed(100.milliseconds);
                    await AuthService().logout();
                    await Future.delayed(100.milliseconds);
                    await AuthService().login(
                        adminEmail ?? 'admin@support.com', adminPassword ?? '12341234');
                    await Future.delayed(100.milliseconds);
                    await Get.toNamed(AppRouteNames.FRANCHISE_DATA);
                  }
                }
              },
              child: Text('Change'),
            ),
          ],
        ));
  }

  Future<bool?> changeClientAccessToReports({required String docId}) async {
    try {
      final docSnapshot = await DatabaseService.FranchiseCollection.where(
              'doc_id',
              isEqualTo: docId)
          .get();
      final newValue =
          docSnapshot.docs.first.data()['can_access_report'] == null ||
                  docSnapshot.docs.first.data()['can_access_report']
              ? false
              : true;
      await DatabaseService.FranchiseCollection.doc(docId).update({
        'can_access_report': newValue,
      });
      return newValue;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
