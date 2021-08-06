
import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fogaca_app/Model/Pedido.dart';

class ControllerPedido{
  /*
  CollectionReference _db = FirebaseFirestore.instance.collection("Pedidos");
  String codcity;
  String erro;
  Future<String> AtualizarPedido(Pedido pedido) async {


    try {
        Map<String,dynamic> dados=Map();
        dados["situacao"]="Corrida Aceita";
        dados["boy_foto"]=pedido.boy_foto;
        dados["boy_id"]=pedido.boy_id;
        dados["boy_moto_cor"]=pedido.boy_moto_cor;
        dados["boy_moto_modelo"]=pedido.boy_moto_modelo;
        dados["boy_moto_placa"]=pedido.boy_moto_placa;
        dados["boy_nome"]=pedido.boy_nome;
        dados["boy_telefone"]=pedido.boy_telefone;

        _db.doc(pedido.id_doc).update(dados);

        return "sucesso";

      }catch (e) {
      print("errocatch:::${e}");
    }



  }

   */
}