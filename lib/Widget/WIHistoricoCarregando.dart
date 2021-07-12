import 'package:flutter/material.dart';

class WIHistoricoCarregando extends StatelessWidget
{

  @override
  Widget build(BuildContext context)
  {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: <Widget>[
            ListTile( title: Text("Carregando.."),
                subtitle: Text("Carregando.."),

                leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey,),
                trailing: Icon(Icons.watch_later_outlined)),
             ],
        ),
      ),
    );
  }
}
