import 'package:flutter/material.dart';

import 'WIToast.dart';

class WIHistoricoItem extends StatelessWidget
{
  Map<String, dynamic> pedido = Map();
  WIHistoricoItem({this.pedido});
  bool finalizado;
  String url="https://firebasestorage.googleapis.com/v0/b/fogaca-app.appspot.com/o/perfil%2Fcapacete.jpg?alt=media&token=55172947-3db3-4edd-9daa-93ceee0abd91";
  Color ColorButton=Colors.grey[700];
  @override
  Widget build(BuildContext context) {
    if(pedido["situacao"]=="Pedido Finalizado"){

      ColorButton=Colors.greenAccent[700];
    }else if(pedido["situacao"]=="Cancelado"){
      ColorButton=Colors.redAccent[700];
    }else{
      ColorButton=Colors.yellow[700];
    }

    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: <Widget>[
            ListTile(
              leading:  ClipOval(
                child:Image.network(
                  pedido["boy_foto"]!=""?
                  pedido["boy_foto"]:url,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,),),

              title: new Text(
                pedido["boy_nome"],
                style: new TextStyle(fontSize: 14.0),
              ),
              subtitle: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(pedido["situacao"],
                        style: new TextStyle(
                            fontSize: 13.0,
                            color: ColorButton)),
                    new Text(pedido["boy_moto_modelo"]+","+pedido["boy_moto_cor"]+","+pedido["boy_moto_placa"],
                        style: new TextStyle(
                            fontSize: 13.0)),
                    new Text('Endereço: ${pedido["end_ponto"]}',
                        style: new TextStyle(
                            fontSize: 11.0)),
                  ]),
              //trailing: ,
              onTap: () {


              },
            )

          ],
        ),
      ),
    );
  }
}
