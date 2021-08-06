import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';


class TelaVerHistorico extends StatefulWidget {

  Map<String, dynamic> historico = Map();
  static const String idScreen = "telaverhistorico";

  TelaVerHistorico({this.historico});

  @override
  _TelaVerHistoricoState createState() => _TelaVerHistoricoState();
}

double starCounter=0.0;
String title;
double star=0;
String icon,NomeMotoboy,desc,estrela="0.0",situacao,endereco,data;
TextEditingController Comentario_Controller = TextEditingController();

class _TelaVerHistoricoState extends State<TelaVerHistorico> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:false,
      backgroundColor: Theme.of(context).cardColor,
      body: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        backgroundColor: Colors.transparent,
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Container(
                  margin: EdgeInsets.all(5.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme
                        .of(context)
                        .cardColor,
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: [
                      BoxShadow(
                        //sombra da caixa de pesquisa
                        //color: Colors.white,
                        color: Theme.of(context).textTheme.bodyText2.color,
                        blurRadius: 16.0,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7),
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 30.0,),

                      Text(
                        "Histórico do Pedido",
                        style: TextStyle(fontSize: 20.0, fontFamily: "Brand Bold"),
                      ),

                      SizedBox(height: 22.0,),

                      Divider(height: 2.0, thickness: 2.0,),
                      SizedBox(height: 6.0),
                      Column(
                          children: <Widget>[
                            CircleAvatar(
                                radius: 35,
                                backgroundColor: Colors.grey,
                                backgroundImage:widget.historico["icon_loja"]!=null?
                                NetworkImage(widget.historico["icon_loja"]):null
                            ),
                            SizedBox(height: 16.0,),
                            Text(widget.historico["nome_ponto"]!=null?widget.historico["nome_ponto"]:"",style: TextStyle(fontSize: 20.0)),
                          ]),
                      SizedBox(height: 16.0,),
                      Container(
                          width: 120.0,
                          child: Text(widget.historico["end_ponto"]!=null?widget.historico["end_ponto"]:"", style: TextStyle(fontSize: 16.0, fontFamily: "Brand-Bold"),)),
                      SizedBox(height: 16.0,),
                      Text(widget.historico["data"]!=null?widget.historico["data"]:"", style: TextStyle(fontSize: 16.0, fontFamily: "Brand-Bold"),),
                      SizedBox(height: 14.0,),

                      SizedBox(height: 16.0,),
                      Text(
                        widget.historico["situacao"]!=null?
                        widget.historico["situacao"]:"",
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: TextStyle(
                            fontSize: 16.0, fontFamily: "Brand-Bold"),
                        ),
                      SizedBox(height: 16.0,),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child:ElevatedButton.icon(
                              icon: Icon(FontAwesomeIcons.star, color: Colors.white54,size:18.0,),
                              label:Text('Fechar'),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),

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

                              onPressed: (){

                               Navigator.pop(context);
                              })


                      ),

                      SizedBox(height: 30.0,),
                    ],
                  ),
                ),
        ),

      ),
    );

  }
  /*
  void DadosDoPedidoAtual() {

    FirebaseFirestore db=FirebaseFirestore.instance;

    print("ID DO PEDIDO HISTORICO::${widget.id}");
    db.collection("Pedidos")
        .doc(widget.id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var corridaAtual = documentSnapshot.data();
        if(mounted) {
          setState(() {
            icon = corridaAtual["icon_loja"];
            desc = corridaAtual["nome_ponto"];
            situacao = corridaAtual["situacao"];
            endereco = corridaAtual["end_ponto"];
            data = corridaAtual["data"];
          });
        }



      }});
  }

   */
}
