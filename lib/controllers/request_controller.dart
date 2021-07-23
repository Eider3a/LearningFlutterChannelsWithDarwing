import 'package:get/route_manager.dart';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:section4_channels_android_swift/native/geolocation.dart';

class RequestController extends GetxController {
  
  Future<void> request() async {
    final PermissionStatus status = await Geolocation.instance.requestPermission();

    // Nos dieron acceso a la ubicacion del dispositivo.
    if (status == PermissionStatus.granted) {
      
      // Voy a home y elimino la pagina en la que me encuentro para que no se pueda
      // - devolver.
      Get.offNamed('home');

    }

  }

}