import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WIDialog extends StatefulWidget{

 String titulo;
 String msg;
 String txtButton;
 Function funcao;

  WIDialog({
    this.titulo,
    this.msg,
    this.funcao,
    this.txtButton
  });

  StreamSubscription<DocumentSnapshot> streamSub;
  static const String idScreen = "NotificacaoDialog";
  WIDialogState createState() =>WIDialogState();

}

class WIDialogState extends State<WIDialog> {


  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {




    // TODO: implement build
    return  Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(5.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme
              .of(context)
              .cardColor,
          borderRadius: BorderRadius.circular(5.0),

        ),
        padding: EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 22.0,),
            Text(
              widget.titulo,
              style: TextStyle(fontSize: 18.0, fontFamily: "Brand Bold"),
            ),

            Divider(height: 2.0, thickness: 2.0,),
            SizedBox(height: 6.0),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(width: 16.0,),
                  Text(widget.msg!=null?widget.msg:"", style: TextStyle(fontSize: 15.0),),
                ]),
            SizedBox(height: 16.0,),
            TextButton(
                onPressed: () {
                 widget.funcao();
                },
                child: Text(widget.txtButton)
            ),
          ],
        ),
      ),

    );
  }


}
