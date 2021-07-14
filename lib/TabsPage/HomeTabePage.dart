import 'dart:async';
import 'dart:io';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fogaca_app/Model/Motoboy.dart';
import 'package:fogaca_app/Model/Pedido.dart';
import 'package:fogaca_app/Notificacao/NotificacaoDialog.dart';
import 'package:fogaca_app/Notificacao/PushNotificacao.dart';
import 'package:fogaca_app/Page/Mapa_Home.dart';
import 'package:fogaca_app/Store/StoreDadosUsuario.dart';
import 'package:fogaca_app/Widget/WIListPorData.dart';
import 'package:mobx/mobx.dart';
import '../Pages_pedido/Pedidos_em_Entrega.dart';
import 'package:fogaca_app/Page/SplashScreen.dart';
import '../Pages_pedido/Tela_Passeio.dart';
import 'package:fogaca_app/Providers/Firestore_Dados.dart';
import 'package:fogaca_app/Providers/Prov_Thema_black_light.dart';
import 'package:fogaca_app/Widget/Toast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fogaca_app/main.dart';
import 'package:ndialog/ndialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakelock/wakelock.dart';

class HomeTabePage extends StatefulWidget{
  @override
  _HomeTabePageState createState() => _HomeTabePageState();
}

class _HomeTabePageState extends State<HomeTabePage> with AutomaticKeepAliveClientMixin {

  GoogleMapController controller_Maps;
  StreamSubscription<Position>homepageStreamSubscription;
  final FirebaseMessaging firebaseMessaging=FirebaseMessaging.instance;
  var geolocator = Geolocator();
  Dados_usuario DadosMotoboy;

  Position posicao_atual;
  Dados_usuario Dados_Usuario;
  String textButton="FICAR ONLINE";
  Color ColorButton=Colors.greenAccent[700];
  bool _OffouOnline=false;
  bool _checkar;
  bool _localizacaoAtiva;
  String _N_Pedidos;
  ThemeChanger themeChanger;
  StoreDadosUsuario controllerDadosUsuario;


  void locatePosition() async {
    posicao_atual = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);


    LatLng latLatPosition = LatLng(posicao_atual.latitude, posicao_atual.longitude);
    //localizacao fim
    CameraPosition cameraPosition =
    new CameraPosition(target: latLatPosition, zoom: 14);
    controller_Maps
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }


  ReactionDisposer reactionDisposer;
  void didChangeDependencies(){
    super .didChangeDependencies();



    controllerDadosUsuario=Provider.of<StoreDadosUsuario>(context);
    controllerDadosUsuario.DadosMotoboy();


    reactionDisposer=  reaction((_)=>controllerDadosUsuario.permissao,
            (valor){
              _checkar=valor;
          print(valor);
        });
    reactionDisposer= reaction((_)=>controllerDadosUsuario.codcity,
            (valor){
        });
    reactionDisposer= reaction((_)=>controllerDadosUsuario.online_offline,
            (valor){
              _OffouOnline=valor;

              if(_OffouOnline){
                setState(() {
                  ColorButton=Colors.redAccent[700];
                  textButton="FICAR OFFLINE";

                });

              }else{
                setState(() {
                  ColorButton=Colors.greenAccent[700];
                  textButton="FICAR ONLINE";
                });

              }
        });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    reactionDisposer();
    controllerDadosUsuario.FecharDados();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    themeChanger = Provider.of<ThemeChanger>(context, listen: false);
    VerificarLocalizacao();
    DadosMotoboy=Provider.of<Dados_usuario>(context);


    // TODO: implement build
    return  Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(top: 300),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            initialCameraPosition: CameraPosition(
                target: LatLng(-10.877628756313518, -61.95153213548445), zoom: 13.4746),
            onMapCreated: (GoogleMapController controller) {
              controller_Maps=controller;
              changeMapMode();
              locatePosition();

            },
          ),

          //botao contando o tanto de pedido
          Positioned(
            top: 150.0,
            right: 22.0,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Pedidos_em_Entrega()));
              },
              child: Container(

                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black,
                          // color: Theme.of(context).textTheme.headline4.color,
                          blurRadius: 6.0,
                          spreadRadius: 0.5,
                          offset: Offset(
                            0.7,
                            0.7,
                          ))
                    ]),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Image.asset("imagens/bolsa.png",height:25),

                ),
              ),
            ),
          ),


          //online offline driver container
          Container(
              height: 140.00,
              width: double.infinity,
              color:Colors.black54
          ),

          Positioned(
            top:50.0,
            left:0.0,
            right:0.0,
            child: Row(
              mainAxisAlignment:MainAxisAlignment.center,
              children: [
                Padding(
                  padding:EdgeInsets.symmetric(horizontal:16.0),
                  child: Container(
                    width: 200.0,
                    height: 50.0,
                    child: ElevatedButton.icon(
                        icon: Icon(Icons.motorcycle, color: Colors.white54,size:25.0,),
                        label:Text(textButton),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                          primary:ColorButton,
                          //  onPrimary: Colors.white,
                          onSurface: Colors.grey,
                          shape: const BeveledRectangleBorder
                            (borderRadius: BorderRadius.all(Radius.circular(5))),

                          textStyle: TextStyle(
                              color: Colors.white54,
                              fontSize: 15,
                              fontFamily: "Brand Bold"
                              ,fontWeight: FontWeight.bold
                          ),
                        ),

                        onPressed: (){

                          VerificandoDados();
                        }),
                  ),



                ),

              ],
            ),
          )



        ]
    );

  }
  void VerificarLocalizacao()async{

    ServiceStatus serviceStatus = await Permission.location.serviceStatus;
    setState(() {
      _localizacaoAtiva = (serviceStatus == ServiceStatus.enabled);
    });


    if(_localizacaoAtiva==false&&_OffouOnline){

      Atualizar_Online_Offline(false);
      ToastMensagem("Ative seu GPS Para continuar aceitando Pedidos...", context);
      DeletarLocMotoboyDatabase();



    }
  }
  void makeDriveOnlineNow() async{

    firebaseMessaging.subscribeToTopic(controllerDadosUsuario.codcity);
    DatabaseReference MotoboyRequest=FirebaseDatabase.instance.reference().child("MotoboysOnline")
        .child(controllerDadosUsuario.id);
    posicao_atual = await geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    if(_OffouOnline) {
      Geofire.initialize("MotoboysOnline");
      Geofire.setLocation(
          controllerDadosUsuario.id, posicao_atual.latitude, posicao_atual.longitude);


      MotoboyRequest.onValue.listen((event) {

      });
    }
  }

  void getLocationLiveUpdates(){

    homepageStreamSubscription=geolocator.getPositionStream().listen((Position position) {

      posicao_atual=position;
      if(_OffouOnline){
        Geofire.setLocation(controllerDadosUsuario.id, position.latitude, position.longitude);
      }
      LatLng latLng=LatLng(position.latitude, position.longitude);

      CameraPosition cameraPosition =
      new CameraPosition(target: latLng, zoom: 14);
      controller_Maps
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    });
  }

  Future<void> DeletarLocMotoboyDatabase() {
    firebaseMessaging.unsubscribeFromTopic(controllerDadosUsuario.codcity);
    //MotoboysOnline
    DatabaseReference MotoboyRequest=FirebaseDatabase.instance.reference().child("MotoboysOnline")
        .child(controllerDadosUsuario.id);
    Geofire.removeLocation(controllerDadosUsuario.id);
    Geofire.stopListener();
    MotoboyRequest.onDisconnect();
    MotoboyRequest.remove();
    MotoboyRequest=null;

  }

   Atualizar_Online_Offline(bool resultado) {
    Map<String, dynamic> atualizadDados = new Map();
    atualizadDados["online"]=resultado;

    DadosMotoboy.Atualizar_Online_Offline(atualizadDados);

  }

  void VerificandoDados()async {
    if(_checkar){

      if(_OffouOnline){
        ToastMensagem("Não receberá pedidos.", context);
        Wakelock.disable();
        _OffouOnline=false;
        Geofire.stopListener();
        Atualizar_Online_Offline(false);
        DeletarLocMotoboyDatabase();
        MethodChannel serviceChannel = MethodChannel("motoboy");
        serviceChannel.invokeMethod("stopService");
      }else{
        ServiceStatus serviceStatus = await Permission.location.serviceStatus;
        _localizacaoAtiva = (serviceStatus == ServiceStatus.enabled);
        if(_localizacaoAtiva){
          Wakelock.enable();
          Atualizar_Online_Offline(true);
          ToastMensagem("Buscando...", context);
          makeDriveOnlineNow();
          getLocationLiveUpdates();
          MethodChannel serviceChannel = MethodChannel("motoboy");
          serviceChannel.invokeMethod("startService");

        }else{
          ToastMensagem("Ative seu GPS antes de começar a aceitar pedidos.", context);
        }

      }
    }else{
      NAlertDialog(
          dialogStyle: DialogStyle(
              titleDivider: true,
              backgroundColor: Theme
                  .of(context)
                  .dialogBackgroundColor),
          title: Text(
              "Atenção"),
          content: Text(
              "Para ter sua conta liberada  por favor entrar em contato conosco pelo whatsapp."),
          actions: <Widget>[

            TextButton(
                child: Text("Falar agora",style:
                TextStyle( color:Theme.of(context).textTheme.headline4.color,))
                , onPressed: () {
              //abrir a conversa da aline;
              _launchWhatsapp();
              Navigator.pop(context);
            }),
            TextButton(child: Text("Depois",style:
            TextStyle( color:Theme.of(context).textTheme.headline4.color,))
                , onPressed: () {
                  Navigator.pop(context);
                }),
          ]
      ).show(context);
    }

  }


  _launchWhatsapp() async {
    const url = "https://api.whatsapp.com/send?phone=556992417580&text=ol%C3%A1";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  changeMapMode() {
    if (themeChanger.isDark()) {
      getJsonFile("imagens/maps_styles/mapsdark.json").then(setMapStyle);
    } else {
      getJsonFile("imagens/maps_styles/mapslight.json").then(setMapStyle);
    }
  }

  Future<String> getJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }

  void setMapStyle(String mapStyle) {
    controller_Maps.setMapStyle(mapStyle);
  }

}