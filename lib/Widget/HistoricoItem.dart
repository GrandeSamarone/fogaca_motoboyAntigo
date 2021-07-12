import 'package:flutter/material.dart';
import 'package:fogaca_app/Model/Historico.dart';

class HistoricoItem extends StatelessWidget
{
  Map<String, dynamic> historico = Map();
  HistoricoItem({this.historico});
  String url="https://firebasestorage.googleapis.com/v0/b/fogaca-app.appspot.com/o/perfil%2Fshop.png?alt=media&token=4822582a-a264-4638-8c2a-2bd1341be58c";

  @override
  Widget build(BuildContext context)

  {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: <Widget>[
            ListTile( title: Text(historico["nome_ponto"]),
                subtitle: Text(historico["end_ponto"]+"\n"+historico["data"]),

                leading: ClipOval(
                  child:Image.network(
                    historico["icon_loja"]!=""?
                    historico["icon_loja"]:url,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                trailing: Icon(Icons.update)),
          ],
        ),
      ),
    );
  }
}
