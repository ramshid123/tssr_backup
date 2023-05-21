import 'package:get/get.dart';
import 'package:tssr_ctrl/services/authentication_service.dart';
import 'package:tssr_ctrl/services/database_service.dart';
import 'studentpage_index.dart';

class StudentPageController extends GetxController{
  StudentPageController();
  final state = StudentPageState();

    @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    state.query.value =
        DatabaseService.StudentDetailsCollection.orderBy('st_name').where('uploader', isEqualTo: AuthService.auth.currentUser!.uid);
  }



 void changeSortOptions(String sortOption) {
    if (sortOption != null) {
      state.query.value = DatabaseService.StudentDetailsCollection.where('uploader', isEqualTo: AuthService.auth.currentUser!.uid).orderBy(sortOption);
    }
  }


  void searchByString(String searchString) {
    state.query.value = DatabaseService.StudentDetailsCollection
        .orderBy('st_name')
        .where('uploader', isEqualTo: AuthService.auth.currentUser!.uid)
        .where('st_name', isGreaterThanOrEqualTo: '$searchString')
        .where('st_name', isLessThanOrEqualTo: '$searchString\uf8ff');
    // .where('reg_no', isEqualTo: '$searchString')
    // .where('reg_no', isEqualTo: '$searchString\uf8ff');
  }
}
