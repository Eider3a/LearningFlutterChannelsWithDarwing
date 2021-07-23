import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get_state_manager/get_state_manager.dart';

import 'package:section4_channels_android_swift/controllers/request_controller.dart';

// Esta clase es para preguntarle alñ usuario por el permiso para activar el gps.
class RequestPage extends StatelessWidget {
  const RequestPage({Key? key}) : super(key: key);

  final String title = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. " +
    "Nulla quis mauris augue. Donec sit amet sem vehicula, rutrum nunc at, efficitur ipsum." +
    "Maecenas in viverra mauris. Aliquam erat volutpat. Nam quis rutrum elit, nec auctor est. " +
    "In hac habitasse platea dictumst. Nullam ultricies iaculis lacinia. In at pellentesque turpis," +
    "quis tristique diam.";

  @override
  Widget build(BuildContext context) {

    return GetBuilder<RequestController>(
      init: RequestController(),
      builder: (RequestController requestController) {
        
        return SafeArea(
          child: Scaffold(
            body: Container(
              width: double.infinity,
              height: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    this.title,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  CupertinoButton(
                    child: Text(
                      'ALLOW GPS',
                      style: TextStyle(
                        letterSpacing: 1.0
                      ),
                    ),
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20.0),
                    onPressed: (){
                      // Realizo la peticion al controller, del controller pasa a la clase
                      // - Geolocation y de esta se la peticion por medio de channels
                      // - a Android (se usa codigo nativo para pedir los permisos)
                      requestController.request();
                    }
                  )
                ],
              ),
            ),
          ),
        );

      },
    );
  }
}