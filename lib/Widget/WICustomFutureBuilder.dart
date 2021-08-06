import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

import 'WIHistoricoCarregando.dart';
import 'WIPedidoItem.dart';

class WICustomFutureBuilder<T> extends StatelessWidget {

  var colletion;
  var estado;
  var msgvazio;
  WICustomFutureBuilder({
    this.colletion,
   this.estado,
   this.msgvazio
});


  @override
  Widget build(BuildContext context) {

    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = auth.currentUser;
    Query users = FirebaseFirestore.instance.collection(colletion)
        .where('id_usuario',isEqualTo:usuarioLogado!.uid)
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
            return PaginateFirestore(
                itemBuilderType: PaginateBuilderType.listView,
                itemBuilder: (index, context, documentSnapshot)
                {
                  return WIPedidoItem(pedido: snapshot.data!.docs[index].data()as Map<String,dynamic>);
                },
                query: users,
                isLive: true
            ) ;
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
                         style: TextStyle(fontSize:15,
                             fontWeight: FontWeight.w400,
                          color: Colors.white
                         ),
                       )
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