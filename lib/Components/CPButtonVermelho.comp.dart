

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CPButton extends StatelessWidget{

  final String text;
  final String  imagem;
  final Function() callback;
  final double width;
  final double height;
  final IconData icon;
  CPButton({
    @required this.text,
    @required this.callback,
    this.imagem,
    this.width,
    this.height,
    this.icon,
  });
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return   Container(
      width:width!=null?width:300.0,
      height: height!=null?height:50.0,
      child:
      ElevatedButton.icon(
          icon: Icon(icon, color: Colors.white54,size:18.0,),
          label:Text(text),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),

            primary:Colors.red[900],
            //  onPrimary: Colors.white,
            onSurface: Colors.grey,
            shape: const BeveledRectangleBorder
              (borderRadius: BorderRadius.all(Radius.circular(5))),

            textStyle: TextStyle(
                color: Colors.white54,
                fontSize: 20,
                fontFamily: "Brand Bold"
                ,fontWeight: FontWeight.bold
            ),
          ),

          onPressed:callback
      ),

    );
          }





}