import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'notificationsclient_index.dart';

class NotificationsClientController extends GetxController {
  NotificationsClientController();
  final state = NotificationsClientState();

  Future downloadDocument(String url) async {
    final dl_url = Uri.parse(url);
    await launchUrl(
      dl_url,
      mode: LaunchMode.externalApplication,
    );
  }
}
