
import 'package:flutter/Material.dart';

class WIQuantPedidoLDDireito extends StatelessWidget{

  final Function() callback;
  var _N_Pedidos;
  WIQuantPedidoLDDireito({
   required this.callback,
  }
      );

  @override
  Widget build(BuildContext context) {

    return Positioned(
      top: 45.0,
      right: 22.0,
      child: GestureDetector(
        onTap:callback,
        child: Container(
          decoration: BoxDecoration(
            //   color: Colors.white,
              borderRadius: BorderRadius.circular(22.0),
              boxShadow: [
                BoxShadow(
                    blurRadius: 6.0,
                    spreadRadius: 0.5,
                    offset: Offset(
                      0.7,
                      0.7,
                    ))
              ]),
          child: CircleAvatar(
              child: Image.asset("imagens/moto_android.png",height:35,),

          ),
        ),
      ),
    );
  }
/*child:Badge(badgeContent: Text("0"),

              )*/
}