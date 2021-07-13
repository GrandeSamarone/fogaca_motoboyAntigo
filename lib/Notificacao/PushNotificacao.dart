import 'dart:async';
import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fogaca_app/Model/Pedido.dart';
import 'package:firebase_core/firebase_core.dart';

import 'NotificacaoDialog.dart';
class PushNotificacao{
  final FirebaseMessaging firebaseMessaging=FirebaseMessaging.instance;
  Pedido detalheCorrida=Pedido();



  Future<void> initialize(context) async {
    await Firebase.initializeApp();
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.high,
    );
    // Set the background messaging handler early on, as a named top-level function
    FirebaseMessaging.onBackgroundMessage(initialize);

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      Pedido detalheCorrida=Pedido();
      if (notification != null && android != null) {

        print("onMessage${message.data}");
        print("onMessage${message.data["telefone"]}");
        print("onMessage${message.data["long_ponto"]}");
        print("onMessage${message.data["quant_itens"]}");
        print("onMessage${message.data["lat_ponto"]}");
        print("onMessage${message.data["end_ponto"]}");
        print("onMessage${message.data["id_doc"]}");
        print("onMessage${message.data["nome_ponto"]}");
        detalheCorrida.lat_ponto=message.data["lat_ponto"];
        detalheCorrida.long_ponto=message.data["long_ponto"];
        detalheCorrida.end_ponto=message.data["end_ponto"];
        detalheCorrida.nome_ponto=message.data["nome_ponto"];
        detalheCorrida.quant_itens=message.data["quant_itens"];
        detalheCorrida.telefone=message.data["telefone"];
        detalheCorrida.id_doc=message.data["id_doc"];

        showDialog(
            context:context,
            barrierDismissible: false,
            builder: (BuildContext context)=>NotificacaoDialog(detalheCorrida:detalheCorrida) );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {

      print("onMessageOpenedApp${message.data}");
      print("onMessageOpenedApp${message.data["telefone"]}");
      print("onMessageOpenedApp${message.data["long_ponto"]}");
      print("onMessageOpenedApp${message.data["quant_itens"]}");
      print("onMessageOpenedApp${message.data["lat_ponto"]}");
      print("onMessageOpenedApp${message.data["end_ponto"]}");
      print("onMessageOpenedApp${message.data["id_doc"]}");
      print("onMessageOpenedApp${message.data["nome_ponto"]}");
      detalheCorrida.lat_ponto="-10.883650532856151";
      detalheCorrida.long_ponto="-61.948792934417725";
      detalheCorrida.end_ponto="RuaTorta";
      detalheCorrida.nome_ponto="Casa do Pão";
      detalheCorrida.quant_itens="4";
      detalheCorrida.telefone="996046872";
      detalheCorrida.id_doc="111";
     /* showDialog(
          context:context,
          barrierDismissible: false,
          builder: (BuildContext context)=>NotificacaoDialog(detalheCorrida:detalheCorrida) );

      */
    }
    );
  }

}