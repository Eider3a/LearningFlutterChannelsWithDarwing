import 'package:flutter/material.dart';

import 'package:get/get_state_manager/get_state_manager.dart';

import 'package:section4_channels_android_swift/controllers/splash_controller.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      init: SplashController(), // Se la pasa una instancia de splash controller.
      builder: (SplashController splashController){
        return SafeArea(
          child: Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}