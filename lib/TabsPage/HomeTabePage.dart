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
import 'package:fogaca_app/Widget/WIDialog.dart';
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
  Motoboy motoboyLogado=Motoboy();
  Position posicao_atual;
  Dados_usuario Dados_Usuario;
  String textButton="FICAR ONLINE";
  Color ColorButton=Colors.greenAccent[700];
  bool _OffouOnline=false;
  bool _checkar;
  bool _localizacaoAtiva;
  String _CodCity;
  String _IDUsuario;
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




  @override
  Widget build(BuildContext context) {
    themeChanger = Provider.of<ThemeChanger>(context, listen: false);
    VerificarLocalizacao();
    DadosMotoboy=Provider.of<Dados_usuario>(context);
   // controllerDadosUsuario=Provider.of<StoreDadosUsuario>(context);
   // controllerDadosUsuario.DadosMotoboy();
   final motoboy=Provider.of<List<Motoboy>>(context);
   // final store=Provider.of<StoreDadosUsuario>(context);
    /*  if(store!=null){
    //  motoboyLogado=motoboy[0];
      _OffouOnline=store.online_offline;
      _checkar=store.permissao;
      _IDUsuario=store.id;
      _CodCity=store.codcity;
      print("dados::"+_CodCity+""+_IDUsuario+""+_OffouOnline.toString()+""+_checkar.toString());

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

    }*/
    if(motoboy!=null){
      motoboyLogado=motoboy[0];
      _OffouOnline=motoboyLogado.online;
      _checkar=motoboyLogado.permissao;
      _IDUsuario=motoboyLogado.id;
      _CodCity=motoboyLogado.cod;

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

    }
   // print("PERMISSAO:::${controllerDadosUsuario.permissao}");
  //  print("ONLINE:::${controllerDadosUsuario.online_offline}");

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

   // firebaseMessaging.subscribeToTopic(_CodCity);
    DatabaseReference MotoboyRequest=FirebaseDatabase.instance.reference().child("MotoboysOnline")
        .child(_IDUsuario);
    posicao_atual = await geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    if(_OffouOnline) {
      Geofire.initialize("MotoboysOnline");
      Geofire.setLocation(
          _IDUsuario, posicao_atual.latitude, posicao_atual.longitude);


      MotoboyRequest.onValue.listen((event) {

      });
    }
  }

  void getLocationLiveUpdates(){

    homepageStreamSubscription=geolocator.getPositionStream().listen((Position position) {

      posicao_atual=position;
      if(_OffouOnline){
        Geofire.setLocation(_IDUsuario, position.latitude, position.longitude);
      }
      LatLng latLng=LatLng(position.latitude, position.longitude);

      CameraPosition cameraPosition =
      new CameraPosition(target: latLng, zoom: 14);
      controller_Maps
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    });
  }

  Future<void> DeletarLocMotoboyDatabase() {
    //firebaseMessaging.unsubscribeFromTopic(_CodCity);
    //MotoboysOnline
    DatabaseReference MotoboyRequest=FirebaseDatabase.instance.reference().child("MotoboysOnline")
        .child(_IDUsuario);
    Geofire.removeLocation(_IDUsuario);
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
    if(_localizacaoAtiva){
      if(_OffouOnline){
       Ficar_Offline();
      }else{
      Ficar_Online();

      }

  }else{
      ToastMensagem("Ative seu GPS antes de come??ar a aceitar pedidos.", context);
    }
  }else{
      showDialog(
          context:context,
          builder: (BuildContext context)=>WIDialog(
              titulo: "Aten????o",
              msg: "Para ter sua conta liberada  por favor entrar em contato conosco pelo whatsapp.",
              txtButton:"Falar agora",
              funcao:(){
                _launchWhatsapp();
                Navigator.pop(context);
              }) );

    }
  }

Future<void>Ficar_Online()async{
  ServiceStatus serviceStatus = await Permission.location.serviceStatus;
  _localizacaoAtiva = (serviceStatus == ServiceStatus.enabled);

    MethodChannel serviceChannel = MethodChannel("motoboy");
    serviceChannel.invokeMethod("checkOverlay").then((value){
      print("RETORNO CHECKOVERLAY::${value}");
    if(value==true){
      print("RETORNO CHECKOVERLAY2::${value}");
        firebaseMessaging.subscribeToTopic(_CodCity);
        Wakelock.enable();
        _OffouOnline=true;
        Atualizar_Online_Offline(true);
        ToastMensagem("Buscando...", context);
         makeDriveOnlineNow();
        // getLocationLiveUpdates();
        MethodChannel serviceChannel = MethodChannel("motoboy");
        serviceChannel.invokeMethod("startService");
  }else{
      showDialog(
          context:context,
          builder: (BuildContext context)=>WIDialog(
              titulo: "Aten????o",
              msg: "Para receber corridas ?? preciso autoriza????o para sobrepor outros aplicativos.",
               txtButton:"Ok,entendi.",
               funcao:(){
                 MethodChannel serviceChannel = MethodChannel("motoboy");
                 serviceChannel.invokeMethod("ativarOverlay");
                 Navigator.pop(context);
               }) );
    }

  });






  }
Future<void>Ficar_Offline()async{
    firebaseMessaging.unsubscribeFromTopic(_CodCity);
    ToastMensagem("N??o receber?? pedidos.", context);
    Wakelock.disable();
    _OffouOnline=false;
    Atualizar_Online_Offline(false);
    // Geofire.stopListener();
    //  DeletarLocMotoboyDatabase();
    MethodChannel serviceChannel = MethodChannel("motoboy");
    serviceChannel.invokeMethod("stopService");
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
    getJsonFile("imagens/maps_styles/mapsdark.json").then(setMapStyle);
  }

  Future<String> getJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }

  void setMapStyle(String mapStyle) {
    controller_Maps.setMapStyle(mapStyle);
  }

}