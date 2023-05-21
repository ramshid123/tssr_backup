import 'package:get/get.dart';
import 'tsscpage_index.dart';
import 'package:tssr_ctrl/services/database_service.dart';

class TsscPageController extends GetxController{
  TsscPageController();
  final state = TsscPageState();


  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    //
    state.query.value =
        DatabaseService.tsscCollection.orderBy('name').where('');
    // update();
  }

  void changeSortOptions(String sortOption) {
    if (sortOption != null) {
      state.query.value = DatabaseService.tsscCollection.orderBy(sortOption);
    }
  }

  void searchByString(String searchString) {
    state.query.value = DatabaseService.tsscCollection
        .orderBy('name')
        .where('name', isGreaterThanOrEqualTo: '$searchString')
        .where('name', isLessThanOrEqualTo: '$searchString\uf8ff');
    // .where('reg_no', isEqualTo: '$searchString')
    // .where('reg_no', isEqualTo: '$searchString\uf8ff');
  }
}
