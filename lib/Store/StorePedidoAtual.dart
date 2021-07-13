import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';
part 'StorePedidoAtual.g.dart';

class StorePedidoAtual = _StorePedidoAtual with _$StorePedidoAtual;

abstract class _StorePedidoAtual with Store {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  StreamSubscription<DocumentSnapshot> streamSubDadosUsuario;
  StreamSubscription<DocumentSnapshot> streamSubPedido;

  @observable
  String _nome_lojista ;
  @observable
  String _id_lojista;
  @observable
  String  _end_lojista ;
  @observable
  String  _Tel_lojista ;
  @observable
  String  _icon_lojista;
  @observable
  String   _lat_lojista;
  @observable
  String  _long_lojista;
  @observable
  String  _quant_itens;

  String get id_lojista => _id_lojista;
  String get nome_lojista => _nome_lojista;
  String get icon_lojista => _icon_lojista;
  String get end_lojista => _end_lojista;
  String get tel_lojista => _Tel_lojista;
  String get  lat_lojista=> _lat_lojista;
  String get long_lojista => _long_lojista;
  String get quant_itens => _quant_itens;

  @action
  void DadosDoPedidoAtual(String pushCod){
    if(pushCod!=null) {
      DocumentReference reference = FirebaseFirestore.instance.collection(
          'Pedidos').doc(pushCod);
      streamSubPedido = reference.snapshots().listen((querySnapshot) {
        Map<String, dynamic> corridaAtual = querySnapshot.data();
        if(corridaAtual != null){
          _id_lojista = corridaAtual["id_usuario"];
          _nome_lojista = corridaAtual["nome_ponto"];
          _icon_lojista = corridaAtual["icon_loja"];
          _end_lojista = corridaAtual["end_ponto"];
          _Tel_lojista=corridaAtual["telefone"];
          _lat_lojista=corridaAtual["lat_ponto"];
          _long_lojista=corridaAtual["long_ponto"];
          _quant_itens=corridaAtual["quant_itens"];
          //   pushCod = null;
        }else{
          streamSubPedido.cancel();
        }
      });
    }else{
      //  streamSub.cancel();

    }

  }

  void FecharPedido(){
    if(streamSubPedido!=null){
      streamSubPedido.cancel();
    }

  }
}