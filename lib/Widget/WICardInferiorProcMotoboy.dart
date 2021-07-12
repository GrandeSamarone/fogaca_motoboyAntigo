
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';

import 'WIToast.dart';

class WICardInferiorProcMotoboy extends StatefulWidget{

  final String TextNome;
  final double Height;
  final String TextButton;
  final Function() callback;
  final IconData icon;

  WICardInferiorProcMotoboy({
    this.TextNome,
    this.Height,
    this.TextButton,
    this.callback,
    this.icon

  });

  @override
  _WICardInferiorProcMotoboyState createState() => _WICardInferiorProcMotoboyState();
}

class _WICardInferiorProcMotoboyState extends State<WICardInferiorProcMotoboy>  with TickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {

    return  Positioned(
      bottom: 0.0,
      left: 0.0,
      right: 0.0,
      child: AnimatedSize(
        vsync:this,
        curve:Curves.bounceIn,
        duration:new Duration(milliseconds: 160),
        child: Container(
          decoration: BoxDecoration(
              borderRadius:
              BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight:Radius.circular(16.0),),
              color: Theme
                  .of(context)
                  .cardColor,
              boxShadow: [
                BoxShadow(
                  spreadRadius:0.5,
                  blurRadius: 16.0,
                  color: Theme
                      .of(context)
                      .textTheme.bodyText2.color,
                  offset:Offset(0.7,0.7),

                )
              ]
          ),
          height:widget.Height,
          child:Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(height: 12.0,),
                Text(
                 widget.TextNome,
                  style: TextStyle(
                    fontSize: 40.0,
                    fontFamily: "Signatra",
                    color:  Colors.red[800],
                  ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 22.0,),

                GestureDetector(
                  onTap:  widget.callback,
                  child: Container(
                    height: 60.0,
                    width: 60.0,
                    decoration: BoxDecoration(
                      color: Theme
                          .of(context)
                          .cardColor,
                      borderRadius: BorderRadius.circular(26.0),
                      border:Border.all(
                        width:2.0,
                        color: Theme
                            .of(context)
                            .textTheme.bodyText2.color,),
                    ),
                    child: Icon(Icons.close,size:26,),
                  ),
                ),
                SizedBox(height: 10.0,),
                Container(
                  width:100,
                  child:Text("Cancelar Pedido.",textAlign:TextAlign.center,style:TextStyle(fontSize:12.0),),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}

