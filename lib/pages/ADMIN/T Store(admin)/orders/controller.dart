import 'package:get/get.dart';
import 'package:tssr_ctrl/services/database_service.dart';
import 'torders_index.dart';

class TOrdersController extends GetxController {
  TOrdersController();
  final state = TOrdersState();

   @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    //
    state.query.value =
        DatabaseService.OrderCollection.orderBy('book').where('');
    // update();
  }

  void changeSortOptions(String sortOption) {
    if (sortOption != null) {
      state.query.value = DatabaseService.OrderCollection.orderBy(sortOption);
    }
  }

  void searchByString(String searchString) {
    state.query.value = DatabaseService.OrderCollection
        .orderBy('book')
        .where('book', isGreaterThanOrEqualTo: '$searchString')
        .where('book', isLessThanOrEqualTo: '$searchString\uf8ff');
    // .where('reg_no', isEqualTo: '$searchString')
    // .where('reg_no', isEqualTo: '$searchString\uf8ff');
  }
}
