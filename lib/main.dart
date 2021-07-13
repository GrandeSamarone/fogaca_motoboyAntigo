import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  print("Handling a background message: ${message.messageId}");
  await Firebase.initializeApp();
}

AndroidNotificationChannel channel;
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;


void main()async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

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
  Function originalOnError = FlutterError.onError;
  FlutterError.onError = (FlutterErrorDetails errorDetails) async {
    await FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    originalOnError(errorDetails);
  };

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance
      .setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(
    MultiProvider(
        providers: [
          Provider<StoreDadosUsuario>(
            create:(_)=>StoreDadosUsuario(),
          ),
          ChangeNotifierProvider<ThemeChanger>(
            create:(_)=>ThemeChanger(),
          ),  ChangeNotifierProvider<Dados_usuario>(
            create:(_)=>Dados_usuario(),
          ),ChangeNotifierProvider<AppData>(
            create:(_)=>AppData(),
          ),
          StreamProvider(create: (context)=>DadosFirestore.GetClientes()),
          StreamProvider(create: (context)=>DadosFirestore.GetPedidos()),
        ],
        child: MyApp()

  ),

  );

}

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    bool darkThemeEnabled=Provider.of<ThemeChanger>(context).isDark();
    return MaterialApp(
      //Thema LIGHT
      theme: ThemeData(
          dialogBackgroundColor: Colors.white,
          brightness: Brightness.light,
          primarySwatch:Colors.red,
          accentColor: Colors.redAccent,
          cardColor: Colors.white,
          fontFamily:"Brand Bold",
          textTheme: TextTheme(
            bodyText1: TextStyle(),
            bodyText2: TextStyle(),
          ).apply(
            bodyColor: Colors.black54,
            displayColor: Colors.white60,
          ),

          visualDensity: VisualDensity.adaptivePlatformDensity
      ),
      //Thema Dark
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        dialogBackgroundColor: Colors.grey[800],
        fontFamily:"Brand Bold",
        cardColor: Colors.black87,
        accentColor: Colors.redAccent,
        primarySwatch:createMaterialColor(Color(4288088072)),
        textTheme: TextTheme(
          bodyText1: TextStyle(),
          subtitle1: TextStyle(color: Colors.black87),
        ).apply(
          bodyColor: Colors.white,
        ),
        // accentColor:Colors.redAccent,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      themeMode: darkThemeEnabled?ThemeMode.dark:ThemeMode.light,
      debugShowCheckedModeBanner: false,
      title: "Fogaça Motoboys",
      //verificando se o usuario esta logado
      initialRoute:  FirebaseAuth.instance.currentUser==null? Tela_Login.idScreen:SplashScreen.idScreen,
      routes: {
        SplashScreen.idScreen:(context)=>SplashScreen(),
        Tela_Cadastro.idScreen:(context)=>Tela_Cadastro(),
        Tela_Login.idScreen:(context)=>Tela_Login(),
        Mapa_Home.idScreen:(context)=>Mapa_Home(),
        Pedidos_em_Entrega.idScreen:(context)=>Pedidos_em_Entrega(),
      ///  MotoInfo.idScreen:(context)=>MotoInfo(),
       // Pedidos_em_Andamento.idScreen:(context)=>Pedidos_em_Andamento(),
        //Tela_Cad_Loc_Loja.idScreen:(context)=>Tela_Cad_Loc_Loja(),
        //Tela_Pesquisa.idScreen:(context)=>Tela_Pesquisa(),
      },

    );

  }


  //Color
  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map swatch = <int, Color>{};
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

