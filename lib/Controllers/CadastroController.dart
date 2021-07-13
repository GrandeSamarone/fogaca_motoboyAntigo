
 import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpfcnpj/cpfcnpj.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fogaca_app/Model/Motoboy.dart';

class CadastroController{
  CollectionReference _db = FirebaseFirestore.instance.collection("user_motoboy");
  String codcity;
  String erro;
  String token;
   Future<String> RegistrarNovoUsuario(Motoboy motoboy) async {

      User firebaseUser;
     final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

       try {
         final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
          token = await firebaseMessaging.getToken();

         firebaseUser = (await _firebaseAuth
             .createUserWithEmailAndPassword(
             email: motoboy.email,
             password: motoboy.senha).catchError((errMsg) {
           erro = errMsg.toString();
         }
         )).user;
       }catch (e) {
       }

       print("UID:::!${firebaseUser.uid}");
       if(firebaseUser.uid!=null){
         print("PASSOU!${firebaseUser.toString()}");

         final consult =await _db
             .where("email",isEqualTo:firebaseUser.email)
             .get()
             .then((value) => value.size);

         print("Size:: $consult");
         if(consult<=0){

           // print("ID DO ANIMAL::${firebaseUser.uid}");


           if(motoboy.cidade=="Ji-Paraná"){
             codcity="jipa";
           }else if(motoboy.cidade=="Ouro Preto"){
             codcity="ouropreto";
           }else if(motoboy.cidade=="Jaru"){
             codcity="jaru";
           }else if(motoboy.cidade=="Ariquemes"){
             codcity="ariquemes";
           }else if(motoboy.cidade=="Cacoal"){
             codcity="cacoal";
           }else if(motoboy.cidade=="Médici"){
             codcity="medici";
           }
           Map<String,dynamic> dados=Map();
           dados["id"]=firebaseUser.uid;
           dados["nome"]=motoboy.nome;
           dados["icon_foto"]="https://firebasestorage.googleapis.com/v0/b/fogaca-app.appspot.com/o/perfil%2Fcapacete.jpg?alt=media&token=55172947-3db3-4edd-9daa-93ceee0abd91";
           dados["tipo_dados"]=motoboy.tipo_dados;
           dados["cpf_cnpj"]=motoboy.cpf_cnpj;
           dados["tipo_user"]="motoboy";
           dados["telefone"]=motoboy.telefone;
           dados["email"]=motoboy.email;
           dados["token"]=token;
           dados["estrela"]="5.0";
           dados["cidade"]=motoboy.cidade;
           dados["cod"]=codcity;
           dados["estado"]="Rondônia";
           dados["online"]=false;
           dados["permissao"]=false;
           dados["modelo"]=motoboy.modelo;
           dados["placa"]=motoboy.placa;
           dados["cor"]=motoboy.cor;


           _db.doc(firebaseUser.uid).set(dados);

           return "sucesso";

         }else{
           return "esta conta já existe.";
         }
     }else{
         return "erro::::::${erro}";
       }


   }
 }