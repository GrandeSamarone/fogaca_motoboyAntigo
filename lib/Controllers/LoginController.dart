
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fogaca_app/Model/Motoboy.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController{
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String erro;
  Motoboy _motoboy;

  Future<String> LoginGoogle() async{

    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth= await googleUser.authentication;
    AuthCredential credentialGoogle;
    User firebaseUser;
    String tokenGoogle;

    try {
      final FirebaseMessaging firebaseMessaging=FirebaseMessaging.instance;
      tokenGoogle = await firebaseMessaging.getToken();

      credentialGoogle = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken
      );
      firebaseUser=
          (await _auth.signInWithCredential(credentialGoogle)).user;

    } on FirebaseAuthException catch (e) {
      erro=e.toString();
      print("erro!!feiao::${e}");
      if (e.code == '[firebase_auth/email-already-in-use] The email address is already in use by another account.') {
        return'e-mail já existe.';
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }

    if(firebaseUser!=null){
      print("PASSOU!${firebaseUser.email}");

      final consult =await FirebaseFirestore.instance
          .collection("user_motoboy")
          .where("email",isEqualTo:firebaseUser.email)
          .get()
          .then((value) => value.size);

      print("Size:: $consult");
      if(consult>0){

        Map<String,dynamic> dados=Map();
        dados["token"]=tokenGoogle;

        _db.collection("user_motoboy").doc(firebaseUser.uid).update(dados);

        return "sucesso";

      }else{
        Logout();
        return "esta conta não existe.";

      }
    }else{
      return erro;
    }
    /*if(firebaseUser!=null){}
    var token = await firebaseUser.getIdToken();

    print(firebaseUser.displayName);
    print(firebaseUser.email);
    print(firebaseUser.phoneNumber);*/

    //  lojista.nome=firebaseUser.displayName;
    // lojista.email=firebaseUser.email;
    // lojista.icon_foto=firebaseUser.photoURL;
    // lojista.id=token;





  }

  Future Logout()async{
    await FirebaseAuth.instance.signOut();

    _googleSignIn.signOut();
    _motoboy=new Motoboy();
  }

  Future sendPasswordResetEmail(String email) async {
    return _auth.sendPasswordResetEmail(email: email);

  }

  Future <String>LoginEmail(String email,String senha)async{

    final FirebaseFirestore _db = FirebaseFirestore.instance;
    final firebaseMessaging=FirebaseMessaging.instance;
    String token = await firebaseMessaging.getToken();
    UserCredential userCredential;

    try {
      final FirebaseMessaging firebaseMessaging=FirebaseMessaging.instance;
      String token = await firebaseMessaging.getToken();

      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: senha
      );
    } on FirebaseAuthException catch (e) {
      erro=e.toString();
      print("erro!!feiao::${e}");
      if (e.code == '[firebase_auth/email-already-in-use] The email address is already in use by another account.') {
        return'e-mail já existe.';
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }

    if(userCredential!=null){
      print("PASSOU!${userCredential.user.email}");

      final consult =await FirebaseFirestore.instance
          .collection("user_motoboy")
          .where("email",isEqualTo:userCredential.user.email)
          .get()
          .then((value) => value.size);

      print("Size:: $consult");
      if(consult>0){

        Map<String,dynamic> dados=Map();
        dados["token"]=token;

        _db.collection("user_motoboy").doc(userCredential.user.uid).update(dados);

        return "sucesso";

      }else{
        Logout();
        return "esta conta não existe.";

      }
    }else{
      return erro;
    }
  }

}