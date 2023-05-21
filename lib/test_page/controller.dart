import 'package:get/get.dart';
import 'package:tssr_ctrl/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'testpage_index.dart';

class TestPageController extends GetxController {
  TestPageController();
  final state = TestPageState();

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();

    final tempMyCourses = await DatabaseService.FranchiseCollection.where('atc',
            isEqualTo: 'AB00CDS1')
        .get();
    state.docIdOfFranchise = tempMyCourses.docs.first.id;
  }

  Future addCourseToList(String course) async {
    try {
      await DatabaseService.FranchiseCollection.doc(state.docIdOfFranchise)
          .update({
        'courses': FieldValue.arrayUnion([course])
      }).then((value) => print('done'));
    } catch (e) {
      print(e);
    }
  }

  Future removeCourseFromList(String course) async {
    try {
      await DatabaseService.FranchiseCollection.doc(state.docIdOfFranchise)
          .update({
        'courses': FieldValue.arrayRemove([course])
      }).then((value) => print('done'));
    } catch (e) {
      print(e);
    }
  }

  Future searchUsingGivenString(String searchString) async {
    state.allCourseQuery = DatabaseService.CourseCollection.orderBy('course')
        .where('course', isGreaterThanOrEqualTo: '$searchString')
        .where('course', isLessThanOrEqualTo: '$searchString\uf8ff');
    update();
  }
}
