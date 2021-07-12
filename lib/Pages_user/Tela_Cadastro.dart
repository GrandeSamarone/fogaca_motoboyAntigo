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

  bool _visible_CPF = false;
  bool _visible_CNPJ = false;
  bool _visible_SENHA = true;
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
  final FirebaseFirestore _db = FirebaseFirestore.instance;

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

  @override
  Widget build(BuildContext context) {
    Cadastrar_usuario=Provider.of<Dados_usuario>(context);
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
        body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(height: 15,),

                  Container(
                      width: 400,
                      decoration:BoxDecoration(
                          color:Colors.white,
                          boxShadow:[
                            new BoxShadow(
                                color:Colors.black12,
                                offset:new Offset(1, 2.0),
                                blurRadius: 5,
                                spreadRadius: 1
                            )
                          ]
                      ),
                      padding: EdgeInsets.only(left: 20,right: 20,bottom: 20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                            children: [
                              SizedBox(height: 10,),
                              Text(
                                "Vamos começar criando uma conta",
                                style: TextStyle(
                                    fontWeight:FontWeight.w700 ,
                                    fontSize: 18.0,
                                    fontFamily: "Brand Bold",
                                    color:Colors.red[900]
                                ),
                              ),
                              SizedBox(height: 20.0),
                              CPTextFormField(
                                textCapitalization: TextCapitalization.none,
                                type: TextInputType.text,
                                obscureText: false,
                                maxlenght:35,
                                labeltext:"Nome",

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
                                labeltext:"Telefone",

                                validator: (value) {
                                  if (value.isEmpty) {
                                    return '*número de telefone é obrigatório.';
                                  }
                                  return null;
                                },
                                onSaved: (input) => _tel = input,
                              ),

                              SizedBox(height: 3.0),
                              Text(
                                "Selecione uma  opção:",
                                style: TextStyle(fontSize: 15.0,
                                  fontFamily: "Brand Bold",
                                  fontWeight:FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                              ),

                              new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Radio(
                                    value: "cpf",
                                    groupValue: _escolhaUsuario,
                                    onChanged: (String escolha) {
                                      ResultadoBox(true,escolha);
                                      cnpj_Controller.clear();
                                    },
                                  ),
                                  new Text(
                                    'CPF',
                                    style: new TextStyle(
                                      fontWeight:FontWeight.w400,
                                      fontSize: 12,),
                                  ),
                                  new Radio(
                                    value: "cnpj",
                                    groupValue: _escolhaUsuario,
                                    onChanged: (String escolha) {
                                      ResultadoBox(true,escolha);
                                      cpf_Controller.clear();
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

                              _visible_CPF ?
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

                              _visible_CNPJ?
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
                                maxlenght:35,
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
                                labeltext:"Repetir senha",

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

                              SizedBox(height: 15.0,),
                              Container(
                                height: 80.0,
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Text("Selecione à cidade que irá trabalhar",textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 12, fontWeight:FontWeight.w400),
                                    ),

                                    DropdownButton<String>(
                                      value: dropDownText,
                                      isExpanded: true,
                                      icon: Icon(Icons.arrow_drop_down),
                                      iconSize: 24,
                                      elevation: 16,
                                      style: TextStyle(color: Theme.of(context).textTheme.headline4.color, fontSize: 16,fontFamily:  "Brand Bold"),
                                      underline: Container(
                                        height: 2,
                                        color: Theme.of(context).textTheme.headline4.color,
                                      ),
                                      onChanged: (String data) {
                                        setState(() {
                                          dropDownText = data;
                                        });
                                      },
                                      items: ItensList.map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Center(
                                            child: Text(
                                              value,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 10.0,),

                                Container(
                                    width: double.infinity,
                                    height: 50.0,
                                    child: CPButton(
                                      text:">> Próxima",
                                      callback:(){

                                        if (_formKey.currentState.validate()) {
                                          _formKey.currentState.save();
                                          if(dropDownText=="Selecione uma cidade"){
                                            ToastMensagem("Selecione sua cidade de trabalho.", context);
                                          } else if(_senha!=_repetirsenha) {
                                            ToastMensagem("Senhas estão diferentes.", context);
                                          }else{
                                            RegistrarNovoUsuario();
                                          }
                                        }
                                      },

                                    )

                                ),
                            ]

                        ),
                      )
                  ),
                ],
              ),
            )
        )
    );

  }

  void RegistrarNovoUsuario(){
    String cpf_formatado=CPF.format(cpf_Controller.text);
    String cnpj_formatado=CPF.format(cnpj_Controller.text);
    String tipoDado;
    String codcity;
    String dados_formatado;

      if(dropDownText=="Ji-Paraná"){
        codcity="jipa";
      }else if(dropDownText=="Ouro Preto"){
        codcity="ouropreto";
      }else if(dropDownText=="Jaru"){
        codcity="jaru";
      }else if(dropDownText=="Ariquemes"){
        codcity="ariquemes";
      }else if(dropDownText=="Cacoal"){
        codcity="cacoal";
      }else if(dropDownText=="Médici"){
        codcity="medici";
      }
      if(cpf_formatado.isNotEmpty){
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
      Data["tipo_dados"] = tipoDado;
      Data["cpf_cnpj"] = dados_formatado;
      Data["telefone"] = _tel;
      Data["cidade"] = dropDownText;
      Data["cod"] = codcity;

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Tela_Cad_Moto(Data)));
      // Navigator.pushNamed(context, MotoInfo.idScreen,arguments: Data);




  }


  void ResultadoBox(bool visivel,String resultado){
    setState(() {
      _escolhaUsuario=resultado;

      switch(_escolhaUsuario){
        case "cpf":
          print("cpf foi o item selecionado");
          _visible_CPF=visivel;
          _visible_CNPJ=false;
          break;
        case "cnpj":
          print("cnpj foi o item selecionado");
          _visible_CNPJ=visivel;
          _visible_CPF=false;
          break;
      }

    });
  }
}

