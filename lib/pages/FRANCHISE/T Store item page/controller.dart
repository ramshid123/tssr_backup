import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tssr_ctrl/constants/colors.dart';
import 'package:tssr_ctrl/routes/names.dart';
import 'package:tssr_ctrl/services/authentication_service.dart';
import 'package:tssr_ctrl/services/database_service.dart';
import 'tstoreitempage_index.dart';
import 'package:tssr_ctrl/routes/shared_pref_strings.dart';

class TStoreItemPageController extends GetxController {
  TStoreItemPageController();
  final state = TStoreItemPageState();

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    state.quantity.text = '1';
    state.total.value = double.parse(Get.arguments['price']);
  }

  void onQuantitiyChanges() {
    if (int.parse(state.quantity.text) == 0) {
      state.quantity.text = '1';
      state.total.value = double.parse(Get.arguments['price']);
    } else if (state.quantity.text == '') {
      state.total.value = double.parse(Get.arguments['price']);
    } else {
      state.total.value =
          double.parse(Get.arguments['price']) * int.parse(state.quantity.text);
    }
  }

  void increamentQuantity() {
    if (state.quantity.text == '') {
      state.quantity.text = 1.toString();
      state.total.value = double.parse(Get.arguments['price']);
    } else {
      state.quantity.text = (int.parse(state.quantity.text) + 1).toString();
      state.total.value =
          double.parse(Get.arguments['price']) * int.parse(state.quantity.text);
    }
  }

  void decreamentQuantity() {
    if (int.parse(state.quantity.text) > 1) {
      state.quantity.text = (int.parse(state.quantity.text) - 1).toString();
      state.total.value =
          double.parse(Get.arguments['price']) * int.parse(state.quantity.text);
    }
  }

  Future placeOrder() async {
    state.isLoading.value = true;
    try {
      final sf = await SharedPreferences.getInstance();
      final doc_id = await sf.getString(SharedPrefStrings.DOC_ID);
      final name = await sf.getString(SharedPrefStrings.CENTRE_NAME);
      final atc = await sf.getString(SharedPrefStrings.ATC);
      final place = await sf.getString(SharedPrefStrings.PLACE);
      final head = await sf.getString(SharedPrefStrings.CENTRE_HEAD);
      final email = await sf.getString(SharedPrefStrings.EMAIL);

      final info = Get.arguments;
      final newDoc = DatabaseService.OrderCollection.doc();
      await DatabaseService.OrderCollection.doc(newDoc.id).set({
        'doc_id': newDoc.id,
        'book': info['name'],
        'course': info['course'],
        'quantity': state.quantity.text == 0 || state.quantity.text == ''
            ? '1'
            : state.quantity.text,
        'total': state.total.value,
        'single': info['price'],
        'buyer_doc_id': doc_id,
        'buyer_uid': AuthService.auth.currentUser!.uid,
        'buyer_name': name,
        'buyer_atc': atc,
        'buyer_place': place,
        'buyer_head': head,
        'buyer_email': email,
        'date': DateTime.now(),
        'Epoch': DateTime.now().millisecondsSinceEpoch,
      }).then((value) => Get.toNamed(AppRouteNames.ORDER_SUCCESS, arguments: newDoc.id));
    } catch (e) {
      print(e);
    } finally {
      state.isLoading.value = false;
    }
  }
}
