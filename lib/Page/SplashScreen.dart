import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fogaca_app/Page/Mapa_Home.dart';
import 'package:provider/provider.dart';
class SplashScreen extends StatefulWidget{

  static const  String idScreen="splash_screen";
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<SplashScreen> {

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();


    Timer(Duration(seconds:5),(){
      Navigator.pushReplacement(
          context, MaterialPageRoute(
          builder: (_)=>Mapa_Home()));
    });
  }

  @override
  initState() {
    //inicia a tela toda
    SystemChrome.setEnabledSystemUIOverlays([]);
  //  _RecuperarDadosUsuario();
    super.initState();
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


