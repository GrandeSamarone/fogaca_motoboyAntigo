import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpfcnpj/cpfcnpj.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fogaca_app/Components/CPButtonVermelho.comp.dart';
import 'package:fogaca_app/Components/CPTextFormField.dart';
import 'package:fogaca_app/Controllers/CadastroController.dart';
import 'package:fogaca_app/Model/Motoboy.dart';
import 'package:fogaca_app/Page/SplashScreen.dart';
import 'package:fogaca_app/Widget/WIBusy.dart';
import 'package:fogaca_app/Widget/WIDivider.dart';
import 'Tela_Login.dart';
import 'Tela_Cad_Moto.dart';
import 'package:fogaca_app/Providers/Firestore_Dados.dart';
import 'package:fogaca_app/Widget/Divider.dart';
import 'package:fogaca_app/Widget/Toast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';

import 'package:url_launcher/url_launcher.dart';


class Tela_Cadastro extends StatefulWidget {

  static const String idScreen = "register";
  _Tela_CadastroState createState() => _Tela_CadastroState();
}

class _Tela_CadastroState extends State<Tela_Cadastro> {

  bool _visible_SENHA = true;
  bool _isValid = true;
  final _formKey = GlobalKey<FormState>();
  final controllerCadastro = new CadastroController();
  Dados_usuario Cadastrar_usuario;
  String  _nome;
  String _email;
  String _tel;
  String _cpf_cnpj;
  String _senha;
  String _repetirsenha;
  String _escolhaUsuario=null;
  TextEditingController cpf_Controller = TextEditingController();
  TextEditingController cnpj_Controller = TextEditingController();
  bool CPFValid = false;
  bool CNPJValid = false;
  final FirebaseFirestore _db = FirebaseFirestore.instance;


  @override
  Widget build(BuildContext context) {
    Cadastrar_usuario=Provider.of<Dados_usuario>(context);
    return Stack(
      children: [
        Image.asset(
        "imagens/Vector_Cadastro.png",
        ),
      Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding:EdgeInsets.only(
                          top: 20,
                      left: 10),
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.topLeft,
                      child:TextButton.icon(
                          onPressed:(){
                            Navigator.of(context).pop();
                          },
                          icon:  Icon(Icons.arrow_back,
                              color: Colors.white),
                          label:Text("")) ,
                    ),

                    Text("Crie sua Conta",
                    style:
                    TextStyle(
                    fontFamily:"Brand Bold",
                    fontSize: 25,
                        color: Colors.white
                    ),
                    ),

                    SizedBox(height: 20,),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        decoration:BoxDecoration(
                            borderRadius:
                            BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight:Radius.circular(30.0),),
                            color:Color(0xFFFDFDFD),
                            boxShadow:[
                              new BoxShadow(
                                  color:Colors.black12,
                                  offset:new Offset(1, 2.0),
                                  blurRadius: 5,
                                  spreadRadius: 1
                              )
                            ]
                        ),
                        padding: EdgeInsets.only(
                            left: 40,
                            right: 40,
                            bottom: 20
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(

                              children: [
                                SizedBox(height:40.0),
                                CPTextFormField(
                                  textCapitalization: TextCapitalization.none,
                                  type: TextInputType.text,
                                  obscureText: false,
                                  maxlenght:35,
                                  labeltext:"Nome do Usuário",

                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return '*Digite um nome.';
                                    }else if(value.length<4){
                                      return '*mínimo 4 caracteres.';
                                    }
                                    return null;
                                  },
                                  onSaved: (input) => _nome = input,
                                ),

                                SizedBox(height: 1.0),

                                CPTextFormField(
                                  textCapitalization: TextCapitalization.none,
                                  type: TextInputType.phone,
                                  obscureText: false,
                                  maxlenght:12,
                                  labeltext:"Telefone (99)9999-9999",

                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return '*número de telefone é obrigatório.';
                                    }
                                    return null;
                                  },
                                  onSaved: (input) => _tel = input,
                                ),

                                SizedBox(height: 3.0),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child:Text(
                                    "Selecione uma  opção:",
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontFamily: "Brand Bold",
                                      fontWeight:FontWeight.w400,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),


                                new Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    new Checkbox(
                                      value: CPFValid,
                                      onChanged: (bool value) {
                                        setState(() {
                                          CPFValid = value;
                                         CNPJValid = false;
                                         cnpj_Controller.clear();
                                         // valWednesday = false;
                                        });
                                      },
                                    ),
                                    new Text(
                                      'CPF',
                                      style: new TextStyle(
                                        fontWeight:FontWeight.w400,
                                        fontSize: 12,),
                                    ),
                                    new  Checkbox(
                                      value: CNPJValid,
                                      onChanged: (bool value) {
                                      setState(() {
                                        CNPJValid = value;
                                      CPFValid = false;
                                      cpf_Controller.clear();
                                      // valWednesday = false;
                                      });
                                      },
                                      ),
                                    new Text(
                                      'CNPJ',
                                      style: new TextStyle(
                                        fontWeight:FontWeight.w400,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                WIDividerWidget(),

                                CPFValid ?
                                CPTextFormField(
                                  textCapitalization: TextCapitalization.none,
                                  // autofocus: true,
                                  type: TextInputType.number,
                                  obscureText: false,
                                  maxlenght:11,
                                  labeltext:"Cpf",
                                  Controller: cpf_Controller,
                                  validator: (value) {
                                    if (value.isNotEmpty) {
                                      if(CPF.isValid(value)==false){
                                        return '*Cpf inválido.';
                                      }

                                    }
                                    return null;
                                  },
                                  //   onSaved: (input) => _cpf_cnpj = input,
                                ): new Container(),

                                CNPJValid?
                                CPTextFormField(
                                  textCapitalization: TextCapitalization.none,
                                  // autofocus: true,
                                  type: TextInputType.number,
                                  obscureText: false,
                                  maxlenght:14,
                                  labeltext:"Cnpj",
                                  Controller: cnpj_Controller,

                                  validator: (value) {
                                    if (value.isNotEmpty) {
                                      if(CNPJ.isValid(value)==false){
                                        return '*Cnpj inválido.';
                                      }

                                    }
                                    return null;
                                  },
                                  //  onSaved: (input) => _cpf_cnpj = input,
                                ): new Container(),

                                SizedBox(height: 1.0),
                                CPTextFormField(
                                  textCapitalization: TextCapitalization.none,
                                  // autofocus: true,
                                  type: TextInputType.emailAddress,
                                  obscureText: false,
                                  labeltext:"E-mail",
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return '*Digite um e-mail.';
                                    }else if(!value.contains("@")){
                                      return '*Digite um e-mail válido.';
                                    }
                                    return null;
                                  },
                                  onSaved: (input) => _email = input,

                                ),
                                SizedBox(height: 1.0,),

                                _visible_SENHA?
                                CPTextFormField(
                                  type: TextInputType.visiblePassword,
                                  textCapitalization: TextCapitalization.none,
                                  obscureText: true,
                                  labeltext:"Senha",

                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "*Digite uma senha." ;
                                    }else if(value.length<=5){
                                      return '*Senha no mínimo 6 digitos';
                                    }
                                    return null;
                                  },
                                  onSaved: (input) => _senha = input,
                                ):Container(),

                                SizedBox(height: 1.0,),
                                _visible_SENHA?
                                CPTextFormField(
                                  textCapitalization: TextCapitalization.none,
                                  obscureText: true,
                                  labeltext:"Confirmar senha",

                                  validator: (value) {
                                    setState(() {

                                    });
                                    if (value.isEmpty) {
                                      return "*Por favor repetir a mesma senha." ;
                                    }
                                    return null;
                                  },
                                  onSaved: (input) => _repetirsenha = input,
                                ) :Container(),
                                SizedBox(height: 30.0,),

                                  Container(
                                      width:250,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFFF9C184),
                                          Color(0xFFEA9971)
                                        ],
                                      ),
                                    ),
                                      child: ElevatedButton(
                                          child:Text(">> Continuar"),
                                          style: ElevatedButton.styleFrom(

                                            primary: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            textStyle: TextStyle(

                                                color: Colors.white54,
                                                fontSize: 23,
                                                fontFamily: "Brand Bold"
                                                ,fontWeight: FontWeight.bold
                                            ),
                                          ),

                                          onPressed:(){
                                      if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();
                                      if(_senha!=_repetirsenha) {
                                      ToastMensagem("Senhas estão diferentes.", context);
                                      }else{
                                      RegistrarNovoUsuario();
                                      }
                                      }
                                      },
                                      ),

                                  ),
                              ]

                          ),
                        )
                    ),
                  ],
                ),
          )
      ),
   ]
    );

  }

  void RegistrarNovoUsuario(){
    String cpf_formatado=CPF.format(cpf_Controller.text);
    String cnpj_formatado=CPF.format(cnpj_Controller.text);
    String tipoDado;
    String dados_formatado;


      if(CPFValid){
        tipoDado="cpf";
        dados_formatado=cpf_formatado;
      }else{
        tipoDado="cnpj";
        dados_formatado=cnpj_formatado;
      }

      Map<String, dynamic> Data = new Map();
      Data["nome"] = _nome;
      Data["email"] =_email;
      Data["senha"] =_senha;
    Data["telefone"] = _tel;
      Data["tipo_dados"] = tipoDado;
      Data["cpf_cnpj"] = dados_formatado;

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Tela_Cad_Moto(Data)));
      // Navigator.pushNamed(context, MotoInfo.idScreen,arguments: Data);




  }


}

