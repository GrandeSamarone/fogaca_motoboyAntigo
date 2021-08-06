import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fogaca_app/Model/Motoboy.dart';
import 'package:fogaca_app/Notificacao/PushNotificacao.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

class RatingTabPage extends StatefulWidget {


  @override
  _RatingTabPageState createState() => _RatingTabPageState();
}

class _RatingTabPageState extends State<RatingTabPage> with AutomaticKeepAliveClientMixin {

  PushNotificacao pushNotificacao= PushNotificacao();
  Motoboy motoboyLogado=Motoboy();
  String? estrela;
  double ?estrelaDouble;



  @override
  Widget build(BuildContext context) {
    final motoboy=Provider.of<List<Motoboy>>(context);
    if(motoboy!=null){
      motoboyLogado=motoboy[0];
      if(motoboyLogado.estrela!=null){
        estrelaDouble = double.parse(motoboyLogado.estrela);
      }
      num mod = pow(10.0, 2);
      estrela = ((estrelaDouble! * mod).round().toDouble() / mod).toString();
    }


    return Scaffold(
      body:Container(
        child:Column(
          children: [

            SizedBox(height: 200.0,),
         //  Center(child: Text(estrela!=null?estrela:"",style:new TextStyle(fontSize: 65.0),),),

        ]),

      ),


    );


  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
