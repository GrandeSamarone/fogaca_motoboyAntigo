package com.MarlosTrinidad.fogaca_app;


import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.provider.Settings;
import android.util.Log;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        Intent intent = new Intent(getContext(), ReceiverService.class);
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(),"motoboy")
                .setMethodCallHandler(new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {

                        if(call.method.equals("startService")){
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                                if(!Settings.canDrawOverlays(getApplicationContext())) {
                                    Intent intent = new Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                                            Uri.parse("package:" + getPackageName()));
                                    startActivityForResult(intent, 200);
                                }
                            }

                            startService(intent);
                        }else if(call.method.equals("stopService")){
                            try{
                                stopService(intent);
                            }catch (Exception e){

                            }

                        }else if(call.method.equals("checkOverlay")){
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                                if(!Settings.canDrawOverlays(getApplicationContext())) {
                                    result.success(false);

                                    Log.i("canDrawOverlays::","false");
                                }else {
                                    result.success(true);
                                    Log.i("canDrawOverlays::","true");
                            }
                            }
                        }else if(call.method.equals("ativarOverlay")){
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                                    Intent intent = new Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                                            Uri.parse("package:" + getPackageName()));
                                    startActivityForResult(intent, 200);

                                    Log.i("canDrawOverlays::","false");

                            }
                        }
                    }
                });
    }

}