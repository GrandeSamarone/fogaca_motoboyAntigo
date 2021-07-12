

import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fogaca_app/Model/Motoboy.dart';
import 'package:fogaca_app/Model/Pedido.dart';
import '../Pages_pedido/Pedidos_em_Entrega.dart';
import '../Pages_pedido/Tela_Passeio.dart';
import 'package:fogaca_app/Providers/Firestore_Dados.dart';
import 'package:fogaca_app/Widget/Toast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class NotificacaoDialog extends StatefulWidget{

  final Pedido detalheCorrida;

  NotificacaoDialog({this.detalheCorrida});

  StreamSubscription<DocumentSnapshot> streamSub;
  static const String idScreen = "NotificacaoDialog";
  NotificacaoDialogState createState() =>NotificacaoDialogState();

}

class NotificacaoDialogState extends State<NotificacaoDialog> {

  final assetsAudioPlayer =AssetsAudioPlayer();
  Dados_usuario dados_usuario;
  bool cancelado=false;
  int quant;
  String _id,_nome,_telefone,_foto,_moto,_modelo,_cor,_placa,_token;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    assetsAudioPlayer.open(
        Audio("sons/somsino.mp3"),
        //autoStart: true,
        //showNotification: true,
        loopMode: LoopMode.single
    );
    print("ID DO DOC:::${widget.detalheCorrida.id_doc}");
  }
  /*showDialog(
  context: context,
  builder: (BuildContext builderContext) {
  _timer = Timer(Duration(seconds: 10), () {
  Navigator.of(context).pop();
  assetsAudioPlayer.stop();
  });

  }
  ).then((val){
  if (_timer.isActive) {
  _timer.cancel();

  }
  });*/
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    assetsAudioPlayer.stop();


  }
  @override
  Widget build(BuildContext context) {
    verificarEstado();
    dados_usuario=Provider.of<Dados_usuario>(context);
    final motoboy=Provider.of<List<Motoboy>>(context);
    if(motoboy!=null){
      quant=motoboy[0].n_pedidos;
      _id=motoboy[0].id;
      _nome=motoboy[0].nome;
      _telefone=motoboy[0].telefone;
      _foto=motoboy[0].icon_foto;
      _modelo=motoboy[0].modelo;
      _cor=motoboy[0].cor;
      _placa=motoboy[0].placa;
      _token=motoboy[0].token;

    }






    // TODO: implement build
    return Dialog(
      shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(12.0)),
      backgroundColor:Colors.transparent,
      elevation:1.0,
      child:Container(
        margin:EdgeInsets.all(5.0),
        width:double.infinity,
        decoration:BoxDecoration(
          color:Theme.of(context).dialogBackgroundColor,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child:Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 30.0),
            Image.asset("imagens/sino.png",width:100.0,),
            SizedBox(height: 18.0,),
            Text(widget.detalheCorrida.nome_ponto!=null?widget.detalheCorrida.nome_ponto:"",style:TextStyle(fontSize:20.0),),
            SizedBox(height: 30.0,),
            Padding(
              padding: EdgeInsets.all(18.0),
              child: Column(
                children: [

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("imagens/desticon.png",height:16.0,width: 16.0,),
                      SizedBox(width:20.0,),
                      Expanded(
                          child: Container(child: Text(widget.detalheCorrida.end_ponto!=null?
                          widget.detalheCorrida.end_ponto:"",style:TextStyle(fontSize:18.0),))
                      ),


                    ],
                  ),
                  SizedBox(height: 15.0,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("imagens/iconquantpedido.png",height:16.0,width: 16.0,),
                      SizedBox(width:20.0,),
                      Expanded(
                          child: Container(child: Text(widget.detalheCorrida.quant_itens!=null?
                          widget.detalheCorrida.quant_itens+" itens":"",style:TextStyle(fontSize:18.0),))
                      ),


                    ],
                  ),
                ],
              ),
            ),
            Divider(),
            Padding(
                padding: EdgeInsets.all(20.0),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: 200.0,
                        height: 50.0,
                        child:ElevatedButton.icon(
                            icon: Icon(FontAwesomeIcons.conciergeBell, color: Colors.white54,size:18.0,),
                            label:Text(cancelado?"Cancelado":'Aceitar'),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),

                              primary:Colors.red[900],
                              //  onPrimary: Colors.white,
                              onSurface: Colors.grey,
                              shape: const BeveledRectangleBorder
                                (borderRadius: BorderRadius.all(Radius.circular(5))),

                              textStyle: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 20,
                                  fontFamily: "Brand Bold"
                                  ,fontWeight: FontWeight.bold
                              ),
                            ),

                            onPressed: (){
                              ToastMensagem(" Pedido Aceito.", context);
                              dados_usuario.Atualizar_Pedido(motoboy,widget.detalheCorrida.id_doc,widget.detalheCorrida.quant_itens);

                              widget.streamSub.cancel();
                              assetsAudioPlayer.stop();
                              Navigator.of(context).pop();


                            })
                    ),
                  ],
                ))



          ],
        ),
      ),
    );


  }




  void verificarEstado(){
  /*  if(widget.detalheCorrida.id_doc!=null) {
      DocumentReference reference = FirebaseFirestore.instance.collection(
          'Pedidos').doc(widget.detalheCorrida.id_doc);
      widget.streamSub = reference.snapshots().listen((querySnapshot) {
        var corridaAtual = querySnapshot.data();
        print('Document data: ${querySnapshot.data()}');
        if (corridaAtual["situacao"]== "Cancelado") {
          ToastMensagem("Esse Pedido  já foi Cancelado.", context);
          assetsAudioPlayer.stop();
          widget.streamSub.cancel();
          Navigator.of(context).pop();

        }else if ((corridaAtual["boy_id"]!="")&&(corridaAtual["boy_id"]!=_id)){
          ToastMensagem("Esse Pedido  já foi Aceito.", context);
          assetsAudioPlayer.stop();
          widget.streamSub.cancel();
          Navigator.of(context).pop();
        }
      });
    }else{
      widget.streamSub.cancel();
    }
  }
*/
}
}
