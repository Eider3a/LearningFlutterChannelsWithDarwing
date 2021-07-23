import 'package:flutter/material.dart';

import 'package:get/get_navigation/get_navigation.dart';
import 'package:section4_channels_android_swift/native/geolocation.dart';

import 'package:section4_channels_android_swift/pages/home_page.dart';
import 'package:section4_channels_android_swift/pages/request_page.dart';
import 'package:section4_channels_android_swift/pages/splash_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp( // Ya que vamos a usar getx para navegar entre pantallas.
      title: 'Channels',
      debugShowCheckedModeBanner: false,
      onInit: () {
        // Para estar escuchando por medio de un EventChannel el cambio del gps.
        Geolocation.instance.init();
      },
      onDispose: () {
        // Detengo la escucha del gps.
        Geolocation.instance.dispose();
      },
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: SplashPage(),
      routes: {
        'home': (BuildContext context) => HomePage(),
        'request': (BuildContext context) => RequestPage(),
      },
    );
  }
}

//! Se esta gestionando el estado de cada pagina con un GetXController.
//! Cada pagina tiene su propio archivo para manejar su estado.