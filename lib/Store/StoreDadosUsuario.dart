import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:fogaca_app/Model/Endereco.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';
part 'StoreDadosUsuario.g.dart';

class StoreDadosUsuario = _StoreDadosUsuario with _$StoreDadosUsuario;

abstract class _StoreDadosUsuario with Store {
   final FirebaseFirestore _db = FirebaseFirestore.instance;
   StreamSubscription<DocumentSnapshot> streamSubDadosUsuario;
   ControllerBase(){
      //execulta sempre que o observavel é alterado
      autorun((_){
      //   print(email);
       //  print(senha);
      });
   }
   @observable
   String emailLogin="";
   @observable
   String senhaLogin="";
   @observable
   LatLng _latLng;
   @observable
   String _nome;
   @observable
   bool _online_off;
   @observable
   String _foto;
   @observable
   String _telefone;
   @observable
   String _email;
   @observable
   String _cpfcnpj;
   String _id;
   @observable
   String _codcity;
   @observable
   String _city;
   @observable
   String _token;
   @observable
   bool _permissao;
   @observable
   String _modelo_moto;
   @observable
   String _placa_moto;
   @observable
   String _cor_moto;
   @observable
   String _estrela;


   String get foto => _foto;
   String get email => _email;
   bool get online_offline =>_online_off;
   String get cpf_cnpj => _cpfcnpj;
   String get telefone => _telefone;
   String get id => _id;
   String get codcity => _codcity;
   String get token => _token;
   bool get permissao => _permissao;
   String get nome => _nome;
   String get city => _city;
   LatLng get latlng => _latLng;
   String get modelo_moto => _modelo_moto;
   String get placa_moto => _placa_moto;
   String get cor_moto => _cor_moto;
   String get estrela => _estrela;


   @action
   void DadosMotoboy(){
      FirebaseAuth auth = FirebaseAuth.instance;
      User usuarioLogado =  auth.currentUser;
      if(usuarioLogado.uid!=null) {
         DocumentReference reference = FirebaseFirestore.instance.collection(
             'user_motoboy').doc(usuarioLogado.uid);
         streamSubDadosUsuario = reference.snapshots().listen((querySnapshot) {
            Map<String, dynamic>  motoboyatual = querySnapshot.data();
            _id=motoboyatual["id"];
            _nome=motoboyatual["nome"];
            _email=motoboyatual["email"];
            _online_off=motoboyatual["online"];
            _cpfcnpj=motoboyatual["cpf_cnpj"];
            _foto=motoboyatual["icon_foto"];
            _telefone=motoboyatual["telefone"];
            _codcity=motoboyatual["cod"];
            _city=motoboyatual["cidade"];
            _token=motoboyatual["token"];
            _permissao=motoboyatual["permissao"];
            _modelo_moto=motoboyatual["modelo"];
            _placa_moto=motoboyatual["placa"];
            _cor_moto=motoboyatual["cor"];
            _estrela=motoboyatual["estrela"];

            print("codcityStore::${_estrela}");
         });
      }else{
         streamSubDadosUsuario.cancel();
      }
   }
   void FecharDados(){
     streamSubDadosUsuario.cancel();
   }



   @action
   Future locatePosition() async {
     var geolocator = Geolocator();
     Endereco posicaoatual =Endereco();
     Position position = await geolocator.getCurrentPosition(
         desiredAccuracy: LocationAccuracy.high);
     _latLng=LatLng(position.latitude,position.longitude);
     return _latLng;
   }
}