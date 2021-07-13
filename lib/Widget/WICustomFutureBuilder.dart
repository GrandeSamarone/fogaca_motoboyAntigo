import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'WIHistoricoCarregando.dart';
import 'WIPedidoItem.dart';

class WICustomFutureBuilder<T> extends StatelessWidget {

  String colletion;
 String estado;
 String msgvazio;
 String id_usuario;
  WICustomFutureBuilder({
    this.colletion,
   this.estado,
   this.msgvazio,
    this.id_usuario
});


  @override
  Widget build(BuildContext context) {

    Query users = FirebaseFirestore.instance.collection(colletion)
        .where('boy_id',isEqualTo:id_usuario)
        .where("estado",isEqualTo:estado);

    return StreamBuilder <QuerySnapshot>(
      stream: users.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('erro');
        }
        print("snapshot:::${snapshot.connectionState}");
        if (snapshot.connectionState == ConnectionState.waiting) {
          return WIHistoricoCarregando();

        }
        print("snapshot:::${snapshot.connectionState}");

        if (snapshot.connectionState == ConnectionState.active) {
          print("snapshot:::${snapshot.requireData.size}");
          if (snapshot.requireData.size>0) {
            return  ListView(
                children: <Widget>[
                  Column(
                    children: snapshot.data.docs.map((DocumentSnapshot document) {
                      return WIPedidoItem(pedido: document.data());
                    }).toList(),
                  )
                ]
            );
          } else {
               return Container(
                 width: double.infinity,
                   child:Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
                       Image.asset("imagens/desk-bell.png",
                       width: 50,
                       height: 50,),
                       Text(msgvazio,
                         style: TextStyle(fontSize:15,fontWeight: FontWeight.w400),)
                   ],
                   ),
               );
          }
        }
        return Container();
      },

    );
  }

  }