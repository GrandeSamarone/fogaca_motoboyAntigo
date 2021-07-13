import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fogaca_app/Model/Motoboy.dart';
import 'package:fogaca_app/Notificacao/PushNotificacao.dart';
import 'package:fogaca_app/Store/StoreDadosUsuario.dart';
import 'package:fogaca_app/Widget/Toast.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';


class RatingTabPage extends StatefulWidget {

  double estrelaDouble =5.0;
  String estrelaString;

  RatingTabPage({
    @required this.estrelaDouble,
    @required this.estrelaString,
  });
  @override
  _RatingTabPageState createState() => _RatingTabPageState();
}

class _RatingTabPageState extends State<RatingTabPage> with AutomaticKeepAliveClientMixin {

  PushNotificacao pushNotificacao= PushNotificacao();
  Motoboy motoboyLogado=Motoboy();
   //String estrela;
   //double estrelaDouble;



  @override
  Widget build(BuildContext context) {

    print("ESTRELA::${widget.estrelaString}");
    print("ESTRELA::${widget.estrelaDouble.toString()}");


    return Scaffold(
      body:Container(
        child:Column(
          children: [

            SizedBox(height: 200.0,),
           Center(
            child: Text(widget.estrelaString!=null?widget.estrelaString:"",style:new TextStyle(fontSize: 65.0),),

          ),
            SmoothStarRating(
              rating:widget.estrelaDouble!=null?widget.estrelaDouble:5.0,
              borderColor: Colors.red[800],
              color: Colors.red[800],
              isReadOnly: true,
              allowHalfRating: false,
              starCount: 5,
              size: 50,
              onRated: (value)
              {
              },
            ),
        ]),

      ),


    );


  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
