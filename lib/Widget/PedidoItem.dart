import 'package:flutter/material.dart';
import 'package:fogaca_app/Model/Historico.dart';
import '../Pages_pedido/Tela_Passeio.dart';

import 'Toast.dart';

class PedidoItem extends StatelessWidget
{
  Map<String, dynamic> pedido = Map();
  PedidoItem({this.pedido});
  bool finalizado;
  String url="https://firebasestorage.googleapis.com/v0/b/fogaca-app.appspot.com/o/perfil%2Fshop.png?alt=media&token=4822582a-a264-4638-8c2a-2bd1341be58c";
  Color ColorButton=Colors.grey[700];
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
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: <Widget>[
            ListTile(
        leading:  ClipOval(
          child:Image.network(
          pedido["icon_loja"]!=""?
        pedido["icon_loja"]:url,
          width: 50,
          height: 50,
          fit: BoxFit.cover,),),

      title: new Text(
        pedido["nome_ponto"],
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
            new Text(pedido["end_ponto"],
                style: new TextStyle(
                    fontSize: 13.0)),
            new Text('Quantidade: ${pedido["quant_itens"]}',
                style: new TextStyle(
                    fontSize: 11.0)),
          ]),
      //trailing: ,
      onTap: () {
       if(pedido["situacao"]=="Pedido Finalizado"){
          ToastMensagem("Pedido já finalizado.", context);
        }else{
         Navigator.push(
             context,
             MaterialPageRoute(
                 builder: (context) => Tela_Passeio(detalheCorrida:pedido)));
        }

      },
    )

             ],
        ),
      ),
    );
  }
}
