import 'package:get/get.dart';
import 'package:tssr_ctrl/services/database_service.dart';
import 'tssrpage_index.dart';

class TssrPageController extends GetxController {
  TssrPageController();
  final state = TssrPageState();

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    //
    state.query.value =
        DatabaseService.tssrCollection.orderBy('name').where('');
    // update();
  }

  void changeSortOptions(String sortOption) {
    if (sortOption != null) {
      state.query.value = DatabaseService.tssrCollection.orderBy(sortOption);
    }
  }

  void searchByString(String searchString) {
    state.query.value = DatabaseService.tssrCollection
        .orderBy('name')
        .where('name', isGreaterThanOrEqualTo: '$searchString')
        .where('name', isLessThanOrEqualTo: '$searchString\uf8ff');
    // .where('reg_no', isEqualTo: '$searchString')
    // .where('reg_no', isEqualTo: '$searchString\uf8ff');
  }

  void deleteFromList(index) {
    state.detailsList.value.removeWhere((element) {
      return element['reg_no'] == index['reg_no'];
    });
    state.detailsList.refresh();
  }
}
