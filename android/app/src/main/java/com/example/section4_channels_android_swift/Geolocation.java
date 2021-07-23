package com.example.section4_channels_android_swift;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageManager;
import android.location.Location;
import android.os.Build;
import android.os.Looper;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.core.content.ContextCompat;

import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationCallback;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationResult;
import com.google.android.gms.location.LocationServices;

import java.util.HashMap;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.shim.ShimPluginRegistry;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

// En esta clase implementamos todas las cosas relacionadas con el GPS.
public class Geolocation implements MethodChannel.MethodCallHandler, EventChannel.StreamHandler {

    private Activity activity;
    // Nombre del canal para establecer la comunicacion.
    private String CHANNEL_GEOLOCATION_NAME = "app.eider/geolocation";
    private String EVENT_CHANNEL_GEOLOCATION_NAME = "app.eider/geolocation_listener";

    // Codigo para solicitar los permisos.
    private final int REQUEST_CODE = 1024;

    private MethodChannel.Result flutterResult;

    private double currentLatitude = 0.0, currentLongitude = 0.0;

    private FusedLocationProviderClient fusedLocationClient;
    private EventChannel.EventSink events;

    // Los datos que se leen del GPS llegan a este callback.
    private LocationCallback locationCallback = new LocationCallback(){
        @Override
        public void onLocationResult(LocationResult locationResult) {
            super.onLocationResult(locationResult);

            if(locationResult != null) { // Obtuve una nueva localizacion del dispositivo.
                Location location = locationResult.getLastLocation();
                Log.d("🥶", "Latitude: " + location.getLatitude() +" Longitude: " +location.getLongitude());
                currentLatitude = location.getLatitude();
                currentLongitude = location.getLongitude();
                String currentLocationString = currentLatitude + ", " + currentLongitude;
                Toast.makeText(activity, currentLocationString, Toast.LENGTH_SHORT).show();
                if (events != null) {

                    // Un mapa en java es un HashMap
                    HashMap<String, Double> data = new HashMap<>();
                    data.put("lat", currentLatitude);
                    data.put("lng", currentLongitude);

                    events.success(data);
                }
            }
        }
    };


    Geolocation(Activity activity, FlutterEngine flutterEngine) {
        BinaryMessenger messenger = flutterEngine.getDartExecutor().getBinaryMessenger();

        this.activity = activity;

        // Con este escucho eventos desde el cliente y le retorno una respuesta al cliente.
        MethodChannel methodChannel = new MethodChannel(messenger, CHANNEL_GEOLOCATION_NAME);

        // Creo un eventchannel para enviar datos al cliente constantemente.
        EventChannel eventChannel = new EventChannel(messenger, EVENT_CHANNEL_GEOLOCATION_NAME);
        eventChannel.setStreamHandler(this);


        // This debido a que MethodChannel.MethodCallHandler lo implementamos en la clase.
        methodChannel.setMethodCallHandler(this);

        // Inicializo el provider del GPS.
        this.fusedLocationClient = LocationServices.getFusedLocationProviderClient(this.activity);

        // Pasos para implementar el metodo onRequestPermissionsResult en esta clase.
        ShimPluginRegistry registry = new ShimPluginRegistry(flutterEngine);
        PluginRegistry.Registrar registrar = registry.registrarFor(CHANNEL_GEOLOCATION_NAME);
        registrar.addRequestPermissionsResultListener((int requestCode, String[] permissions, int[] grantResults) -> {

            if (requestCode == REQUEST_CODE) {
                // El usuario concedio el permiso.
                if(grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED){
                    this.flutterResult.success("granted");
                }
                else {
                    this.flutterResult.success("denied");
                }

                this.flutterResult = null;
            }
            return false;
        });

    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "check_permissions":
                // Verifico los permisos y le envio respuesta a la app de Flutter.
                this.checkPermissions(result);
                break;
            case "request_permissions":
                // Solicito los permisos y le envio respuesta a la app de Flutter.
                this.requestPermission(result);
                break;
            case "start_listening_gps":
                // Obtengo los datos de geolocalizacion del gps.
                this.startListeningGps();
                // No se le envia nada al client.
                result.success(null);
                break;
            case "stop_listening_gps":
                // Detengo la escucha de los datos de geolocalizacion del gps.
                this.stopListeningGps();
                // No se le envia nada al cliente.
                result.success(null);
                break;
            default:
                result.notImplemented();
        }
    }

    private void checkPermissions(MethodChannel.Result result) {
        int status = ContextCompat.checkSelfPermission(this.activity, Manifest.permission.ACCESS_FINE_LOCATION);

        // Le devuelvo la respuesta a la app de Flutter.
        if (status == PackageManager.PERMISSION_GRANTED) {
            result.success("granted");
        }
        else {
            result.success("denied");
        }

    }

    private void requestPermission(MethodChannel.Result result) {

        // No se bien para que se usa la siguiente parte.
        if (this.flutterResult != null) {
            result.error("PENDING_TASK", "You have a pending task", null);
            return;
        }

        this.flutterResult = result;
        // Solicito los permisos al usuario.
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            this.activity.requestPermissions(new String[]{
                    Manifest.permission.ACCESS_FINE_LOCATION,
            }, REQUEST_CODE);
        }
        else{
            this.flutterResult.success("granted");
            this.flutterResult = null;
        }
    }


    @SuppressLint("MissingPermission")
    private void startListeningGps() {
        LocationRequest locationRequest = LocationRequest.create();
        locationRequest.setInterval(5000); // secs
        locationRequest.setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY);

        this.fusedLocationClient.requestLocationUpdates(locationRequest, locationCallback, Looper.getMainLooper());
    }

    public void stopListeningGps() {
        // Detengo la escucha del GPS.
        fusedLocationClient.removeLocationUpdates(locationCallback);
    }




    // METODOS PARA EVENTCHANNEL.

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        this.events = events;
    }

    @Override
    public void onCancel(Object arguments) {

    }
}
