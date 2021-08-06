import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fogaca_app/Assistencia/SocialSignInModel.dart';
import 'package:fogaca_app/Model/Motoboy.dart';
import 'package:fogaca_app/Page/SplashScreen.dart';
import 'package:fogaca_app/Pages_user/Tela_Cad_Moto.dart';
import 'package:fogaca_app/Widget/WiAlerts.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';

abstract class CadastroController extends State<Tela_Cad_Moto> with SocialSignInModel{
  var busy=false;
  var senha;
  var email;
  var repetirsenha;
  var codcity;
  final formKey = GlobalKey<FormState>();
  bool visible_SENHA = true;
  late Size size;

  String dropDownText = 'Selecione uma cidade';
  List <String> ItensList = [
    'Selecione uma cidade',
    'Ji-Paraná',
    'Ouro Preto',
    'Jaru',
    'Ariquemes',
    'Cacoal',
    'Médici',
  ];

  VerificarDados(){

    setState(() {
      busy=true;
    });


    Motoboy lojista = new Motoboy();
    lojista.nome= widget.dadosMap["nome"];
    lojista.email= email;
    lojista.cidade=dropDownText;
    lojista.estado= "Rondônia";
    lojista.tipo_dados=widget.dadosMap["tipo_dados"];
    lojista.cpf_cnpj= widget.dadosMap["cpf_cnpj"];
    lojista.tipo_user="newUser";
    lojista.permissao =false;
    lojista.telefone= widget.dadosMap["telefone"];
    lojista.icon_foto="https://firebasestorage.googleapis.com/v0/b/fogaca-app.appspot.com/o/perfil%2Ficonusernfoto.jpg?alt=media&token=370e2f4a-a059-453e-a2f3-a4d8e5d7d7ef";

    RegistrarNovoUsuario(lojista,senha).then((data) {
      switch(data.toString()){
        case "sucesso":
          onSucess();
          return;
        case "[firebase_auth/wrong-password] The password is invalid or the user does not have a password.":
          WiAlerts.of(context).snack("Senha incorreta.");
          return;

        case "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.":
          WiAlerts.of(context).snack("Conta não cadastrada.");
          return;
        case "esta conta não existe.":
          WiAlerts.of(context).snack("Conta não existe.");
          return;
      }

    }).catchError((err){
      if(err.toString()=="type 'Null' is not a subtype of type 'FutureOr<UserCredential>'"){
        WiAlerts.of(context).snack("E-mail já cadastrado em outra conta.");
      }else
      if(err.toString()=="type 'String' is not a subtype of type 'FutureOr<UserCredential>'"){
        WiAlerts.of(context).snack("E-mail já cadastrado em outra conta.");
      }

      print("Dados Retornados::"+err.toString());
    }).whenComplete(() {
      onComplete();
    });
  }
  onSucess(){
    Navigator.pushNamedAndRemoveUntil(
        context, SplashScreen.idScreen, (route) => false);
  }
  onComplete(){

    setState(() {
      busy=false;
    });
  }


}