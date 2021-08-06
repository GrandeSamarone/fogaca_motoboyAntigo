import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/cupertino.dart';
import 'package:fogaca_app/Model/Historico.dart';
import 'package:fogaca_app/Model/Motoboy.dart';
import 'package:fogaca_app/Model/Pedido.dart';


class Dados_usuario extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Motoboy usuario;
  String _nome;
  String pushCod;

  String get nome => _nome;
  set nome(String value) {
    _nome = value;
  }


  alterarNome(String nome){
    _nome=nome;
    notifyListeners();
  }

  Stream<List<Pedido>> GetPedidos(){
    FirebaseAuth auth = FirebaseAuth.instance;
    User usuarioLogado =  auth.currentUser;
    return _db.collection("Pedidos")
        .where('boy_id',isEqualTo: usuarioLogado.uid)
        .where("estado",isEqualTo:"Aberto")
        .snapshots()
        .map((event) => event.docs.map((dadosPedido)
    =>Pedido.fromFirestore(dadosPedido.data())).toList());
  }

  Stream<List<Motoboy>> GetClientes(){
    FirebaseAuth auth = FirebaseAuth.instance;
    User usuarioLogado =  auth.currentUser;

    print("DADOS DO MOTOBOY ONLINE PROVIDER:::${usuarioLogado.uid}");
    return _db.collection("user_motoboy").where('id',isEqualTo:usuarioLogado.uid)
        .snapshots().map((event) => event.docs.map((dados)
    =>Motoboy.fromFirestore(dados.data())).toList());
  }


  Future<void> Atualizar_Online_Offline(Map on_off) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User usuarioLogado =  auth.currentUser;
    return _db.collection("user_motoboy").doc(usuarioLogado.uid).update(on_off);
  }
 Future<void> Atualizar_Pedido(List<Motoboy> motoboy,String id,String quant ) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User usuarioLogado =  auth.currentUser;
    Map<String,dynamic> dados=Map();
    dados["situacao"]="Corrida Aceita";
    dados["boy_foto"]=motoboy[0].icon_foto;
    dados["boy_id"]=motoboy[0].id;
    dados["boy_moto_cor"]=motoboy[0].cor;
    dados["boy_moto_modelo"]=motoboy[0].modelo;
    dados["boy_moto_placa"]=motoboy[0].placa;
    dados["boy_nome"]=motoboy[0].nome;
    dados["boy_telefone"]=motoboy[0].telefone;
   // dados["boy_token"]=motoboy[0].token;

   //Atualizar Quantidade de Pedidos
    Atualizar_CorridaMotoboy(quant);

    return _db.collection("Pedidos").doc(id).update(dados);

  }
Future<void> Atualizar_CorridaMotoboy(String Npedidos) {
  int QuantItens = int.tryParse(Npedidos);
    FirebaseAuth auth = FirebaseAuth.instance;
    User usuarioLogado =  auth.currentUser;


  _db.collection('user_motoboy')
      .where("id",isEqualTo:usuarioLogado.uid)
      .get()
      .then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      int n_pedidos=doc["n_pedidos"];

      int total=n_pedidos+QuantItens;

      Map<String,dynamic> dados=Map();
      dados["situacao"]="Saiu para entrega";
      dados["n_pedidos"]=total;

      return _db.collection("user_motoboy").doc(usuarioLogado.uid).update(dados);
    });
  });


  }



}