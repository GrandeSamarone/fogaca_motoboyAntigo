import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fogaca_app/Components/CPButtonVermelho.comp.dart';
import 'package:fogaca_app/Components/CPTextFormField.dart';
import 'package:fogaca_app/Controllers/CadastroController.dart';
import 'package:fogaca_app/Model/Motoboy.dart';
import 'package:fogaca_app/Providers/Firestore_Dados.dart';
import 'package:fogaca_app/Widget/Toast.dart';
import 'package:fogaca_app/Widget/WIBusy.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Page/SplashScreen.dart';

class Tela_Cad_Moto extends StatefulWidget{

  static const String idScreen = "motoinfo";
  Map dadosMap;

 Tela_Cad_Moto(this.dadosMap, {Key key}) : super(key: key);

  @override
  _Tela_Cad_MotoState createState() => _Tela_Cad_MotoState();
}

class _Tela_Cad_MotoState extends State<Tela_Cad_Moto> {
  String _modelo;

  String _cor;

  String _placa;

  var busy=false;

  final _formKey = GlobalKey<FormState>();

  final controllerCadastro = new CadastroController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Colors.red[900]),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor:Colors.white.withOpacity(0),
        elevation: 0,
      ),
      body:SafeArea(
        child: SingleChildScrollView(
          child:Column(
            children: [
              SizedBox(
                  width: double.infinity
              ),
              Image.asset("imagens/fogacasemnome.png",
                width:180,
                height: 120,
              ),
              Padding(padding: EdgeInsets.fromLTRB(22.0, 22.0, 22.0, 32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height:12.0),
                      Text(
                        "Insira os detalhes da moto",
                        style: TextStyle(
                          fontSize: 18.0, fontFamily: "Brand Bold", color: Theme
                            .of(context)
                            .textTheme
                            .bodyText1
                            .color,),
                        textAlign: TextAlign.center,
                      ),


                      SizedBox(height:26.0),
                      CPTextFormField(
                        textCapitalization: TextCapitalization.characters,
                        type: TextInputType.text,
                        obscureText: false,
                        maxlenght:15,
                        labeltext:"Modelo",

                        validator: (value) {
                          if (value.isEmpty) {
                            return '*Digite um modelo de moto.';
                          }else if(value.length<4){
                            return '*mínimo 4 caracteres.';
                          }
                          return null;
                        },
                        onSaved: (input) => _modelo = input,
                      ),
                      SizedBox(height:10.0),
                      CPTextFormField(
                        textCapitalization: TextCapitalization.characters,
                        type: TextInputType.text,
                        obscureText: false,
                        maxlenght:7,
                        labeltext:"Placa",

                        validator: (value) {
                          if (value.isEmpty) {
                            return '*Digite a placa.';
                          }else if(value.length<7){
                            return '*incorreto.';
                          }
                          return null;
                        },
                        onSaved: (input) => _placa = input,
                      ),
                      SizedBox(height:10.0),
                      CPTextFormField(
                        textCapitalization: TextCapitalization.characters,
                        type: TextInputType.text,
                        obscureText: false,
                        maxlenght:15,
                        labeltext:"Cor",

                        validator: (value) {
                          if (value.isEmpty) {
                            return '*cor é necessária.';
                          }else if(value.length<1){
                            return '*incorreto.';
                          }
                          return null;
                        },
                        onSaved: (input) => _cor = input,
                      ),
                      SizedBox(height:42.0),
                      WIBusy(
                        busy: busy,
                        child:   Container(
                            width: double.infinity,
                            height: 50.0,
                            child: CPButton(
                              text:"Criar Conta",
                              callback:(){

                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  SalvarDriveMotoInfo(context);

                                }
                              },

                            )

                        ),
                      ),

                    ],
                  ),
                ),)

            ],
          ),
        ),
      ),

    );
  }

   SalvarDriveMotoInfo(context)async {
     setState(() {
       busy=true;
     });
    Motoboy motoboy = Motoboy();
    motoboy.nome = widget.dadosMap["nome"];
    motoboy.email = widget.dadosMap["email"];
    motoboy.senha=widget.dadosMap["senha"];
    motoboy.tipo_dados = widget.dadosMap["tipo_dados"];
    motoboy.cpf_cnpj = widget.dadosMap["cpf_cnpj"];
    motoboy.telefone = widget.dadosMap["telefone"];
    motoboy.cidade = widget.dadosMap["cidade"];
    motoboy.cod = widget.dadosMap["cod"];
    motoboy.estrela = "5.0";
    motoboy.modelo = _modelo;
    motoboy.placa = _placa;
    motoboy.cor = _cor;



    controllerCadastro.RegistrarNovoUsuario(motoboy).then((data) {

      switch (data.toString()) {
        case "sucesso":
          ToastMensagem("Cadastro efetuado com sucesso!", context);
          onSucess();
          return;
        case "[firebase_auth/wrong-password] The password is invalid or the user does not have a password.":
          ToastMensagem("Senha incorreta.", context);
          return;

        case "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.":
          ToastMensagem("Conta não cadastrada.", context);
          return;
        case "esta conta não existe.":
          ToastMensagem("esta conta nao existe.", context);
          return;
      }
    }).catchError((err) {
      print("Dados Retornados::" + err.toString());
      onError();
    }).whenComplete(() {
      onComplete();
    });
  }

  onSucess(){
    //indo para a pagina do mapa
    Navigator.pushNamedAndRemoveUntil(
        context, SplashScreen.idScreen, (route) => false);
  }

  onError(){}

  onComplete(){

    setState(() {
      busy=false;
    });
  }
}
