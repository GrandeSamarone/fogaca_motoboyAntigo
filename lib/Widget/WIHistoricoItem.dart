import 'package:flutter/material.dart';

import 'WIToast.dart';

class WIHistoricoItem extends StatelessWidget {
  Map<String, dynamic> pedido =new  Map();
  WIHistoricoItem({
    required this.pedido
  });

  bool finalizado=false;
  String url="https://firebasestorage.googleapis.com/v0/b/fogaca-app.appspot.com/o/perfil%2Fcapacete.jpg?alt=media&token=55172947-3db3-4edd-9daa-93ceee0abd91";
  Color? ColorButton=Colors.grey[700];
  @override
  Widget build(BuildContext context) {
    if(pedido["situacao"]=="Pedido Finalizado"){
      ColorButton=Colors.redAccent[700];
    }else if(pedido["situacao"]=="Corrida Aceita"){
      ColorButton=Colors.greenAccent[700];
    }else{
      ColorButton=Colors.yellow[700];
    }

    return Card(
      color:  Color(0xFF4B4545),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Container(
                width: 80,
                child:  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    onBackgroundImageError: (exception, stackTrace){},
                    backgroundImage: pedido["boy_foto"] != ""
                        ? NetworkImage(pedido["boy_foto"])
                        : NetworkImage(url)

                ),
                decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    border: new Border.all(
                      color: Colors.black26,
                      width: 3.0,
                    ),
                    boxShadow:[
                      new BoxShadow(
                          color:Colors.black12,
                          offset:new Offset(1, 2.0),
                          blurRadius: 5,
                          spreadRadius: 2
                      )
                    ]
                ),
              ),
              title:  new Text(pedido["situacao"],
                  style: new TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      color: ColorButton)
              ),
              subtitle: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      pedido["boy_nome"],
                      style: new TextStyle(
                          fontSize: 14.0,
                          fontFamily: "Brand Bold",
                          color: Colors.white70),
                    ),

                    new Text(pedido["boy_moto_modelo"]+","+pedido["boy_moto_cor"]+","+pedido["boy_moto_placa"],
                        style: new TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.white70
                        )
                    ),
                    new Text('Quantidade: ${pedido["quant_itens"]}',
                        style: new TextStyle(
                            fontSize: 11.0,
                            fontFamily: "Brand-Regular",
                            color: Colors.white70)
                    ),
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
