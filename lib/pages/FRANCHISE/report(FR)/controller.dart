import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tssr_ctrl/routes/shared_pref_strings.dart';
import 'package:tssr_ctrl/services/authentication_service.dart';
import 'package:tssr_ctrl/services/database_service.dart';
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
    await checkForReportAccessPermission();
  }

  Future checkForReportAccessPermission() async {
    try {
      final docSnapshot = await DatabaseService.FranchiseCollection.where('uid',
              isEqualTo: AuthService.auth.currentUser!.uid)
          .get();
      state.canAccessReports =
          docSnapshot.docs.first.data()['can_access_report'];
    } catch (e) {
      print(e);
    } finally {
      update();
    }
  }
}
