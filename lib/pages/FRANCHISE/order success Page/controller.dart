import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'ordersuccess_index.dart';

class OrderSuccessController extends GetxController {
  OrderSuccessController();
  final state = OrderSuccessState();

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();

    await Future.delayed(Duration(milliseconds: 100));
    state.trigger!.fire();

    await Future.delayed(Duration(seconds: 1));
    state.received_pad.value = 180;
    state.received_op.value = 1;

    await Future.delayed(Duration(milliseconds: 500));
    state.thank_pad.value = 450;
    state.thank_op.value = 1;

    await Future.delayed(Duration(milliseconds: 500));
    state.id_pad.value = 490;
    state.id_op.value = 1;

    await Future.delayed(Duration(milliseconds: 500));
    state.btn_pad.value = 600;
    state.btn_op.value = 1;
  }

  void onRiveInit(Artboard artboard) {
    final controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');
    artboard.addController(controller!);
    state.trigger = controller.findSMI('Trigger 1');
  }
}
