import 'package:flutter/material.dart';

import 'package:get/get_state_manager/get_state_manager.dart';

import 'package:section4_channels_android_swift/controllers/home_controller.dart';
import 'package:section4_channels_android_swift/native/geolocation.dart';
import 'package:section4_channels_android_swift/native/my_first_platform_channel.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    print('Se disparo el build del HomePage');
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (HomeController homeController){
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text('Learning Channels'),
              centerTitle: true,
            ),
            body: Center(
              child: Column(
                children: [
                  
                  ElevatedButton( //! Obtiene la version del telefono.
                    onPressed: (){
                      MyFirstPlatformChannel _myFirstPlatformChannel = MyFirstPlatformChannel();
                      _myFirstPlatformChannel.version();
                    }, 
                    child: Text('GET VERSION')
                  ),
                  _createStartStopGPSButton(homeController),
                  Obx(() {
                    return Text(Geolocation.instance.locationFromNative.value);
                  }),
                ],
              ),

            ),
          ),
        );
      },
    );
  }

  Widget _createStartStopGPSButton(HomeController homeController) {

    return GetBuilder<HomeController>(
      init: HomeController(),
      id: 'tracking',
      builder: (HomeController homeController){
        print('Se disparo el builder de _createStartStopGPSButton');
        return ElevatedButton( //! Inicia el proceso de obtener geolocalizacion.
          onPressed: (){
            if (!homeController.tracking) { // No esta trackeando el GPS.
              homeController.startTracking();
              
            }
            else {
              homeController.stopTracking();
            }
          }, 
          child: (homeController.tracking) ? Text('STOP TRACKING') : Text('START TRACKING')
        );
      },
    );
    
  }
}