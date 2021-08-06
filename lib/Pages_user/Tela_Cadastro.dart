import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flux_validator_dart/flux_validator_dart.dart';
import 'package:fogaca_app/Pages_user/Tela_Cad_Moto.dart';
import 'package:fogaca_app/Widget/WIDivider.dart';
class Tela_Cadastro extends StatefulWidget {

  static const String idScreen = "cadastroinicial";
  _Tela_CadastroState createState() => _Tela_CadastroState();
}

class _Tela_CadastroState extends State<Tela_Cadastro> {

  var busy=false;
  final _formKey = GlobalKey<FormState>();
  var  _nome;
  var _tel;
  var senha;
  var repetirsenha;
  var email;
  var _cpf_cnpj;
  var tipoDado;
  TextEditingController cpf_Controller = TextEditingController();
  TextEditingController cnpj_Controller = TextEditingController();
  bool CPFValid = false;
  bool CNPJValid = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          Image.asset(
            "imagens/Vector_Cadastro.png",
          ),
          Scaffold(
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

                    Text("Crie sua Conta",
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
                        height: MediaQuery.of(context).size.height,
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
                                  spreadRadius:2
                              )
                            ]
                        ),
                        padding: EdgeInsets.only(
                          left: 40,
                          right: 40,
                          bottom: 20,
                        ),
                        child: Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                            child: Column(
                                children: [
                                  SizedBox(height:20.0),
                                  TextFormField(
                                    textCapitalization: TextCapitalization.none,
                                    keyboardType: TextInputType.text,
                                    obscureText: false,
                                    maxLength:35,

                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return '*Digite um nome.';
                                      }else if(value.length<4){
                                        return '*mínimo 4 caracteres.';
                                      }
                                      return null;
                                    },
                                    onSaved: (input) => _nome = input,

                                    decoration: InputDecoration(
                                        labelText:"Nome usuário",
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

                                  SizedBox(height: 1.0),

                                  TextFormField(
                                    textCapitalization: TextCapitalization.none,
                                    keyboardType: TextInputType.phone,
                                    obscureText: false,
                                    maxLength:12,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return '*número de telefone é obrigatório.';
                                      }else if(Validator.phone(value)){
                                        return '*Digite um numero válido.';
                                      }
                                      return null;
                                    },
                                    onSaved: (input) {
                                      _tel=input;
                                    },
                                    decoration: InputDecoration(
                                        labelText:"Telefone",
                                        labelStyle:TextStyle(
                                          fontFamily: "Brand-Regular",
                                          color: const Color(0xFFB6B2B2),
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

                                  SizedBox(height: 3.0),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child:Text(
                                      "Selecione uma  opção:",
                                      style: TextStyle(fontSize: 15.0,
                                          fontFamily: "Brand Bold",
                                          fontWeight:FontWeight.w400,
                                          color: Color(0xFFB6B2B2)
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),


                                  new Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      new Theme(
                                        data: Theme.of(context).copyWith(
                                          unselectedWidgetColor: Color(0xFFB6B2B2),
                                        ),child:Checkbox(
                                        activeColor: Colors.red[900],
                                        checkColor:  Colors.white,
                                        value: CPFValid,
                                        onChanged: (bool ?value) {
                                          setState(() {
                                            CPFValid = value!;
                                            CNPJValid = false;
                                            cnpj_Controller.clear();
                                            // valWednesday = false;
                                          });
                                        },
                                      ),
                                      ),
                                      new Text(
                                        'CPF',
                                        style: new TextStyle(
                                          color: Color(0xFFB6B2B2),
                                          fontWeight:FontWeight.w400,
                                          fontSize: 12,),
                                      ),
                                      new Theme(
                                        data: Theme.of(context).copyWith(
                                          unselectedWidgetColor: Color(0xFFB6B2B2),
                                        ),child:Checkbox(

                                        activeColor: Colors.red[900],
                                        checkColor:  Colors.white,
                                        value: CNPJValid,
                                        onChanged: (bool ?value) {
                                          setState(() {
                                            CNPJValid = value!;
                                            CPFValid = false;
                                            cpf_Controller.clear();
                                            // valWednesday = false;
                                          });
                                        },
                                      ),
                                      ),
                                      new Text(
                                        'CNPJ',
                                        style: new TextStyle(
                                          color: Color(0xFFB6B2B2),
                                          fontWeight:FontWeight.w400,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  WIDividerWidget(),

                                  CPFValid ?
                                  TextFormField(
                                    textCapitalization: TextCapitalization.none,
                                    keyboardType: TextInputType.number,
                                    obscureText: false,
                                    maxLength:11,
                                    validator: (value) {
                                      if (value!.isNotEmpty) {
                                        if(Validator.cpf(value)){
                                          return '*CPF inválido.';
                                        }
                                      }
                                      return null;
                                    },
                                    onSaved: (input){
                                      _cpf_cnpj = input;
                                      tipoDado="CPF";
                                    } ,
                                    decoration: InputDecoration(
                                        labelText:"CPF",
                                        labelStyle:TextStyle(
                                          fontFamily: "Brand-Regular",
                                          color: const Color(0xFFB6B2B2),
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

                                  ):new Container(),

                                  CNPJValid?
                                  TextFormField(
                                    textCapitalization: TextCapitalization.none,
                                    keyboardType: TextInputType.number,
                                    obscureText: false,
                                    maxLength:14,
                                    validator: (value) {
                                      if (value!.isNotEmpty) {
                                        if(Validator.cnpj(value)){
                                          return '*CNPJ inválido.';
                                        }
                                      }
                                      return null;
                                    },
                                    onSaved: (input){
                                      _cpf_cnpj = input;
                                      tipoDado="CNPJ";

                                    } ,
                                    decoration: InputDecoration(
                                        labelText:"CNPJ",
                                        labelStyle:TextStyle(
                                          fontFamily: "Brand-Regular",
                                          color: const Color(0xFFB6B2B2),
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

                                  ): new Container(),
                                  TextFormField(
                                    textCapitalization: TextCapitalization.none,
                                    keyboardType: TextInputType.emailAddress,
                                    obscureText: false,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return '*Digite um e-mail.';
                                      }else if(Validator.email(value)){
                                        return '*Digite um e-mail válido';
                                      }
                                      return null;
                                    },
                                    onSaved: (input) => email = input,

                                    decoration: InputDecoration(
                                        labelText:"E-mail",
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
                                    textCapitalization: TextCapitalization.none,
                                    keyboardType: TextInputType.visiblePassword,
                                    obscureText: true,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "*Digite uma senha." ;
                                      }else if(value.length<=5){
                                        return '*Senha no mínimo 6 digitos';
                                      }
                                      return null;
                                    },
                                    onSaved: (input) => senha = input,

                                    decoration: InputDecoration(
                                        labelText:"Senha",
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
                                    textCapitalization: TextCapitalization.none,
                                    keyboardType: TextInputType.visiblePassword,
                                    obscureText: true,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "*Por favor repetir a mesma senha." ;
                                      }else if(value.length<=5){
                                        return '*Senha no mínimo 6 digitos';
                                      }
                                      return null;
                                    },
                                    onSaved: (input) => repetirsenha = input,

                                    decoration: InputDecoration(
                                        labelText:"Confirmar senha",
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
                                  Container(
                                    width:250,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFFD52626),
                                          Color(0xFF901F1F)
                                        ],
                                      ),
                                    ),
                                    child: ElevatedButton(
                                      child:Text(">> Continuar"),
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
                                        if (_formKey.currentState!.validate()) {
                                          _formKey.currentState!.save();
                                          PassarInfoProxPagina();

                                        }
                                      },
                                    ),

                                  ),

                                ]

                            ),
                          ),
                        )
                    ),
                  ],
                ),
              )
          ),
        ]
    );

  }


  PassarInfoProxPagina(){
    setState(() {
      busy=true;
    });

    Map<String, dynamic> Data = new Map();
    Data["nome"]= _nome;
    Data["telefone"]= _tel;
    Data["tipo_dados"]=tipoDado;
    Data["cpf_cnpj"]= _cpf_cnpj;

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Tela_Cad_Moto(Data)
        )
    );


  }
}