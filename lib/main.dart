import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/assertions.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fogaca_app/Notificacao/PushNotificacao.dart';

import 'Pages_pedido/Pedidos_em_Entrega.dart';
import 'Pages_user/Tela_Login.dart';
import 'Pages_user/Tela_Cad_Moto.dart';
import 'package:fogaca_app/Providers/Firestore_Dados.dart';
import 'package:fogaca_app/Providers/Prov_AppData.dart';
import 'package:fogaca_app/Providers/Prov_Thema_black_light.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'Page/Mapa_Home.dart';
import 'Page/SplashScreen.dart';
import 'Pages_user/Tela_Cadastro.dart';
import 'Store/StoreDadosUsuario.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  RawDatagramSocket.bind(InternetAddress.anyIPv4, 0)
      .then((RawDatagramSocket socket) {
    Map<String, dynamic> map = Map();
    map['lat_ponto'] = message.data["lat_ponto"];
    map['long_ponto'] = message.data["long_ponto"];
    map['end_ponto'] = message.data["end_ponto"];
    map['nome_ponto'] = message.data["nome_ponto"];
    map['quant_itens'] = message.data["quant_itens"];
    map['telefone'] = message.data["telefone"];
    map['id_doc'] = message.data["id_doc"];

    socket.send(
        utf8.encode(jsonEncode(map)), InternetAddress("127.0.0.1"), 3306);
  });
}

AndroidNotificationChannel ?channel;
FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen(_firebaseMessagingBackgroundHandler);
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final DadosFirestore=Dados_usuario();
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterExceptionHandler? originalOnError = FlutterError.onError;
  FlutterError.onError = (FlutterErrorDetails errorDetails) async {
    await FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    originalOnError!(errorDetails);
  };

  await flutterLocalNotificationsPlugin!
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel!);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(
    MultiProvider(providers: [
      // Provider<StoreDadosUsuario>(
      //   create: (_) => StoreDadosUsuario(),
      // ),
      ChangeNotifierProvider<ThemeChanger>(
        create: (_) => ThemeChanger(),
      ),
      ChangeNotifierProvider<Dados_usuario>(
        create: (_) => Dados_usuario(),
      ),
     // StreamProvider(create: (context)=>DadosFirestore.GetClientes()),
    ], child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics analytics = FirebaseAnalytics();
    return MaterialApp(
      theme: ThemeData(
        primarySwatch:createMaterialColor(Color(4288088072)),
        scaffoldBackgroundColor: Color(0xFF403939),
        cardColor: Color(0xFF403939),
        canvasColor: Color(0xFF403939),
         // visualDensity: VisualDensity.adaptivePlatformDensity
      ),
      debugShowCheckedModeBanner: false,
      title: "Fogaça Motoboys",
      navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)],
     home:SplashScreen() ,
      routes: {
        SplashScreen.idScreen: (context) => SplashScreen(),
        Tela_Cadastro.idScreen: (context) => Tela_Cadastro(),
        Tela_Login.idScreen: (context) => Tela_Login(),
        Mapa_Home.idScreen: (context) => Mapa_Home(),
        Pedidos_em_Entrega.idScreen: (context) => Pedidos_em_Entrega(),
      },
    );
  }

  //Color
  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }
}
