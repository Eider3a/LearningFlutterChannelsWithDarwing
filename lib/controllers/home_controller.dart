
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';
import 'package:section4_channels_android_swift/native/geolocation.dart';

class HomeController extends GetxController {

  bool _trackingGPS = false;
  bool get tracking => this._trackingGPS;


  // Inicia nativamente la lectura del GPS.
  Future<void> startTracking() async {
    this._trackingGPS = true;
    await Geolocation.instance.startGettingLocation();
    //! Solo redibuja a los que tienen el id = 'tracking'
    update(['tracking']);
  }

  // Detiene la lectura del GPS desde codigo nativo.
  Future<void> stopTracking() async {
    this._trackingGPS = false;
    await Geolocation.instance.stopGettingLocation();
    //! Solo redibuja a los que tienen el id = 'tracking'
    update(['tracking']);
  }



}