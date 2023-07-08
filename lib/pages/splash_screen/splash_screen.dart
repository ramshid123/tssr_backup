import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:tssr_ctrl/routes/names.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  void _onInit(Artboard artboard) {
    final ctrl =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');
    artboard.addController(ctrl!);
  }

  void navigate() async {
    await Future.delayed(3.seconds, () {
      Get.offAllNamed(AppRouteNames.LOGIN);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 30, width: double.infinity),
          SizedBox(
            width: Get.width * 0.4,
            height: Get.width * 0.4,
            child: RiveAnimation.asset(
              'assets/tssr_anim.riv',
              onInit: _onInit,
            ),
          ),
        ],
      ),
    );
  }
}
