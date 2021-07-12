
import 'package:flutter/Material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fogaca_app/Components/CPButtonVermelho.comp.dart';
import 'package:fogaca_app/Widget/WIBusy.dart';

import 'Tela_Login.dart';

class Tela_SucessoSenha extends StatefulWidget{

  @override
  _Tela_SucessoSenhaState createState() => _Tela_SucessoSenhaState();
}

class _Tela_SucessoSenhaState extends State<Tela_SucessoSenha> {

  var busy=false;
  TextEditingController email_Controller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Colors.red[900]),
          onPressed: () => Navigator.pushNamedAndRemoveUntil(context, Tela_Login.idScreen, (route) => false),
        ),
        backgroundColor:Colors.white.withOpacity(0),
        elevation: 0,
      ),
      body:SingleChildScrollView(
        child: WIBusy(
          busy:busy,
          child: Container(
            padding:EdgeInsets.only(
              top: 40,
              left:20,
              right:20,
              bottom: 40,
            ),
            child: Card(
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
      );

  }
}