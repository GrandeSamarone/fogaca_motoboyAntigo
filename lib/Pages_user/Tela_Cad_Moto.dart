import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flux_validator_dart/flux_validator_dart.dart';
import 'package:fogaca_app/Controllers/CadastroController.dart';
import 'package:fogaca_app/Widget/WICarregando.dart';
import 'package:fogaca_app/Widget/WiAlerts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class Tela_Cad_Moto extends StatefulWidget{

  static const String idScreen = "cadastrofinal";
  Map dadosMap;

  Tela_Cad_Moto(this.dadosMap, {Key ?key}) : super(key: key);

  @override
  Tela_Cad_MotoState createState() => Tela_Cad_MotoState();
}

class Tela_Cad_MotoState  extends CadastroController {

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Stack(
        children: [
          Image.asset(
            "imagens/Vector_Cadastro.png",
          ),
          Scaffold(
              backgroundColor:  Color(0xFF403939),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(

                      padding:EdgeInsets.only(
                          top: 20,
                          left: 10),
                      width: MediaQuery.of(context).size.width,

                      alignment: Alignment.topLeft,
                      child:TextButton.icon(
                          onPressed:(){
                            Navigator.of(context).pop();
                          },
                          icon:  Icon(Icons.arrow_back,
                              color: Colors.white),
                          label:Text("")) ,
                    ),

                    Text("Estamos Quase lá...",
                      style:
                      TextStyle(
                          fontFamily:"Brand Bold",
                          fontSize: 25,
                          color: Colors.white
                      ),
                    ),

                    SizedBox(height: 20,),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height:MediaQuery.of(context).size.height ,
                        decoration:BoxDecoration(
                            borderRadius:
                            BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight:Radius.circular(30.0),),
                            color:Color(0xFF4B4343),
                            boxShadow:[
                              new BoxShadow(
                                  color:Colors.black45,
                                  offset:new Offset(1, 2.0),
                                  blurRadius: 5,
                                  spreadRadius: 1
                              )
                            ]
                        ),
                        padding: EdgeInsets.only(
                            left: 40,
                            right: 40,
                            bottom: 20,
                            top: 45),
                        child: Form(
                          key: formKey,
                          child: Column(
                              children: [
                                SizedBox(height: 1.0),
                                TextFormField(
                                  textCapitalization: TextCapitalization.characters,
                                  keyboardType: TextInputType.text,
                                  maxLength:15,
                                  obscureText: false,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return '**Digite um modelo de moto.';
                                    }else if(value.length<4){
                                      return '*mínimo 4 caracteres.';
                                    }
                                    return null;
                                  },
                                  onSaved: (input) => modelo = input,

                                  decoration: InputDecoration(
                                      labelText:"Modelo da moto",
                                      labelStyle:TextStyle(
                                        fontFamily: "Brand-Regular",
                                        color: const Color(0xFFCECACA),
                                        fontWeight:FontWeight.w400,
                                        fontSize: 12,
                                      ),
                                      counterStyle: TextStyle(
                                        color: const Color(0xFFCECACA),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color:const Color(0x8dc83535),
                                            width:2
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(

                                            color:const Color(0x8dc83535),
                                            width:2
                                        ),
                                      ),
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color:const Color(0x8dc83535),
                                            width:2
                                        ),
                                      ),
                                      hintStyle: TextStyle(
                                        color: const Color(0xFFB6B2B2),
                                        fontSize: 10.0,
                                      )
                                  ),
                                  style: TextStyle(
                                    color: const Color(0xffFDFDFD),
                                    fontSize: 14.0,
                                    fontFamily: "Brand-Regular",),

                                ),
                                SizedBox(height: 1.0,),
                                TextFormField(
                                  textCapitalization: TextCapitalization.characters,
                                  keyboardType: TextInputType.text,
                                  maxLength:7,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "*Digite a placa." ;
                                    }else if(Validator.carPlate(value)){
                                      return '*incorreto.';
                                    }
                                    return null;
                                  },
                                  onSaved: (input) => placa = input,

                                  decoration: InputDecoration(
                                      labelText:"Placa",
                                      labelStyle:TextStyle(
                                        fontFamily: "Brand-Regular",
                                        color: const Color(0xFFCECACA),
                                        fontWeight:FontWeight.w400,
                                        fontSize: 12,
                                      ),
                                      counterStyle: TextStyle(
                                        color: const Color(0xFFCECACA),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color:const Color(0x8dc83535),
                                            width:2
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(

                                            color:const Color(0x8dc83535),
                                            width:2
                                        ),
                                      ),
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color:const Color(0x8dc83535),
                                            width:2
                                        ),
                                      ),
                                      hintStyle: TextStyle(
                                        color: const Color(0xFFB6B2B2),
                                        fontSize: 10.0,
                                      )
                                  ),
                                  style: TextStyle(
                                    color: const Color(0xffFDFDFD),
                                    fontSize: 14.0,
                                    fontFamily: "Brand-Regular",),

                                ),
                                SizedBox(height: 1.0,),
                                TextFormField(
                                  textCapitalization: TextCapitalization.characters,
                                  keyboardType: TextInputType.text,
                                  maxLength:15,
                                  obscureText: true,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "*cor é necessária." ;
                                    }else if(value.length<=3){
                                      return '*incorreto';
                                    }
                                    return null;
                                  },
                                  onSaved: (input) => cor = input,

                                  decoration: InputDecoration(
                                      labelText:"Cor",
                                      labelStyle:TextStyle(
                                        fontFamily: "Brand-Regular",
                                        color: const Color(0xFFCECACA),
                                        fontWeight:FontWeight.w400,
                                        fontSize: 12,
                                      ),
                                      counterStyle: TextStyle(
                                        color: const Color(0xFFCECACA),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color:const Color(0x8dc83535),
                                            width:2
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(

                                            color:const Color(0x8dc83535),
                                            width:2
                                        ),
                                      ),
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color:const Color(0x8dc83535),
                                            width:2
                                        ),
                                      ),
                                      hintStyle: TextStyle(
                                        color: const Color(0xFFB6B2B2),
                                        fontSize: 10.0,
                                      )
                                  ),
                                  style: TextStyle(
                                    color: const Color(0xffFDFDFD),
                                    fontSize: 14.0,
                                    fontFamily: "Brand-Regular",),

                                ),

                                SizedBox(height: 20.0,),
                                Text("Selecione a cidade que irá trabalhar:",textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight:FontWeight.w400,
                                      color: Color(0xFFCECACA)
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  alignment: AlignmentDirectional.center,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF665D5D),
                                    borderRadius:
                                    BorderRadius.only(
                                      topLeft: Radius.circular(12.0),
                                      topRight:Radius.circular(12.0),
                                      bottomLeft:Radius.circular(12.0),
                                      bottomRight:Radius.circular(12.0),
                                    ),
                                  ),
                                  child: DropdownButton<String>(
                                    value: dropDownText,
                                    dropdownColor:  Color(0xFF4B4343),
                                    icon: Icon(FontAwesomeIcons.chevronDown),
                                    iconEnabledColor:Color(0xFFCECACA),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: TextStyle(
                                        color: Color(0xFFCECACA),
                                        fontSize: 14,
                                        fontFamily: "Brand-Regular"),
                                    underline: Container(
                                      color: Color(0xFFCECACA),
                                      height: 0,
                                    ),
                                    onChanged: (String ?data) {
                                      setState(() {
                                        dropDownText = data!;
                                      });
                                    },
                                    items: ItensList.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Center(
                                          child: Text(
                                            value,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                SizedBox(height:42.0),
                                Container(
                                  width:250,

                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFF933A3A),
                                        Color(0xFF742828)
                                      ],
                                    ),
                                  ),
                                  child: ElevatedButton(
                                    child:Text("Criar Conta"),
                                    style: ElevatedButton.styleFrom(

                                      primary: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      textStyle: TextStyle(

                                          color: Colors.white54,
                                          fontSize: 23,
                                          fontFamily: "Brand Bold"
                                          ,fontWeight: FontWeight.bold
                                      ),
                                    ),

                                    onPressed:(){
                                      if(dropDownText!="Selecione uma cidade"){
                                        if (formKey.currentState!.validate()) {
                                          formKey.currentState!.save();
                                          VerificarDados();

                                        }
                                      }else{
                                        WiAlerts.of(context).snack("Selecione sua cidade de trabalho.");
                                      }
                                    },

                                  ),

                                ),


                              ]

                          ),
                        )
                    )
                  ],
                ),
              )
          ),
          Visibility(
              child: Container(
                width: size.width,
                height: size.height,
                color: Colors.black.withAlpha(140),
              ),
              visible: busy),
          Visibility(visible: busy, child: WICarregando()),
        ]
    );

  }

}