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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor:  Color(0xFFFDFDFD),
        body: Stack(
         children:[
           LayoutBuilder(
             builder: (BuildContext context, BoxConstraints constraints) {
               return Container(
                 height: constraints.maxHeight / 1,

                 padding: EdgeInsets.only(
                   top: 80,
                   left: 20,
                   right: 20,
                   bottom: 40,
                 ),
                 child: Column(
                   children: <Widget>[
                     Container(
                       height: 480,
                       decoration: BoxDecoration(
                         color:Color(0xFFFDFDFD),
                         boxShadow: [
                           new BoxShadow(
                             color: Colors.black12,
                             offset: new Offset(1, 2.0),
                             blurRadius: 5,
                             spreadRadius: 1,
                           ),
                         ],
                       ),
                       child: Padding(
                         padding: EdgeInsets.only(
                           left: 20,
                           right: 20,
                           top: 20,
                         ),
                         child: Form(
                           key: _formKey,
                           child: Column(
                             children: <Widget>[
                               Image.asset("imagens/fogacasemnome.png",
                                 width:180,
                                 height: 120,
                               ),
                               SizedBox(
                                 height:20,
                               ),
                               CPTextFormField(
                                 textCapitalization: TextCapitalization.none,
                                 type: TextInputType.emailAddress,
                                 obscureText: false,
                                 labeltext:"E-mail do Usuário",

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

                               SizedBox(height:10),
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
                               SizedBox(height:10),
                               WIBusy(
                                 busy: busy,
                                 child: CPButton(text: "Entrar",
                                   width: double.infinity,
                                   callback: (){

                                     if (_formKey.currentState.validate()) {
                                       _formKey.currentState.save();

                                     }
                                   },
                                 ),
                               ),
                               Row(
                                   crossAxisAlignment:CrossAxisAlignment.center,
                                   mainAxisAlignment:MainAxisAlignment.center,
                                   children: [

                                     Text(
                                         "Não possui uma conta?",
                                         style:TextStyle(
                                           fontFamily:"Brand-Regular",
                                           fontWeight: FontWeight.w100,
                                         )
                                     ) ,
                                     CPButtonText(
                                       text: "Cadastre-se",

                                       callback:(){
                                         Navigator.push(context,MaterialPageRoute(
                                             builder:(context)=>Tela_Cadastro()
                                         ),
                                         );
                                       },

                                     )
                                   ]
                               ),
                             ],
                           ),
                         ),
                       ),
                     ),

                   ],
                 ),

               );
             },
           ),
           Positioned(
             left: 0.0,
             right: 0.0,
             top: 0.0,
             child: Image.asset(
               "imagens/Vector_top.png",
             ),
           ),
          Positioned(
          left: 0.0,
          right: 0.0,
          bottom: 0.0,
          child: Image.asset(
          "imagens/Vector_bottom.png",
          ),
          )
         ],

        ),

    );
  }
}




