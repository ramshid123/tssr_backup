import 'package:get/get.dart';
import 'package:tssr_ctrl/services/database_service.dart';
import 'hallticketpage_index.dart';

class HallTicketPageController extends GetxController{
  HallTicketPageController();
  final state = HallTicketPageState();


  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    //
    state.query.value =
        DatabaseService.hallTKTCollection.orderBy('name').where('');
    // update();
  }

  void changeSortOptions(String sortOption) {
    if (sortOption != null) {
      state.query.value = DatabaseService.hallTKTCollection.orderBy(sortOption);
    }
  }

  void searchByString(String searchString) {
    state.query.value = DatabaseService.hallTKTCollection
        .orderBy('name')
        .where('name', isGreaterThanOrEqualTo: '$searchString')
        .where('name', isLessThanOrEqualTo: '$searchString\uf8ff');
    // .where('reg_no', isEqualTo: '$searchString')
    // .where('reg_no', isEqualTo: '$searchString\uf8ff');
  }
}
