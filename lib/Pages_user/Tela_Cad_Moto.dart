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

  String codcity;
  @override
  Widget build(BuildContext context) {
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

                    Text("Cadastre sua Moto",
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
                        height:MediaQuery.of(context).size.height ,
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
                            bottom: 20,
                        top: 45),
                        child: Form(
                          key: _formKey,
                          child: Column(
                              children: [
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
                                  SizedBox(height: 15.0,),
                                  Container(
                                  child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                  Text("Selecione a cidade que irá trabalhar:",
                                    textAlign: TextAlign.left,
                                  style: TextStyle(
                                  fontSize: 15,
                                      fontWeight:FontWeight.w400,
                                  color: Colors.black45),
                                  ),
                                  Container(
                                  width: MediaQuery.of(context).size.width,
                                  alignment: AlignmentDirectional.center,
                                  decoration: BoxDecoration(
                                  color:  Colors.black45,
                                  borderRadius:
                                  BorderRadius.only(
                                  topLeft: Radius.circular(12.0),
                                  topRight:Radius.circular(12.0),
                                  bottomLeft:Radius.circular(12.0),
                                  bottomRight:Radius.circular(12.0),
                                  ),
                                  ),
                                  child: DropdownButton<String>(
                                  value: dropDownText,
                                  icon: Icon(FontAwesomeIcons.chevronDown),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Brand-Regular"),
                                  underline: Container(
                                    color: Colors.white,
                                  height: 0,
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
                                  ),
                                  )

                                  ],
                                  ),
                                  ),
                                  SizedBox(height:42.0),
                                  busy?WIBusy(
                                  busy: busy,
                                  child:  Container(
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
                                  ),
                                  ): Container(
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
                                      child:Text("Criar Conta"),
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
                                        if(dropDownText!="Selecione uma cidade"){
                                          if (_formKey.currentState.validate()) {
                                            _formKey.currentState.save();
                                            SalvarDriveMotoInfo(context);

                                          }
                                        }else{
                                          ToastMensagem("Selecione sua cidade de trabalho.", context);
                                        }
                                      },

                                    ),

                                  ),


                              ]

                          ),
                        )
                        )
                  ],
                ),
              )
          ),
        ]
    );

  }

   SalvarDriveMotoInfo(context)async {
     setState(() {
       busy=true;
     });
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
    Motoboy motoboy = Motoboy();
    motoboy.nome = widget.dadosMap["nome"];
    motoboy.email = widget.dadosMap["email"];
    motoboy.senha=widget.dadosMap["senha"];
    motoboy.tipo_dados = widget.dadosMap["tipo_dados"];
    motoboy.cpf_cnpj = widget.dadosMap["cpf_cnpj"];
    motoboy.telefone = widget.dadosMap["telefone"];
    motoboy.cidade = dropDownText;
    motoboy.cod = codcity;
    motoboy.estrela = "5.0";
    motoboy.modelo = _modelo;
    motoboy.placa = _placa;
    motoboy.cor = _cor;



    controllerCadastro.RegistrarNovoUsuario(motoboy).then((data) {

      switch (data.toString()) {
        case "sucesso":
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
