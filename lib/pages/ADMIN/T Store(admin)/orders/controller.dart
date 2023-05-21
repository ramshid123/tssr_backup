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
    state.inComingquery.value = DatabaseService.OrderCollection.orderBy('book')
        .where('accepted', isEqualTo: 'false');

    state.onGoingquery.value = DatabaseService.OrderCollection.orderBy('book')
        .where('accepted', isEqualTo: 'true');
    // update();
  }

  void changeSortOptions(String sortOption, bool isIncoming) {
    if (sortOption != null) {
      isIncoming
          ? state.inComingquery.value = DatabaseService.OrderCollection.where(
                  'accepted',
                  isEqualTo: 'false')
              .orderBy(sortOption)
          : state.onGoingquery.value = DatabaseService.OrderCollection.where(
                  'accepted',
                  isEqualTo: 'true')
              .orderBy(sortOption);
    }
    
  }

  void searchByString(String searchString, bool isIncoming) {
    isIncoming
        ? state.inComingquery.value = DatabaseService.OrderCollection.where(
                'accepted',
                isEqualTo: 'false')
            .orderBy('book')
            .where('book', isGreaterThanOrEqualTo: '$searchString')
            .where('book', isLessThanOrEqualTo: '$searchString\uf8ff')
        : state.onGoingquery.value =
            DatabaseService.OrderCollection.where('accepted', isEqualTo: 'true')
                .orderBy('book')
                .where('book', isGreaterThanOrEqualTo: '$searchString')
                .where('book', isLessThanOrEqualTo: '$searchString\uf8ff');
    // .where('reg_no', isEqualTo: '$searchString')
    // .where('reg_no', isEqualTo: '$searchString\uf8ff');
  }
}
