import 'package:get/get.dart';
import 'package:rive/rive.dart';

class OrderSuccessState{
  final defaultDuration = Duration(seconds: 1);
  SMITrigger? trigger;


  var received_pad = 130.0.obs;
  var received_op = 0.0.obs;

  var thank_pad = 500.0.obs;
  var thank_op = 0.0.obs;

  var id_pad = 550.0.obs;
  var id_op = 0.0.obs;

  var btn_pad = 650.0.obs;
  var btn_op = 0.0.obs;
}
