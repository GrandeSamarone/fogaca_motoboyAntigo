import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fogaca_app/Notificacao/PushNotificacao.dart';
import 'package:fogaca_app/Widget/WIToast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Pedidos_em_Entrega.dart';

class Tela_Passeio extends StatefulWidget {

  Map<String, dynamic> ?detalheCorrida = Map();

  Tela_Passeio({this.detalheCorrida});



  _Tela_PasseioState createState() => _Tela_PasseioState();
}


class _Tela_PasseioState extends State<Tela_Passeio>{
  PushNotificacao pushNotificacao= PushNotificacao();
  StreamSubscription<DocumentSnapshot>? streamSub;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  GoogleMapController ?controller_Maps;
  Set<Marker> marcadoresSet=Set<Marker>();
  Set<Circle> circleSet=Set<Circle>();
  Set<Polyline> PLinhasSet=Set<Polyline>();
  List<LatLng> PLinhasCordenadas=[];
  Map<PolylineId, Polyline> polylines = {};
  Position ?posicao_atual;
  FirebaseFirestore db=FirebaseFirestore.instance;
  Position ?posicaoCalcular;
  static CameraPosition _KGooglePlex=  CameraPosition(target:  LatLng(-10.877628756313518, -61.95153213548445), zoom: 14);
  bool _TextoBotao=false;
  BitmapDescriptor ?MotoboyIcon;
  var _id,_nome,_TempoCorrida,_distanciaKM;
  var _quant_itens;
  var geolocator = Geolocator();
  var OpcaoLocacao=LocationOptions(accuracy: LocationAccuracy.bestForNavigation);
  double mapPaddingFromBottom=0;
  StreamSubscription<Position>?homepageStreamSubscription;
  double _TelaInicialContainerHeight=260.0;
  double _TelaCancelada=0.0;
  var latitude,longitude;
  void SegundaTela(){
    //print("clicando no Mostrar Detalhes");
    // await getPlaceDirection();
    if(mounted){
      setState(() {
        _TelaInicialContainerHeight=0.0;
        _TelaCancelada=260;
      });
    }
  }
  @override
  void dispose() {
    //PLinhasCordenadas.clear();
    //homepageStreamSubscription.cancel();
    //db.terminate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    pushNotificacao.initialize(context);
    verificarEstado();
    if(widget.detalheCorrida!["situacao"]=="Saiu para entrega"){
      setState(() {
        _TextoBotao=true;
      });}
    latitude=double.parse(widget.detalheCorrida!["lat_ponto"]);
    longitude=double.parse(widget.detalheCorrida!["long_ponto"]);
   // CriarIconMarker();
    return WillPopScope(
        onWillPop: () {
         return  _moveToSignInScreen(context);
        },
        child:Scaffold(
            body:  Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("imagens/mapsfundo.jpg"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Positioned(
                  top: 45.0,
                  left: 22.0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        //   color: Colors.white,
                          borderRadius: BorderRadius.circular(22.0),
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context).dialogBackgroundColor,
                                // color: Theme.of(context).textTheme.headline4.color,
                                blurRadius: 6.0,
                                spreadRadius: 0.5,
                                offset: Offset(
                                  0.7,
                                  0.7,
                                ))
                          ]),
                      //botao do drewaer
                      child: CircleAvatar(
                        //  backgroundColor: Colors.white,
                        child: Icon(
                          Icons.arrow_back, /*color: Colors.black*/
                        ),
                        radius: 20.0,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0.0,
                  right: 0.0,
                  bottom: 0.0,
                  height: 350,
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius:BorderRadius.only(topLeft:Radius.circular(16.0),topRight:Radius.circular(16.0)),


                      ),
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.0,vertical: 18.0),
                          child: Column(
                              children: [
                                ElevatedButton.icon(
                                    icon: Icon(FontAwesomeIcons.directions, color: Colors.white54,size:18.0,),
                                    label:Text("Abrir o mapa"),
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),

                                      primary:Colors.green[700],
                                      //  onPrimary: Colors.white,
                                      onSurface: Colors.grey,
                                      shape: const BeveledRectangleBorder
                                        (borderRadius: BorderRadius.all(Radius.circular(5))),

                                      textStyle: TextStyle(
                                          color: Colors.white54,
                                          fontSize: 20,
                                          fontFamily: "Brand Bold"
                                          ,fontWeight: FontWeight.bold
                                      ),
                                    ),

                                    onPressed: (){
                                      dialogMaps(context);

                                    })
                              ]
                          )
                      )
                  ),
                ),


                Positioned(
                  left: 0.0,
                  right: 0.0,
                  bottom: 0.0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:BorderRadius.only(topLeft:Radius.circular(16.0),topRight:Radius.circular(16.0)),
                      boxShadow:
                      [
                        BoxShadow(
                         // color: Theme.of(context).textTheme.bodyText2.color,
                          blurRadius:16.0,
                          spreadRadius: 0.5,
                          offset:(Offset(0.7,0.7)),

                        )
                      ],
                      color: Theme
                          .of(context)
                          .cardColor,
                    ),
                    height: _TelaInicialContainerHeight,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0,vertical: 18.0),
                      child: Column(
                        children: [
                          Text(_distanciaKM!=null?_distanciaKM+" "+_TempoCorrida:"",style: TextStyle(fontSize:14.0,fontFamily:"Brand Bold")
                          ),
                          SizedBox(height:6.0),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Text(widget.detalheCorrida!["nome_ponto"]!=null?widget.detalheCorrida!["nome_ponto"]:"",style: TextStyle(fontSize:24.0,fontFamily:"Brand Bold"),),
                              Padding(
                                padding:EdgeInsets.only(right:10.0),
                                child: GestureDetector(
                                  onTap:(){
                                    launch(('tel://${widget.detalheCorrida!["telefone"]!=null?widget.detalheCorrida!["telefone"]:""}'));
                                  } ,
                                  child: Container(
                                    height: 30.0,
                                    width: 30.0,
                                    decoration: BoxDecoration(
                                      color: Theme
                                          .of(context)
                                          .cardColor,
                                      borderRadius: BorderRadius.circular(26.0),
                                      border:Border.all(
                                        width:2.0,
                                        /*color: Theme
                                            .of(context)
                                            .textTheme.bodyText2.color,
                                         */
                                            ),

                                    ),
                                    child: Icon(Icons.call,size:26,),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height:26.0),


                          Row(
                            children: [
                              Image.asset("imagens/pickicon.png",height: 16,width: 16.0),
                              SizedBox(width:18.0),
                              Expanded(
                                  child:
                                  Container(
                                    child: Text(widget.detalheCorrida!["end_ponto"]!=null?widget.detalheCorrida!["end_ponto"]:"",style: TextStyle(fontSize: 18.0),overflow: TextOverflow.ellipsis,),
                                  ))
                            ],
                          ),

                          SizedBox(height:6.0),
                          Row(
                            children: [
                              Image.asset("imagens/iconquantpedido.png",height:16.0,width: 16.0,),
                              SizedBox(width:18.0),
                              Expanded(
                                  child:
                                  Container(
                                    child: Text(widget.detalheCorrida!["quant_itens"]!=null?widget.detalheCorrida!["quant_itens"]+" itens":"",style: TextStyle(fontSize: 18.0),overflow: TextOverflow.ellipsis,),
                                  ))
                            ],
                          ),

                          SizedBox(height:10.0),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4.0),
                            child: Container(
                                width:300,
                                height: 50.0,
                                child:ElevatedButton.icon(
                                    icon: Icon(FontAwesomeIcons.motorcycle, color: Colors.white54,size:18.0,),
                                    label:Text(_TextoBotao?"Finalizar":"Cheguei"),
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),

                                      primary:Colors.red[900],
                                      //  onPrimary: Colors.white,
                                      onSurface: Colors.grey,
                                      shape: const BeveledRectangleBorder
                                        (borderRadius: BorderRadius.all(Radius.circular(5))),

                                      textStyle: TextStyle(
                                          color: Colors.white54,
                                          fontSize: 20,
                                          fontFamily: "Brand Bold"
                                          ,fontWeight: FontWeight.bold
                                      ),
                                    ),

                                    onPressed: (){
                                      if(_TextoBotao){
                                        MotoboyFinalizou();

                                      }else{
                                        DialogCheguei();

                                      }


                                    })
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ), Positioned(
                  left: 0.0,
                  right: 0.0,
                  bottom: 0.0,
                  child: Container(
                    decoration: BoxDecoration(

                      borderRadius:BorderRadius.only(topLeft:Radius.circular(16.0),topRight:Radius.circular(16.0)),
                      boxShadow:
                      [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius:16.0,
                          spreadRadius: 0.5,
                          offset:(Offset(0.7,0.7)),

                        )
                      ],
                      color: Theme
                          .of(context)
                          .cardColor,


                    ),
                    height: _TelaCancelada,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0,vertical: 18.0),
                      child: Column(
                        children: [
                          Text("",style: TextStyle(fontSize:14.0,fontFamily:"Brand Bold",color:Colors.black54)
                          ),
                          SizedBox(height:6.0),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Text("PEDIDO CANCELADO.",style: TextStyle(fontSize:24.0,fontFamily:"Brand Bold"),),
                              Text("", textAlign: TextAlign.right, style: TextStyle(fontSize: 20.0, fontFamily: "Brand Bold"),),
                              Padding(
                                padding:EdgeInsets.only(right:10.0),
                                child: GestureDetector(
                                  onTap:(){

                                  } ,
                                  child: Container(
                                    height: 30.0,
                                    width: 30.0,
                                    decoration: BoxDecoration(
                                      color: Theme
                                          .of(context)
                                          .cardColor,
                                      borderRadius: BorderRadius.circular(26.0),
                                      border:Border.all(
                                        width:2.0,
                                       /* color: Theme
                                            .of(context)
                                            .textTheme.bodyText2.color*/),
                                    ),
                                    child: Icon(Icons.call,size:26,),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height:26.0),


                          Row(
                            children: [
                              Image.asset("imagens/pickicon.png",height: 16,width: 16.0),
                              SizedBox(width:18.0),
                              Expanded(
                                  child:
                                  Container(
                                    child: Text("CANCELADO",style: TextStyle(fontSize: 18.0),overflow: TextOverflow.ellipsis,),
                                  ))
                            ],
                          ),

                          SizedBox(height:6.0),

                          Row(
                            children: [
                              Image.asset("imagens/compass.png",height:16.0,width: 16.0,),
                              SizedBox(width:18.0),
                              Expanded(
                                  child:
                                  Container(
                                    child: Text("CANCELADO",style: TextStyle(fontSize: 18.0),overflow: TextOverflow.ellipsis,),
                                  ))
                            ],
                          ),
                          SizedBox(height:6.0),
                          Row(
                            children: [
                              Image.asset("imagens/iconquantpedido.png",height:16.0,width: 16.0,),
                              SizedBox(width:18.0),
                              Expanded(
                                  child:
                                  Container(
                                    child: Text("CANCELADO",style: TextStyle(fontSize: 18.0),overflow: TextOverflow.ellipsis,),
                                  ))
                            ],
                          ),

                          SizedBox(height:10.0),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4.0),
                            child: Container(
                                width:300,
                                height: 50.0,
                                child:ElevatedButton.icon(
                                    icon: Icon(FontAwesomeIcons.motorcycle, color: Colors.white54,size:18.0,),
                                    label:Text("Sair"),
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),

                                      primary:Colors.red[900],
                                      //  onPrimary: Colors.white,
                                      onSurface: Colors.grey,
                                      shape: const BeveledRectangleBorder
                                        (borderRadius: BorderRadius.all(Radius.circular(5))),

                                      textStyle: TextStyle(
                                          color: Colors.white54,
                                          fontSize: 20,
                                          fontFamily: "Brand Bold"
                                          ,fontWeight: FontWeight.bold
                                      ),
                                    ),

                                    onPressed: (){
                                      PLinhasCordenadas.clear();
                                      homepageStreamSubscription!.cancel();
                                      Navigator.pushNamedAndRemoveUntil(context, Pedidos_em_Entrega.idScreen, (route) => false);

                                    })
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )
        )
    );
  }
  void dialogMaps(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return AlertDialog(
                  title: Text("Escolha umas das opções:"),
                  actions: <Widget>[
                    Container(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          GestureDetector(
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    "imagens/wazeicon.png",
                                    width: 50,
                                    height: 50,
                                  ),
                                  Text('Waze'),
                                ],
                              ),
                              onTap: () async {
                                launchWaze(latitude, longitude);
                              }),
                          GestureDetector(
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    "imagens/googlemapsicon.png",
                                    width: 50,
                                    height: 50,
                                  ),
                                  Text('Google Maps'),
                                ],
                              ),
                              onTap: () async {
                                launchGoogleMaps(latitude, longitude);
                              }),
                        ],
                      ),
                    )
                  ],
                );
              });
        });
  }

  Future<void> launchWaze(double lat, double lng) async {
    var url = 'waze://?ll=${lat.toString()},${lng.toString()}';
    var fallbackUrl =
        'https://waze.com/ul?ll=${lat.toString()},${lng.toString()}&navigate=yes';
    try {
      bool launched =
      await launch(url, forceSafariVC: false, forceWebView: false);
      if (!launched) {
        await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
      }
    } catch (e) {
      await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
    }
  }

  Future<void> launchGoogleMaps(double lat, double lng) async {
    var url = 'google.navigation:q=${lat.toString()},${lng.toString()}';
    var fallbackUrl =
        'https://www.google.com/maps/search/?api=1&query=${lat.toString()},${lng.toString()}';
    try {
      bool launched =
      await launch(url, forceSafariVC: false, forceWebView: false);
      if (!launched) {
        await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
      }
    } catch (e) {
      await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
    }
  }
  void DialogCheguei(){
   /* NAlertDialog(
        dialogStyle: DialogStyle(
            titleDivider: true,
            backgroundColor: Theme
                .of(context)
                .dialogBackgroundColor),
        title: Text(
            "Atenção"),
        content: Text(
            "Você realmente chegou no local?"),
        actions: <Widget>[

          TextButton(
              child: Text("NÃO",style:
              TextStyle( color:Theme.of(context).textTheme.headline4.color,))
              , onPressed: () {

            Navigator.pop(context);
          }),
          TextButton(child: Text("SIM",style:
          TextStyle( color:Theme.of(context).textTheme.headline4.color,))
              , onPressed: () {
                _TextoBotao=true;
                ToastMensagem("Atualizando aguarde...", context);
                MotoboyChegou("chegou.");
                Navigator.pop(context);
              }),
        ]
    ).show(context);

    */
  }
  void MotoboyFinalizou(){
   /* NAlertDialog(
        dialogStyle: DialogStyle(
            titleDivider: true,
            backgroundColor: Theme
                .of(context)
                .dialogBackgroundColor),
        title: Text(
            "Atenção"),
        content: Text(
            "Você realmente finalizou o pedido?"),
        actions: <Widget>[

          TextButton(
              child: Text("NÃO",style:
              TextStyle( color:Theme.of(context).textTheme.headline4.color,))
              , onPressed: () {

            Navigator.pop(context);
          }),
          TextButton(child: Text("SIM",style:
          TextStyle( color:Theme.of(context).textTheme.headline4.color,))
              , onPressed: () {
                FinalizarPedido();

                //   Navigator.pop(context);
              }),
        ]
    ).show(context);

    */
  }
  Future<void> FinalizarPedido() async {

    Map<String,dynamic> dados=Map();
    dados["situacao"]="Pedido Finalizado";
    _db.collection("Pedidos").doc(widget.detalheCorrida!["id_doc"]).update(dados);

    _db.collection("user_motoboy")
        .doc(widget.detalheCorrida!["boy_id"])
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> dados = documentSnapshot.data()as Map<String,dynamic>;
        int meusItens=dados["n_pedidos"];
        int quantItens=int.parse(widget.detalheCorrida!["quant_itens"]);
        int total= meusItens-quantItens;
        if(total<0){
          _db.collection("user_motoboy").doc(widget.detalheCorrida!["boy_id"])
              .update({"n_pedidos": 0});
        }else{

          _db.collection("user_motoboy").doc(widget.detalheCorrida!["boy_id"])
              .update({"n_pedidos": total});
        }


      }else{
        ToastMensagem("Aconteceu um erro, tente novamente mais tarde.",context);
      }

    });

    ToastMensagem("Pedido Finalizado.", context);
    // AssistenciaMetodo.sendNotificationToDriver(widget.detalheCorrida,texto);
    //  GeofireAssistencia.List_motoboysProximos.clear();
    Navigator.pop(context);
  }
  Future<void> MotoboyChegou(String texto) {
    Map<String,dynamic> dados=Map();
    dados["situacao"]="Saiu para entrega";

    PLinhasCordenadas.clear();
    //homepageStreamSubscription.cancel();
    homepageStreamSubscription=null;

    return _db.collection("Pedidos").doc(widget.detalheCorrida!["id_doc"]).update(dados);

    // AssistenciaMetodo.sendNotificationToDriver(widget.detalheCorrida,texto);


  }
  void locatePosition() async {
    posicao_atual = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    if(posicao_atual!=null && widget.detalheCorrida!=null){
      _KGooglePlex=
          CameraPosition(target:  LatLng(posicao_atual!.latitude, posicao_atual!.longitude), zoom: 14);

    }

  }






  // void CriarIconMarker(){
  //   if(MotoboyIcon==null){
  //     ImageConfiguration imageConfiguration=createLocalImageConfiguration(context,size:Size(2,2));
  //     BitmapDescriptor.fromAssetImage(imageConfiguration, "imagens/direcao.png")
  //         .then((value)
  //     {
  //       MotoboyIcon=value;
  //     });
  //   }
  // }

  void verificarEstado(){
    if(widget.detalheCorrida!["id_doc"]!=null) {
      StreamSubscription<DocumentSnapshot>? streamSub;
      DocumentReference reference = FirebaseFirestore.instance.collection(
          'Pedidos').doc(widget.detalheCorrida!["id_doc"]);
      streamSub = reference.snapshots().listen((querySnapshot) {
        Map<String, dynamic> corridaAtual = querySnapshot.data()as Map<String,dynamic>;
        print('Document data:TelaPasseio ${querySnapshot.data()}');
        if (corridaAtual["situacao"]== "Cancelado") {
          streamSub!.cancel();
          SegundaTela();

        }
      });
    }


  }



  _moveToSignInScreen(BuildContext context) =>
     Navigator.pop(context);


}
class MapUtils {

  MapUtils._();


}