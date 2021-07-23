import 'package:flutter/services.dart';

class MyFirstPlatformChannel {


  //! Identificador que tanto el cliente como el host(Android, iOS) usan para enviar datos.
  final MethodChannel _methodChannel = MethodChannel("app.eider/my_first_platform_channel");

  //! Retorna la version del sistema operativo.
  Future<void> version() async {

    try {
      //! Envio un mensaje al SO y con base en el mensaje retorno alguna respuesta.
      // Puede ser cualquier valor, pero se debe usar el mismo valor en la parte nativa.

      // final result = await _methodChannel.invokeMethod("version", "Hi Eider, Hope you get things done"); // Llamo al metodo y envio un string.

      // final result = await _methodChannel.invokeMethod("version", 20); // Llamo al metodo y envio un int.

      // final result = await _methodChannel.invokeMethod("version", [1,4,35,-34,4554]); // Llamo al metodo y envio un arreglo de numbers.

      final result = await _methodChannel.invokeMethod("version", {
        "name": "Eider A",
        "lastName": "Arango",
        "age": 28
      }); // Llamo al metodo y envio un mapa.
      
      print("😳 $result");
    } catch (e) {
      print("😡 ERROR: $e");
    }

    
  }
}