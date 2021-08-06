
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fogaca_app/Model/UserStateModel.dart';
import 'package:fogaca_app/Page/Mapa_Home.dart';
import 'package:fogaca_app/Pages_user/Tela_Login.dart';

class SplashScreen extends StatefulWidget{

  static const  String idScreen="splash_screen";
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<SplashScreen> with UserStateModel {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    Future.delayed(Duration(milliseconds: 1500), () async {
      initialize();
    });
  }

  initialize() async {
    await reloadUser();
    if (!isLogged()) {
      Navigator.of(context).push(
        PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 1500),
            maintainState: true,
            pageBuilder: (c, a1, a2) {
              return Tela_Login();
            }),
      );
    } else {
      Navigator.of(context).pushReplacementNamed(Mapa_Home.idScreen);
    }
  }

  @override
  void dispose() {
    //remove a tela toda
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:Color(4279900442),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("imagens/screen_dark.png"),
            fit: BoxFit.fill,
          ),
        ),
      ),



    );
  }


}


