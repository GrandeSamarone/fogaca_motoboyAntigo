import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fogaca_app/Model/Pedido.dart';
import 'package:grouped_list/grouped_list.dart';

import 'WIHistoricoCarregando.dart';
import 'WIPedidoItem.dart';

class WIListPorData<T> extends StatelessWidget {

  String colletion;
  String estado;
  String msgvazio;
  String id_usuario;
  WIListPorData({
    this.colletion,
    this.estado,
    this.msgvazio,
    this.id_usuario
  });
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List < Pedido > itemList = [];

  @override
  Widget build(BuildContext context) {

    Query users = FirebaseFirestore.instance.collection("Pedidos");

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
                      List<dynamic> data = document.data() as List<dynamic>;
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
