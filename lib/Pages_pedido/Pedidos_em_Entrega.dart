import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fogaca_app/Model/Pedido.dart';
import 'package:fogaca_app/Notificacao/NotificacaoDialog.dart';
import 'package:fogaca_app/Notificacao/PushNotificacao.dart';
import 'package:fogaca_app/Widget/WICustomFutureBuilder.dart';
import 'Tela_Passeio.dart';
import 'package:fogaca_app/Providers/Firestore_Dados.dart';
import 'package:fogaca_app/Widget/PedidoItem.dart';
import 'package:fogaca_app/Widget/Toast.dart';
import 'package:provider/provider.dart';

import '../Page/Mapa_Home.dart';

class Pedidos_em_Entrega extends StatefulWidget{
  static const String idScreen = "Pedidos_em_Entrega";
  Pedidos_em_EntregaState createState() =>Pedidos_em_EntregaState();

}

class Pedidos_em_EntregaState extends State<Pedidos_em_Entrega> {

  PushNotificacao pushNotificacao= PushNotificacao();
  List<Pedido> pedidos;
  Pedido detalheCorrida=Pedido();
  Dados_usuario Pedido_Detalhe;
  Color ColorButton=Colors.grey[700];
  @override
  Widget build(BuildContext context) {
    //pushNotificacao.initialize(context);
    FirebaseAuth auth = FirebaseAuth.instance;
    User usuarioLogado =  auth.currentUser;
    return  WillPopScope(
      onWillPop: () {
        _moveToSignInScreen(context);
      },
      child:Scaffold(
        appBar: new AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back),
            tooltip: "",
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: new Text(
              "Pedidos para entrega"
          ),
        ),
        body:WICustomFutureBuilder(
            colletion: "Pedidos",
            estado:"Aberto",
            msgvazio: "Nenhum pedido encontrado.",
            id_usuario: usuarioLogado.uid
        ),
      ),
    );
  }


  void _moveToSignInScreen(BuildContext context) =>
      Navigator.pop(context);

}

