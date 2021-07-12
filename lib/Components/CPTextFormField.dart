
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CPTextFormField extends StatefulWidget{

  final String labeltext;
  String Function() errotext;
  String Function(String) validator;
  String Function(String) onSaved;
  final bool obscureText;
  final TextCapitalization textCapitalization;
  Function(dynamic) changed;
  final int maxlenght;
  final TextInputType type;
  TextEditingController Controller = TextEditingController();
  CPTextFormField({
    this.labeltext,
    this.changed,
    this.maxlenght,
    this.textCapitalization,
    this.obscureText,
    this.errotext,
    this.type,
    this.Controller,
    this.validator,
    this.onSaved
  });

  @override
  _CPTextFieldState createState() => _CPTextFieldState();
}

class _CPTextFieldState extends State<CPTextFormField> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return
      TextFormField(
        textCapitalization: widget.textCapitalization,
        validator:widget.validator,
        obscureText: widget.obscureText,
        maxLength:widget.maxlenght,
        controller: widget.Controller,
        keyboardType: widget.type,
        onSaved:widget.onSaved,
        decoration: InputDecoration(
            labelText: widget.labeltext,
            labelStyle:TextStyle(
              fontWeight:FontWeight.w400,
              fontSize: 12,
            ),
            hintStyle: TextStyle(
              color: Theme
                  .of(context)
                  .textTheme
                  .subtitle1
                  .color,
              fontSize: 10.0,
            )
        ),
        style: TextStyle(fontSize: 14.0),
      );
  }
}