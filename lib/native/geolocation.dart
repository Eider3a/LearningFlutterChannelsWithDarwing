import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get/state_manager.dart';

enum PermissionStatus{
  unknown,
  granted,
  denied,
  restricted
}

//! Se va a crear un channel para obtener la ubicacion nativamente (Codigo Java).
class Geolocation {

  //* Singleton para trabajar con esta clase.
  Geolocation._internal(); // Constructor.
  static Geolocation _instance = Geolocation._internal(); // Instancia static.
  static Geolocation get instance => _instance; // Metodo para obtener la instancia.

  //! El MethodChannel solo se dispara una vez y entrega un dato. (No se mantiene entregando datos)
  final _methodChannel = MethodChannel("app.eider/geolocation");
  
  //! Si quiero algo que se mantenga escuchando constantemente debo usar un EventChannel.
  //! El EventChannel se mantiene escuchando constantemente datos que nos envie el host(Anndroid)
  final _eventChannel = EventChannel("app.eider/geolocation_listener");
  StreamSubscription? _streamSubscription;

  // Creacion de un observable para desplegar la ubicacion en la pantalla del celular.
  RxString _locationFromNative = "".obs;
  RxString get locationFromNative => _locationFromNative; // getter.


  //! Listener para el EventChannel, este metodo estara obteniendo periodicamente el valor del GPS.
  void init() {
    // event es un tipo de dato de los que aparecen en la documentacion(string, int, double, list, etc)
    _streamSubscription = _eventChannel.receiveBroadcastStream().listen((event) {
      print("🤩 $event");
      // event es lo que envio desde el codigo nativo, en este caso se esta enviando un map.
      _locationFromNative.value = "${event['lat']},${event['lng']}";
    });
  }

  //! Libero los recursos de mi app.
  void dispose() { 
    _streamSubscription?.cancel();
  }


  //! Metodo para verificar el estado de los permisos en Android/iOS.
  Future<PermissionStatus> checkPermission() async {
    final String? result = await this._methodChannel.invokeMethod<String>("check_permissions");
    
    return this._getStatus(result);

  }

  //! Metodo para solicitar los permisos en Android/iOS.
  Future<PermissionStatus> requestPermission() async {
    final String? result = await this._methodChannel.invokeMethod<String>("request_permissions");
    
    return this._getStatus(result);

  }

  //! Le indico a la plataforma que comienze a leer los datos del GPS.
  Future<void> startGettingLocation() async {
    await this._methodChannel.invokeMethod("start_listening_gps");
  }

  //! Le indico a la plataforma que detenga la lectura del GPS.
  Future<void> stopGettingLocation() async {
    await this._methodChannel.invokeMethod("stop_listening_gps");
  }

  PermissionStatus _getStatus(String? result) {

    switch (result) {
      case "granted":
        return PermissionStatus.granted;
      case "denied":
        return PermissionStatus.denied;
      default:
        return PermissionStatus.unknown;
    }
    
  }

}