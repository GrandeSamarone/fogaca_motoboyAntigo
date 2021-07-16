import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fogaca_app/Controllers/AtualizarDadosUsuarioController.dart';
import 'package:fogaca_app/Controllers/LoginController.dart';
import 'package:fogaca_app/Pages_user/Tela_Login.dart';
import 'package:fogaca_app/Store/StoreDadosUsuario.dart';
import 'package:fogaca_app/Widget/Toast.dart';

import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Page/Mapa_Home.dart';

class ProfileTabPage extends StatefulWidget {

  ProfileTabPageState createState() => ProfileTabPageState();

}

class ProfileTabPageState extends State<ProfileTabPage> with AutomaticKeepAliveClientMixin {

  final controller = new AtualizarDadosUsuarioController();
  final controllerUser=LoginController();
  String _idUsuarioLogado;
  String dropdownValue = 'Selecione uma cidade';
  List <String> spinnerItems = [
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
    final store=Provider.of<StoreDadosUsuario>(context);
    _idUsuarioLogado=store.id;
    dropdownValue=store.city;

    return
     Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.only(
              left: 10,
               right:10,
               bottom: 10,
               top:30
          ),
          child: Container(
            child: Column(
              children: <Widget>[
                Observer(builder: (_){
                  return
                    CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.grey,
                        backgroundImage: store.foto != null
                            ? NetworkImage(store.foto)
                            : null

                    );
                },),

                TextButton.icon(
                  icon: Icon(Icons.image, color: Colors.redAccent),
                  label: Text(
                    'Adicionar imagem',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                  onPressed:(){
                    EnviarImagem(_idUsuarioLogado);
                    // controller.pickerImage();
                  },
                ),


                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Nome:",
                      style: TextStyle(color: Theme.of(context).textTheme.subtitle1.color, fontSize: 11,fontFamily:  "Brand Bold"),),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Observer(builder: (_){
                      return
                        Text(
                          store.nome!=null?store.nome:"",
                          style: TextStyle(fontSize: 16.0),
                          textAlign: TextAlign.center,
                        );
                    },),
                    TextButton.icon(
                      icon: Icon(Icons.edit, color: Colors.redAccent),
                      label: Text(
                        '',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                      onPressed: (){
                        DialogOpcao("Nome",store.nome,TextInputType.text);
                      },
                    )
                  ],
                ),
                Divider(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text("Email:",
                      style: TextStyle(color: Theme.of(context).textTheme.subtitle1.color, fontSize: 11,fontFamily:  "Brand Bold"),),

                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      store.email!=null?store.email:"",
                      style: TextStyle(fontSize: 16.0,color: Colors.grey),
                    ),

                  ],
                ),
                Divider(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text("Cpf/Cnpj:",
                      style: TextStyle(color: Theme.of(context).textTheme.subtitle1.color, fontSize: 11,fontFamily:  "Brand Bold"),),

                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      store.cpf_cnpj!=null?store.cpf_cnpj:"",
                      style: TextStyle(fontSize: 16.0,color: Colors.grey),
                    ),

                  ],
                ),

                Divider(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text("Telefone:",
                      style: TextStyle(color: Theme.of(context).textTheme.subtitle1.color, fontSize: 11,fontFamily:  "Brand Bold"),),

                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Observer(builder: (_){
                      return
                        Text(
                          store.telefone!=null?store.telefone:"",
                          style: TextStyle(fontSize: 16.0),
                        );
                    },),
                    TextButton.icon(
                      icon: Icon(Icons.edit, color: Colors.redAccent),
                      label: Text(
                        '',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                      onPressed: (){
                        DialogOpcao("Telefone",store.telefone,TextInputType.number);
                      },
                    )
                  ],
                ),
                Divider(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text("Local de trabalho",
                      style: TextStyle(color: Theme.of(context).textTheme.subtitle1.color, fontSize: 11,fontFamily:  "Brand Bold"),),

                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Observer(builder: (_){
                      return
                        Text(
                          store.city!=null?store.city:"",
                          style: TextStyle(fontSize: 16.0),
                        );
                    },),

                    TextButton.icon(
                      icon: Icon(Icons.edit, color: Colors.redAccent),
                      label: Text(
                        '',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                      onPressed: (){
                        dialogCity(context);
                      },
                    ),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Observer(builder: (_){
                      return
                        Text(
                          "Sair",
                          style: TextStyle(fontSize: 16.0),
                        );
                    },),
                    TextButton.icon(
                      icon: Icon(Icons.exit_to_app, color: Colors.redAccent),
                      label: Text(
                        '',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                      onPressed: (){
                        NAlertDialog(
                            dialogStyle: DialogStyle(titleDivider: true,backgroundColor:Theme.of(context).dialogBackgroundColor ),
                            title: Text("Deseja realmente sair?"),
                            content: Text(
                                "Você será redirecionado para a tela de login."),
                            actions: <Widget>[

                              TextButton(child: Text("NÃO",style:
                              TextStyle(  color: Theme.of(context).textTheme.headline4.color,),)
                                  , onPressed: () {
                                    Navigator.pop(context);
                                  }),
                              TextButton(child: Text("SIM",style:
                              TextStyle(  color: Theme.of(context).textTheme.headline4.color,),)
                                  , onPressed: ()async{
                                    store.FecharDados();
                                    controllerUser.Logout();
                                    await FirebaseFirestore.instance.terminate();
                                    //  await FirebaseFirestore.instance.clearPersistence();
                                    Navigator.pushNamedAndRemoveUntil(
                                        context, Tela_Login.idScreen, (
                                        route) => false);
                                  }),
                            ]
                        ).show(context);
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
    );

  }

  void DialogOpcao(String text,String dados,TextInputType type){
    String dadosAlterado;
    showDialog(
        context: context,
        builder: (_){
          return  AlertDialog(
            title: Text("Alterar ${text}"),
            content: TextField(
              keyboardType:type,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: dados
              ),
              onChanged:(String valor){
                dadosAlterado=valor;
              },
            ),
            actions: [
              TextButton(
                  onPressed: ()
                  {
                    Navigator.pop(context);
                  },
                  child: Text("Cancelar", style: TextStyle(
                      color: Colors.red
                  ),)
              ),
              TextButton(
                  onPressed: (){
                    AlterarDados(text,dadosAlterado,_idUsuarioLogado);
                    Navigator.pop(context);
                  },
                  child: Text("Salvar")
              )
            ],
          );
        }
    );
  }

  void dialogCity(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return AlertDialog(
                  title: Text("Deseja realmente alterar?"),
                  actions: <Widget>[
                    Container(
                      width: double.infinity,
                      child: Column(
                        children: <Widget>[
                          DropdownButton<String>(
                            isExpanded: true,
                            value: dropdownValue,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Theme.of(context).textTheme.headline4.color, fontSize: 18,fontFamily:  "Brand-Bold"),
                            underline: Container(
                              height: 2,
                              color: Theme.of(context).textTheme.headline4.color,
                            ),
                            onChanged: (String data) {
                              setState(() {
                                dropdownValue=data;
                              });
                            },
                            items: spinnerItems.map<DropdownMenuItem<String>>((String value) {
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                  onPressed: (){
                                    Navigator.pop(context);
                                  },
                                  child: Text("Cancelar")
                              ),
                              TextButton(
                                  onPressed: (){
                                    // AlterarCidade(dropdownValue);
                                    Alterarcity(dropdownValue,_idUsuarioLogado);

                                    Navigator.pop(context);
                                  },
                                  child: Text("Salvar")
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                );
              });
        });

  }

  //Açao do botao EnviarImagem
  EnviarImagem(String id){
    setState(() {
    });

    controller.pickerImage(id).then((data) {

      print("Retorno!!!"+data.toString());

      ToastMensagem("Carregando...", context);
    }).catchError((err){
      print("ERROR!!!"+err.toString());
    }).whenComplete(() {
    });
  }



  //Açao do dialog alterardados
  AlterarDados(String text,String dadosalterado,String id){
    controller.AlterarDados(text,dadosalterado,id).then((data) {

      print("Retorno!!!"+data.toString());

      ToastMensagem(data.toString(),context);
    }).catchError((err){
      print("ERRO:!!!"+err.toString());
      ToastMensagem("Erro:${err.toString()}", context);
    }).whenComplete(() {
    });
  }

  //Açao do botao Alterar cidade
  Alterarcity(String text,String id){

    controller.AlterarCity(text,id).then((data) {

      print("Retorno!!!"+data.toString());

      ToastMensagem(data.toString(),context);
    }).catchError((err){
      print("ERROR!!!"+err.toString());
      ToastMensagem("Erro:${err.toString()}", context);
    }).whenComplete(() {
    });
  }


  void _moveToSignInScreen(BuildContext context) =>
      //Navigator.pushNamedAndRemoveUntil(context, Mapa_Home.idScreen, (route) => false);
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Mapa_Home()));
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;


}


