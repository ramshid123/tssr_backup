import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:tssr_ctrl/constants/colors.dart';
import 'package:tssr_ctrl/pages/FRANCHISE/order%20success%20Page/ordersuccess_index.dart';
import 'package:tssr_ctrl/routes/names.dart';

class OrderSuccessPage extends GetView<OrderSuccessController> {
  const OrderSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(
      child: Obx(() {
        return SizedBox(
          width: Get.width,
          height: Get.height,
          child: Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              // SizedBox(height: 100),
              AnimatedPositioned(
                curve: Curves.easeInOut,
                duration: controller.state.defaultDuration,
                top: controller.state.received_pad.value,
                child: AnimatedOpacity(
                  curve: Curves.easeInOut,
                  duration: controller.state.defaultDuration,
                  opacity: controller.state.received_op.value,
                  child: Text(
                    'Your order has been received',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 100,
                child: SizedBox(
                  height: 450,
                  width: Get.width,
                  child: RiveAnimation.asset(
                    'assets/success.riv',
                    onInit: controller.onRiveInit,
                  ),
                ),
              ),
              AnimatedPositioned(
                curve: Curves.easeInOut,
                duration: controller.state.defaultDuration,
                top: controller.state.thank_pad.value,
                child: AnimatedOpacity(
                  curve: Curves.easeInOut,
                  duration: controller.state.defaultDuration,
                  opacity: controller.state.thank_op.value,
                  child: Text(
                    'Thank you for your purchase !',
                    style: TextStyle(
                      fontSize: 23,
                    ),
                  ),
                ),
              ),
              // SizedBox(height: 10),
              AnimatedPositioned(
                curve: Curves.easeInOut,
                duration: controller.state.defaultDuration,
                top: controller.state.id_pad.value,
                child: AnimatedOpacity(
                  curve: Curves.easeInOut,
                  duration: controller.state.defaultDuration,
                  opacity: controller.state.id_op.value,
                  child: Text(
                    'Your order ID is ${Get.arguments}',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              // SizedBox(height: 20),
              AnimatedPositioned(
                curve: Curves.easeInOut,
                duration: controller.state.defaultDuration,
                top: controller.state.btn_pad.value,
                child: AnimatedOpacity(
                  curve: Curves.easeInOut,
                  duration: controller.state.defaultDuration,
                  opacity: controller.state.btn_op.value,
                  child: ElevatedButton(
                    onPressed: () => Get.offAllNamed(AppRouteNames.HOME_FR),
                    child: Text(
                      'Back to Home',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(Get.width - 100, 60),
                        backgroundColor: ColorConstants.blachish_clr,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                ),
              )
            ],
          ),
        );
      }),
    ));
  }
}
