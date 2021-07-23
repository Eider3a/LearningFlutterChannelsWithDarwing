package com.example.section4_channels_android_swift;

import android.content.Context;
import android.os.Build;
import android.os.Bundle;
import android.os.PersistableBundle;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {

    // Channel que se creo en el lado del cliente (flutter app)
    private String CHANNEL_NAME = "app.eider/my_first_platform_channel";

    private Geolocation geolocation;



   /* @Override
    public void onCreate(@Nullable Bundle savedInstanceState, @Nullable PersistableBundle persistentState) {
        super.onCreate(savedInstanceState, persistentState);

        this.context = getApplicationContext();
    }*/

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        BinaryMessenger messenger = flutterEngine.getDartExecutor().getBinaryMessenger();
        // Creo la instancia de la clase Geolocation.
        this.geolocation = new Geolocation(this, flutterEngine);
        MethodChannel methodChannel = new MethodChannel(messenger, CHANNEL_NAME);
        methodChannel.setMethodCallHandler(( MethodCall call, MethodChannel.Result result) -> {
            // En esta parte escuchamos los mensajes enviados desde el cliente.
            // En el parametro call viene lo que le enviemos desde el cliente (flutter app)

            String clientAppMethod = call.method; //Metodo que se envia desde la app de Flutter.

            if (clientAppMethod.equals("version")) { // 'version' es lo que se envia desde la app.


                // Envio de informacion desde la app de Flutter.

                // Obteniendo un String.
                //String stringMessageFromFlutter = call.arguments.toString();
                //Log.d("FLUTTER", stringMessageFromFlutter);

                // Obteniendo un integer.
                //int intMessageFromFlutter = (int) call.arguments;
                //Log.d("FLUTTER", intMessageFromFlutter);

                // Obteniendo un arreglo de numeros.
                //Log.d("FLUTTER", call.arguments.toString());
                /*ArrayList<Integer> numbers = (ArrayList<Integer>) call.arguments;
                for (int numb: numbers) {
                    Log.d("FLUTTER", "😘 "+ numb);
                }*/

                // Obteniendo un mapa.
                HashMap<String, Object> userDataFromFlutter = (HashMap<String, Object>) call.arguments;
                String name = userDataFromFlutter.get("name").toString();
                String lastName = userDataFromFlutter.get("lastName").toString();
                int age = (int) userDataFromFlutter.get("age");

                Log.d("FLUTTER", "😘 "+ name);
                Log.d("FLUTTER", "🤩 "+ lastName);
                Log.d("FLUTTER", "😄 "+ age);


                String currentAndroidVersion = getAndroidVersion();
                // No se puede retornar cualquier tipo de dato, solo primitivos. revisar la documentacion de Flutter.
                result.success(currentAndroidVersion.toString());
            }
            else { // El cliente llamo un metodo que no tenemos comtemplado.
                // Le envio una respuesta a la app.
                result.notImplemented();
            }
        });
    }

    String getAndroidVersion() {
        int sdk_version_number = Build.VERSION.SDK_INT;
        String release = Build.VERSION.RELEASE;
        return "Android version: "+sdk_version_number+ " (" + release + ")";
    }

    @Override
    protected void onDestroy() {
        // Detengo la escucha del GPS si la app se destruye.
        this.geolocation.stopListeningGps();
        super.onDestroy();
    }
}
