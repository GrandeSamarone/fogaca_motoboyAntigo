
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fogaca_app/Store/StoreDadosUsuario.dart';
import 'package:image_picker/image_picker.dart';

class AtualizarDadosUsuarioController{
  StoreDadosUsuario id=StoreDadosUsuario();
  final _picker = ImagePicker();
  var _imagemSelecionada;
  File _imagem;
 var _db= FirebaseFirestore.instance.collection("user_motoboy");

   Future<String> pickerImage(String id) async {
     try{
       _imagemSelecionada = (await _picker.getImage(
           source: ImageSource.gallery,
           imageQuality:100,
           maxWidth:400));


       if (_imagemSelecionada != null) {
         _imagem = File(_imagemSelecionada.path);

         FirebaseStorage storage = FirebaseStorage.instance;
         Reference pastaRaiz = storage.ref();
         Reference arquivo = pastaRaiz
             .child("perfil")
             .child(id + ".jpg");

         //Upload da imagem
         UploadTask task = arquivo.putFile(_imagem);

         task.snapshotEvents.listen((TaskSnapshot storageEvent) {
           if (storageEvent.state == TaskState.running) {

             print("resultado:: Carregando...");
             return"resultado:: Carregando...";
           } else if (storageEvent.state == TaskState.success) {

             print("resultado:: Sucesso...");
             return "resultado:: Sucesso";
           }
         });

         //Recuperar URL da imagem
         task.then((TaskSnapshot taskSnapshot)async {
           String url = await taskSnapshot.ref.getDownloadURL();
           Map<String, dynamic> dadosAtualizar = {
             "icon_foto" : url
           };

           _db.doc(id).update( dadosAtualizar );

           print("resultado:: com sucesso!...");
           return "Carregada com sucesso!";
         });
       } else {
         return "resultado::Imagem nao selecionada";
       }


     }catch(erro){
       return erro.toString();
     }

  }

  Future<String> AlterarDados(String text,String Dados,String id)async {
    print(text+" "+Dados);
    if(text=="Nome"){
      Map<String, dynamic> dadosAtualizarNome = {
        "nome" : Dados,
      };
      _db.doc(id).update(dadosAtualizarNome);

      return "Nome alterado com sucesso";
      
    }else if(text=="Telefone"){
      Map<String, dynamic> dadosAtualizarTelefone = {
        "telefone" : Dados,
      };
      _db.doc(id).update(dadosAtualizarTelefone);

      return "telefone alterado com sucesso!";

    }else if(text=="Cpf/Cnpj"){
      Map<String, dynamic> dadosAtualizarCpf_Cnpj = {
        "cpf_cnpj" : Dados,
      };
      _db.doc(id).update(dadosAtualizarCpf_Cnpj);

      return "Cpf/Cnpj alterado com sucesso!";
    }
  }

    Future<String>AlterarCity(String city,id)async {
      switch (city) {
        case "Ji-Paraná":
          Map<String, dynamic> dadosAtualizarJipa = {
            "cidade": city,
            "cod": "jipa",
          };
          _db.doc(id).update(dadosAtualizarJipa);

          return "sua cidade de trabalho agora é ${city}.";

        case "Jaru":
          Map<String, dynamic> dadosAtualizarJipa = {
            "cidade": city,
            "cod": "jaru",
          };
          _db.doc(id).update(dadosAtualizarJipa);

          return "sua cidade de trabalho agora é ${city}.";

        case "Ouro Preto":
          Map<String, dynamic> dadosAtualizarJipa = {
            "cidade": city,
            "cod": "ouropreto",
          };
          _db.doc(id).update(dadosAtualizarJipa);

          return "sua cidade de trabalho agora é ${city}.";

        case "Ariquemes":
          Map<String, dynamic> dadosAtualizarJipa = {
            "cidade": city,
            "cod": "ariquemes",
          };
          _db.doc(id).update(dadosAtualizarJipa);

          return "sua cidade de trabalho agora é ${city}.";

          case "Cacoal":
          Map<String, dynamic> dadosAtualizarJipa = {
            "cidade": city,
            "cod": "cacoal",
          };
          _db.doc(id).update(dadosAtualizarJipa);

          return "sua cidade de trabalho agora é ${city}.";

          case "Médici":
          Map<String, dynamic> dadosAtualizarJipa = {
            "cidade": city,
            "cod": "medici",
          };
          _db.doc(id).update(dadosAtualizarJipa);

          return "sua cidade de trabalho agora é ${city}.";

      }
    }

}