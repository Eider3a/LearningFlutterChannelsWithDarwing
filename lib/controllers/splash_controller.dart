import 'package:get/route_manager.dart';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:section4_channels_android_swift/native/geolocation.dart';

// Esto va asociado al splash. El ciclo de vida de esa pagina la conectamos con este archivo.
class SplashController extends GetxController {


  // Verificamos si tenemos permiso para leer los datos del GPS.
  @override
  void onReady() {
    super.onReady();
    this._init(); // Verifico los permisos.
  }

  // Verifico si los permisos estan dados al usuario.
  Future<void> _init() async {

    //! Pequeño retraso para ver el cambio de pantalla.
    await Future.delayed(new Duration(seconds: 3));
    final PermissionStatus status = await Geolocation.instance.checkPermission();

    if (status == PermissionStatus.granted) {
      // TODO: Tenemos accesso a la ubicacion, debemos irnos al HomePage y desplegar las coordenadas.
      
      // Nos vamos al home y eliminamos del stack la pantalla del splash.
      Get.offNamed('home');
    } else {
      // TODO: No hay accesso a la ubicacion, debemos ir a la pagina para pedir el permiso.
      
      // Nos vamos a la pagina de request y eliminamos del stack la pantalla del splash.
      Get.offNamed('request');
    }

  }

}