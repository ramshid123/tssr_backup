import 'package:get/get.dart';
import 'package:tssr_ctrl/services/database_service.dart';
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
      state.query.value = DatabaseService.FranchiseCollection.orderBy(sortOption);
    }
  }

  void searchByString(String searchString) {
    state.query.value = DatabaseService.FranchiseCollection
        .orderBy('centre_name')
        .where('centre_name', isGreaterThanOrEqualTo: '$searchString')
        .where('centre_name', isLessThanOrEqualTo: '$searchString\uf8ff');
    // .where('reg_no', isEqualTo: '$searchString')
    // .where('reg_no', isEqualTo: '$searchString\uf8ff');
  }
}
