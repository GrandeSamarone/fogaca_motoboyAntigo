package com.MarlosTrinidad.fogaca_app;

import io.flutter.embedding.android.FlutterActivity;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.media.AudioAttributes;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.core.app.NotificationCompat;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "fogacamotoboy.com/canal_notificacao";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            // Note: this method is invoked on the main thread.
                            if (call.method.equals("criarcanalnotificacao")) {
                                Uri soundUri = Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE + "://"+ getApplicationContext().getPackageName()+"/raw/somsino");
                                NotificationManager mNotificationManager = (NotificationManager) getApplicationContext().getSystemService(Context.NOTIFICATION_SERVICE);

                                //For API 26+ you need to put some additional code like below:
                                NotificationChannel mChannel;
                                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                                    mChannel = new NotificationChannel("NOTOFICACAO_PEDIDOS", "Fogaça Motoboys",
                                            NotificationManager.IMPORTANCE_HIGH);
                                    mChannel.setLightColor(Color.GRAY);
                                    mChannel.enableLights(true);
                                    mChannel.setDescription("notificação pedidosPrimeiro");
                                    AudioAttributes audioAttributes = new AudioAttributes.Builder()
                                            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                                            .setUsage(AudioAttributes.USAGE_NOTIFICATION)
                                            .build();
                                    mChannel.setSound(soundUri, audioAttributes);

                                    if (mNotificationManager != null) {
                                        mNotificationManager.createNotificationChannel( mChannel );
                                    }
                                }

                                //General code:
                                NotificationCompat.Builder status = new NotificationCompat.Builder(getApplicationContext(),"NOTOFICACAO_PEDIDOS");
                                status.setAutoCancel(true)
                                        .setWhen(System.currentTimeMillis())
                                        .setSmallIcon(R.drawable.logo_fogaca)
                                        //.setOnlyAlertOnce(true)
                                        .setContentTitle("Fogaça Motoboys")
                                        .setContentText("notificação pedidos")
                                        .setVibrate(new long[]{0, 500, 1000})
                                        .setDefaults(Notification.DEFAULT_LIGHTS )
                                        .setSound(Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE+ "://" +getContext().getPackageName()+"/raw/somsino"));

                                mNotificationManager.notify(1, status.build());
                            } else {
                                result.notImplemented();
                            }
                        }
                );
    }
}