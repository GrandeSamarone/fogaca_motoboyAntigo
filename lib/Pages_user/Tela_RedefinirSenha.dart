import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fogaca_app/Components/CPButtonVermelho.comp.dart';
import 'package:fogaca_app/Components/CPTextField.dart';
import 'package:fogaca_app/Components/CPTextFormField.dart';
import 'package:fogaca_app/Controllers/LoginController.dart';
import 'package:fogaca_app/Widget/Toast.dart';
import 'package:fogaca_app/Widget/WIBusy.dart';

import 'Tela_Login.dart';

class Tela_RedefinirSenha extends StatefulWidget {
  @override
  _Tela_RedefinirSenhaState createState() => _Tela_RedefinirSenhaState();
}

class _Tela_RedefinirSenhaState extends State<Tela_RedefinirSenha> {
  var busy = false;
  final controllerLogin = new LoginController();
  final _formKey = GlobalKey<FormState>();
  TextEditingController email_Controller = TextEditingController();

  var sucesso=false;
  Redefinirsenha() {
    setState(() {
      busy = true;
    });
    controllerLogin
        .sendPasswordResetEmail(email_Controller.text)
        .then((dados_retornados) {
      onSucessReset();
    }).catchError((err) {
      onErrorReset(err.toString());
    }).whenComplete(() {
      onCompleteReset;
    });
  }

  onSucessReset() {
    setState(() {
      sucesso=true;
    });

  }

  onErrorReset(String erro) {
    if (erro ==
        "[firebase_auth/too-many-requests] We have blocked all requests from this device due to unusual activity. Try again later.") {
      ToastMensagem(
          "Tentativas excedidas,tente novamente mais tarde.", context);
    } else if (erro ==
        "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.") {
      ToastMensagem("E-mail não encontrado.", context);
    }
    // ToastMensagem(err.toString(), context);
    print("Dados Retornados::" + erro);
  }

  onCompleteReset() {
    setState(() {
      busy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color(0xFFFDFDFD),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.red[900]),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white.withOpacity(0),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: WIBusy(
          busy: busy,
          child:sucesso==false? Container(
            padding: EdgeInsets.only(
              top: 40,
              left: 20,
              right: 20,
              bottom: 40,
            ),
            child: Card(
              color:  Color(0xFFFDFDFD),
              child: Form(
                key: _formKey,
                child: Column(

                  children: <Widget>[
                    Text("Alterar senha",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.red[900],
                          fontWeight: FontWeight.w800,
                          fontFamily: "Brand Bold",
                        )),
                    SizedBox(height: 5),
                    Text(
                      "insira o endereço de e-mail associado à sua conta, siga o link "
                      "no e-mail enviado a você para escolher uma nova senha.",
                      style: TextStyle(
                        color: Colors.black45,
                        fontWeight: FontWeight.w700,
                        fontSize: 16.0,
                        fontFamily: "Brand-Regular",
                      ),
                    ),
                    SizedBox(height: 10),
                    CPTextFormField(
                      Controller: email_Controller,
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
                    ),
                    SizedBox(height: 30),
                    CPButton(
                      text: "enviar",
                      width: double.infinity,
                      callback: () {
                      if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                        if(email_Controller.text.isNotEmpty){
                          Redefinirsenha();
                        }else{
                          ToastMensagem("Digite um e-mail.", context);
                        }
                      }
                      },
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ):Container(
            padding:EdgeInsets.only(
              top: 40,
              left:20,
              right:20,
              bottom: 40,
            ),
            child: Card(
              child: Padding(
                padding: EdgeInsets.only(
                    left: 5,
                    right: 5
                ),
                child: Column(
                  children:<Widget> [
                    Text(
                        "Enviado com sucesso!",
                        style: TextStyle(
                          fontSize:20,
                          color: Colors.red[900],
                          fontWeight:FontWeight.w800 ,
                          fontFamily: "Brand Bold",)
                    ) ,
                    SizedBox(height:5),
                    Text(
                      "voçê receberá um e-mail com link ,verifique sua caixa de mensagem.",
                      style: TextStyle(
                        color: Colors.black45,
                        fontWeight:FontWeight.w700 ,
                        fontSize: 18.0,
                        fontFamily: "Brand Bold",
                      ),
                    ),
                    SizedBox(height:30),
                    CPButton(text: "Fechar",
                      width: double.infinity,
                      callback: (){
                        Navigator.pushNamedAndRemoveUntil(context, Tela_Login.idScreen, (route) => false);
                      },
                    ),

                    SizedBox(height:10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
