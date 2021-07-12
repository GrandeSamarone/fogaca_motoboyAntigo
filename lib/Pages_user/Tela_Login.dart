import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fogaca_app/Components/CPButtonText.dart';
import 'package:fogaca_app/Components/CPButtonVermelho.comp.dart';
import 'package:fogaca_app/Components/CPTextFormField.dart';
import 'package:fogaca_app/Controllers/LoginController.dart';
import 'package:fogaca_app/Page/SplashScreen.dart';
import 'package:fogaca_app/Widget/Toast.dart';
import 'package:fogaca_app/Widget/WIBusy.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'Tela_Cadastro.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';

import 'Tela_RedefinirSenha.dart';


class Tela_Login extends StatefulWidget{
  static const  String idScreen="login";
  static const url ="https://api.whatsapp.com/send?phone=556992417580&text=ol%C3%A1";

  @override
  _Tela_LoginState createState() => _Tela_LoginState();
}

class _Tela_LoginState extends State<Tela_Login> {
  Map<String,dynamic> _dadosUsuario;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final controllerLogin = new LoginController();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final scaffoldkey=new GlobalKey<ScaffoldState>();
  var busy=false;
  String _email;
  String _senha;
  final _formKey = GlobalKey<FormState>();

  var encoded = Uri.encodeFull(Tela_Login.url);


  //Açao do botao Login
  SignInEmail(){

    setState(() {
      busy=true;
    });
    controllerLogin.LoginEmail(_email,_senha).then((data) {

      print("INFORMAÇÃO RETORNADA::"+data.toString());

      if(data.toString()=="sucesso"){
        ToastMensagem("Login efetuado com sucesso!", context);
        onSucessEmail();
      }else if(data.toString()=="[firebase_auth/wrong-password] The password is invalid or the user does not have a password."){
        ToastMensagem("Senha incorreta.", context);
      }else if(data.toString()=="[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted."){
        ToastMensagem("Conta não cadastrada.", context);
      }else if(data.toString()=="esta conta não existe."){
        ToastMensagem("esta conta nao existe.", context);
      }

    }).catchError((err){
      print("ERROR!!!"+err.toString());
      onErrorEmail(err.toString());
    }).whenComplete(() {
      onCompleteEmail();
    });


  }
  onSucessEmail(){

    Navigator.push(context, MaterialPageRoute(
        builder:(context)=>SplashScreen()));
  }
  onErrorEmail(String erro){
    print("Erro::"+erro);
  }
  onCompleteEmail(){

    setState(() {
      busy=false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      key:scaffoldkey,
      body:SingleChildScrollView(
        child: Container(
          padding:EdgeInsets.only(
            top: 80,
            left:20,
            right:20,
            bottom: 40,
          ),
          child: Form(
            key: _formKey,
            child: Card(
              child: Column(
                children:<Widget> [

                  SizedBox(
                      width: double.infinity
                  ),
                  Image.asset("imagens/fogacasemnome.png",
                    width:180,
                    height: 120,
                  ),
                  Text(
                      "Fogaça Motoboys",
                      style: TextStyle(
                        fontSize:20,
                        color: Colors.red[900],
                        fontWeight:FontWeight.w800 ,
                        fontFamily: "Brand Bold",)
                  ) ,
                  SizedBox(height:20),
                  CPTextFormField(
                    // autofocus: true,
                    type: TextInputType.emailAddress,
                    obscureText: false,
                    maxlenght:35,
                    labeltext:"E-mail",

                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Digite um e-mail.';
                      }else if(!value.contains("@")){
                        return 'Digite um e-mail válido.';
                      }else if(value.contains(" ")){
                        return '*erro: e-mail contém espaço.';
                      }
                      return null;
                    },
                    onSaved: (input) => _email = input,
                  ),

                  SizedBox(height:5),
                  CPTextFormField(
                    type: TextInputType.visiblePassword,
                    textCapitalization: TextCapitalization.none,
                    obscureText: true,
                    labeltext:"Senha",

                    validator: (value) {
                      if (value.isEmpty) {
                        return "Digite uma senha." ;
                      }else if(value.length<=5){
                        return 'Senha no mínimo 6 digitos';
                      }
                      return null;
                    },
                    onSaved: (input) => _senha = input,
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child:CPButtonText(
                      text:"Esqueceu a senha?",
                      callback:(){
                        Navigator.push(context,MaterialPageRoute(
                            builder:(context)=>Tela_RedefinirSenha()
                        ),
                        );
                      },
                    ),
                  ),

                  WIBusy(
                    busy: busy,
                    child: CPButton(text: "Login",
                      width: double.infinity,
                      callback: (){

                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          SignInEmail();
                        }
                      },
                    ),
                  ),

                  SizedBox(height:10),


                  SizedBox(height:10),
                  Row(
                      crossAxisAlignment:CrossAxisAlignment.center,
                      mainAxisAlignment:MainAxisAlignment.center,
                      children: [
                        Text(
                            "Não tem conta?",
                            style:TextStyle(
                                fontWeight: FontWeight.w100,
                                color:Colors.black54
                            )
                        ) ,
                        CPButtonText(
                          text: "CADASTRE-SE",
                          callback:(){
                            Navigator.push(context,MaterialPageRoute(
                                builder:(context)=>Tela_Cadastro()
                            ),
                            );
                          },
                        )
                      ]
                  ),
                  SizedBox(height:10),
                ],
              ),
            ),
          ),
        ),
      ),

    );

  }
}
