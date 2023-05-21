import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tssr_ctrl/routes/shared_pref_strings.dart';
import 'reportfranchise_index.dart';

class ReportFranchiseController extends GetxController {
  ReportFranchiseController();
  final state = ReportFranchiseState();

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    final sf = await SharedPreferences.getInstance();
    state.franchiseName = sf.getString(SharedPrefStrings.CENTRE_NAME);
  }
}
