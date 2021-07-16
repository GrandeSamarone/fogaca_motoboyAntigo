import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fogaca_app/Components/CPButtonVermelho.comp.dart';
import 'package:fogaca_app/Components/CPTextField.dart';
import 'package:fogaca_app/Controllers/LoginController.dart';
import 'package:fogaca_app/Widget/Toast.dart';
import 'package:fogaca_app/Widget/WIBusy.dart';

import 'Tela_SucessoSenha.dart';

class Tela_RedefinirSenha extends StatefulWidget {
  @override
  _Tela_RedefinirSenhaState createState() => _Tela_RedefinirSenhaState();
}

class _Tela_RedefinirSenhaState extends State<Tela_RedefinirSenha> {
  var busy = false;
  final controllerLogin = new LoginController();
  TextEditingController email_Controller = TextEditingController();
  Redefinirsenha() {
    setState(() {
      busy = true;
    });
    controllerLogin
        .sendPasswordResetEmail(email_Controller.text)
        .then((dados_retornados) {
      onSucessGoogle();
    }).catchError((err) {
      onErrorGoogle(err.toString());
    }).whenComplete(() {
      onCompleteGoogle();
    });
  }

  onSucessGoogle() {
    setState(() {
      //ToastMensagem("Enviado com Sucesso!", context);
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Tela_SucessoSenha(),
      ),
    );
  }

  onErrorGoogle(String erro) {
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

  onCompleteGoogle() {
    setState(() {
      busy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: Container(
            padding: EdgeInsets.only(
              top: 40,
              left: 20,
              right: 20,
              bottom: 40,
            ),
            child: Card(
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
                      fontWeight: FontWeight.w700,
                      fontSize: 18.0,
                      fontFamily: "Brand Bold",
                    ),
                  ),
                  SizedBox(height: 10),
                  CPTextField(
                    labeltext: "E-mail",
                    type: TextInputType.emailAddress,
                    Controller: email_Controller,
                  ),
                  SizedBox(height: 30),
                  CPButton(
                    text: "enviar",
                    width: double.infinity,
                    callback: () {
                      Redefinirsenha();
                    },
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
