import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fogaca_app/Model/Historico.dart';
import 'package:fogaca_app/Notificacao/PushNotificacao.dart';
import 'package:fogaca_app/Widget/WICustomFutureBuilder.dart';
import '../Pages_pedido/TelaVerHistorico.dart';
import 'package:fogaca_app/Widget/Toast.dart';
import 'package:provider/provider.dart';

class EarningTabePage extends StatefulWidget{
  @override
  _EarningTabePageState createState() => _EarningTabePageState();
}
class _EarningTabePageState extends State<EarningTabePage> with AutomaticKeepAliveClientMixin {

  List<Historico> historico=[];

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User usuarioLogado =  auth.currentUser;
  return Scaffold(

        body:WICustomFutureBuilder(
            colletion: "Pedidos",
            estado:"Fechado",
            msgvazio: "Nenhum histórico encontrado.",
            id_usuario: usuarioLogado.uid
        ),

    );

  }


  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}



