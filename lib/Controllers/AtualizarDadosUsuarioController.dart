
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fogaca_app/Store/StoreDadosUsuario.dart';
import 'package:fogaca_app/TabsPage/ProfileTabPage.dart';
import 'package:fogaca_app/Widget/WIToast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';



abstract class AtualizarDadosController extends State<ProfileTabPage>  with AutomaticKeepAliveClientMixin{

  String ?idUsuarioLogado;
  var scaffold = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  late Size size;
  var isReset;
  var busy=false;
  var nomeController = TextEditingController();
  var telefoneController = TextEditingController();
  var emailController = TextEditingController();
  var controllerDadosUsuario;
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
  final _picker = ImagePicker();
  var _imagemSelecionada;
  File ?_imagem;
  var _db= FirebaseFirestore.instance.collection("user_clientes");
  ReactionDisposer ?reactionDisposer;


  void didChangeDependencies(){
    super .didChangeDependencies();

  //  controllerDadosUsuario=Provider.of<StoreDadosUsuario>(context);
    controllerDadosUsuario!.DadosLojista();
    reactionDisposer= reaction((_)=>controllerDadosUsuario!.codcity,
            (valor){
          print("codigocidade::${valor}");
        });
  }

  recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = await auth.currentUser;
    idUsuarioLogado = usuarioLogado!.uid;

    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot snapshot = await db.collection("user_clientes")
        .doc(idUsuarioLogado)
        .get();

    Map<String, dynamic> dados = snapshot.data()as Map<String,dynamic>;

    setState(() {
      nomeController.text = dados["nome"];
      telefoneController.text = dados["telefone"];
      dropdownValue=dados["cidade"];
    });

  }



  Future<String> pickerImage() async {
    setState(() {
      busy=true;
    });
    try{

      _imagemSelecionada = (await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality:100,
          maxWidth:400));


      if (_imagemSelecionada != null) {
        _imagem = File(_imagemSelecionada.path);

        FirebaseStorage storage = FirebaseStorage.instance;
        Reference pastaRaiz = storage.ref();
        Reference arquivo = pastaRaiz
            .child("perfil")
            .child(controllerDadosUsuario.id + ".jpg");

        //Upload da imagem
        UploadTask task = arquivo.putFile(_imagem!);

        task.snapshotEvents.listen((TaskSnapshot storageEvent) {
          if (storageEvent.state == TaskState.running) {

            print("resultado:: Carregando...");
            // return "resultado:: Carregando...";
          } else if (storageEvent.state == TaskState.success) {

            print("resultado:: Sucesso...");

            // return "resultado:: Sucesso";
          }
        });

        //Recuperar URL da imagem
        task.then((TaskSnapshot taskSnapshot)async {
          String url = await taskSnapshot.ref.getDownloadURL();
          Map<String, dynamic> dadosAtualizar = {
            "icon_foto" : url
          };

          _db.doc(controllerDadosUsuario.id).update( dadosAtualizar );

          setState(() {
            busy=false;
          });
          return "Carregada com sucesso!";
        });
      } else {
        return "resultado::Imagem nao selecionada";
      }


    }catch(erro){
      return erro.toString();
    }
    return "sss";
  }

  Future AlterarDados()async {
    setState(() {
      busy=true;
    });
    switch (dropdownValue) {
      case "Ji-Paraná":
        Map<String, dynamic> Jipa = {
          "cidade": dropdownValue,
          "cod": "jipa",
          "nome":nomeController.text,
          "telefone":telefoneController.text
        };
        _db.doc(controllerDadosUsuario.id).update(Jipa);
        ToastMensagem("Atualizado com sucesso!", context);

        setState(() {
          busy=false;
        });
        return ;

      case "Jaru":
        Map<String, dynamic> Jaru = {
          "cidade": dropdownValue,
          "cod": "jaru",
          "nome":nomeController.text,
          "telefone":telefoneController.text
        };
        _db.doc(controllerDadosUsuario.id).update(Jaru);

        ToastMensagem("Atualizado com sucesso!", context);
        setState(() {
          busy=false;
        });
        return ;

      case "Ouro Preto":
        Map<String, dynamic> ouropreto = {
          "cidade": dropdownValue,
          "cod": "ouropreto",
          "nome":nomeController.text,
          "telefone":telefoneController.text
        };
        _db.doc(controllerDadosUsuario.id).update(ouropreto);

        ToastMensagem("Atualizado com sucesso!", context);
        setState(() {
          busy=false;
        });
        return ;

      case "Ariquemes":
        Map<String, dynamic> ariquemes = {
          "cidade": dropdownValue,
          "cod": "ariquemes",
          "nome":nomeController.text,
          "telefone":telefoneController.text
        };
        _db.doc(controllerDadosUsuario.id).update(ariquemes);

        ToastMensagem("Atualizado com sucesso!", context);
        setState(() {
          busy=false;
        });
        return ;

      case "Cacoal":
        Map<String, dynamic> cacoal = {
          "cidade": dropdownValue,
          "cod": "cacoal",
          "nome":nomeController.text,
          "telefone":telefoneController.text
        };
        _db.doc(controllerDadosUsuario.id).update(cacoal);

        ToastMensagem("Atualizado com sucesso!", context);
        setState(() {
          busy=false;
        });
        return ;

      case "Médici":
        Map<String, dynamic> medici = {
          "cidade": dropdownValue,
          "cod": "medici",
          "nome":nomeController.text,
          "telefone":telefoneController.text
        };
        _db.doc(controllerDadosUsuario.id).update(medici);

        ToastMensagem("Atualizado com sucesso!", context);
        setState(() {
          busy=false;
        });
        return ;

    }

  }



}