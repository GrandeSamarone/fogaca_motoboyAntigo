

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class OnlineOfflineController{
  final FirebaseMessaging firebaseMessaging=FirebaseMessaging.instance;
 /* void makeDriveOnlineNow() async{
    firebaseMessaging.subscribeToTopic(motoboyLogado.cod);
    DatabaseReference MotoboyRequest=FirebaseDatabase.instance.reference().child("MotoboysOnline")
        .child(motoboyLogado.id);
    posicao_atual = await geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    if(_OffouOnline) {
      Geofire.initialize("MotoboysOnline");
      Geofire.setLocation(
          motoboyLogado.id, posicao_atual.latitude, posicao_atual.longitude);


      MotoboyRequest.onValue.listen((event) {

      });
    }
  }

  */


}