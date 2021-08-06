import 'package:flutter/material.dart';

class WIBusy extends StatelessWidget{
  bool busy =false;
  Widget child;

  WIBusy({
    @required this.busy,
    @required this.child,
  });
  @override
  Widget build(BuildContext context) {

    return busy
        ? Container(
      child:Center(
        child: CircularProgressIndicator(),
      ),
    ):child;

  }
}