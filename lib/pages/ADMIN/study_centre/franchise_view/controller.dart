import 'package:get/get.dart';
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
        DatabaseService.FranchiseCollection.orderBy('centre_name').where('');
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
            .where('centre_name', isGreaterThanOrEqualTo: '$searchString')
            .where('centre_name', isLessThanOrEqualTo: '$searchString\uf8ff');
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
        .where('course', isGreaterThanOrEqualTo: '$searchString')
        .where('course', isLessThanOrEqualTo: '$searchString\uf8ff');
    update();
  }
}
