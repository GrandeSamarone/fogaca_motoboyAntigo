import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fogaca_app/Model/Historico.dart';
import 'package:fogaca_app/Notificacao/PushNotificacao.dart';
import '../Pages_pedido/TelaVerHistorico.dart';
import 'package:fogaca_app/Widget/HistoricoItem.dart';
import 'package:fogaca_app/Widget/HistoricoCarregando.dart';
import 'package:fogaca_app/Widget/Toast.dart';
import 'package:provider/provider.dart';

class EarningTabePage extends StatefulWidget{
  @override
  _EarningTabePageState createState() => _EarningTabePageState();
}
class _EarningTabePageState extends State<EarningTabePage> with AutomaticKeepAliveClientMixin {

  List<Historico> historico=[];

  int lenght;
  PushNotificacao pushNotificacao= PushNotificacao();
  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User usuarioLogado =  auth.currentUser;
    Query users = FirebaseFirestore.instance.collection('Pedidos')
        .where('boy_id',isEqualTo:usuarioLogado.uid)
        .where("estado",isEqualTo:"Fechado");

  return StreamBuilder<QuerySnapshot>(
    stream: users.snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return Text('erro');
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return  HistoricoCarregando();
      }

      return new ListView(
          children: <Widget>[
      Column(
        children: snapshot.data.docs.map((DocumentSnapshot document) {
          return HistoricoItem(historico:document.data());
        }).toList(),
      )
      ]
      );
    },
  );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}



