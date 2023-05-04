import 'package:get/get.dart';
import 'tstorepage_index.dart';
import 'package:tssr_ctrl/services/database_service.dart';

class TStorePageController extends GetxController{
  TStorePageController();
  final state = TStorePageState();

   @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    //
    state.query.value =
        DatabaseService.hallTKTCollection.orderBy('book').where('');
    // update();
  }

  void changeSortOptions(String sortOption) {
    if (sortOption != null) {
      state.query.value = DatabaseService.hallTKTCollection.orderBy(sortOption);
    }
  }

  void searchByString(String searchString) {
    state.query.value = DatabaseService.hallTKTCollection
        .orderBy('book')
        .where('book', isGreaterThanOrEqualTo: '$searchString')
        .where('book', isLessThanOrEqualTo: '$searchString\uf8ff');
    // .where('reg_no', isEqualTo: '$searchString')
    // .where('reg_no', isEqualTo: '$searchString\uf8ff');
  }
}
