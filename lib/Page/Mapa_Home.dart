import 'dart:math';

import 'package:badges/badges.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fogaca_app/Assistencia/AssistenciaMetodo.dart';
import 'package:fogaca_app/Model/Motoboy.dart';
import 'package:fogaca_app/Model/Pedido.dart';
import 'package:fogaca_app/Notificacao/PushNotificacao.dart';
import 'package:fogaca_app/Providers/Firestore_Dados.dart';
import 'package:fogaca_app/Providers/Prov_AppData.dart';
import 'package:fogaca_app/Providers/Prov_Thema_black_light.dart';
import 'package:fogaca_app/Store/StoreDadosUsuario.dart';
import 'package:fogaca_app/TabsPage/HistoricoTabePage.dart';
import 'package:fogaca_app/TabsPage/HomeTabePage.dart';
import 'package:fogaca_app/TabsPage/ProfileTabPage.dart';
import 'package:fogaca_app/TabsPage/RatingTabPage.dart';
import 'package:fogaca_app/Widget/Toast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:ndialog/ndialog.dart';
import 'dart:async';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';




class Mapa_Home extends StatefulWidget {
  static const String idScreen = "mapa_home";

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Mapa_Home> with SingleTickerProviderStateMixin {


  TabController tabController;
  int selectedIndex = 0;
  List<Pedido> pedidos;
  String estrela;
  double estrelaDouble;
  final FirebaseMessaging firebaseMessaging=FirebaseMessaging.instance;
  StoreDadosUsuario controllerDadosUsuario;
  PushNotificacao pushNotificacao= PushNotificacao();
  void onItemClicked(int index)
  {
    setState(() {
      selectedIndex=index;
      tabController.index=selectedIndex;
    });


  }
  ReactionDisposer reactionDisposer;
  void didChangeDependencies(){
    super .didChangeDependencies();



    controllerDadosUsuario=Provider.of<StoreDadosUsuario>(context);
    controllerDadosUsuario.DadosMotoboy();

  }
  @override
  void initState() {
    tabController=TabController(length: 4, vsync: this);
    super.initState();



  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    pushNotificacao.initialize(context);
    return Scaffold(
    body:TabBarView(
      physics:NeverScrollableScrollPhysics(),
      controller: tabController,
       children: [
         HomeTabePage(),
         EarningTabePage(),
         RatingTabPage(),
         ProfileTabPage()
       ],
    ),
      bottomNavigationBar:BottomNavigationBar(
        items:<BottomNavigationBarItem>[
          BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
            label:"Inicio",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on_rounded),
            label:"Ganhos",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_border),
            label:"Avaliações",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label:"Perfil",
          ),
        ],

        type:BottomNavigationBarType.fixed,
        selectedLabelStyle:TextStyle(fontSize:12.0),
        showUnselectedLabels:true,
        currentIndex:selectedIndex,
        onTap:onItemClicked,
      ),

    );

  }
}


