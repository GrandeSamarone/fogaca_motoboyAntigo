import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fogaca_app/Notificacao/PushNotificacao.dart';
import 'package:fogaca_app/Providers/Firestore_Dados.dart';
import 'package:fogaca_app/Providers/Prov_Thema_black_light.dart';
import 'package:fogaca_app/Widget/Toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileTabePage extends StatefulWidget {
  static const String idScreen = "Page_Perfil";

  ProfileTabePageState createState() => ProfileTabePageState();

}

class ProfileTabePageState extends State<ProfileTabePage> with AutomaticKeepAliveClientMixin {
  TextEditingController _alterarNome = TextEditingController();
  TextEditingController _alterarCity = TextEditingController();
  TextEditingController _alterarTelefone = TextEditingController();
  TextEditingController _alterarModelo = TextEditingController();
  TextEditingController _alterarPlaca = TextEditingController();
  TextEditingController _alterarCor = TextEditingController();
  PushNotificacao pushNotificacao= PushNotificacao();
  File _imagem;
  String _idUsuarioLogado;
  bool _subindoImagem = false;
  String _urlImagemRecuperada="";
  ThemeChanger themeChanger;
  String dropdownValue="Ji-Paraná";
  List <String> spinnerItems = [
    'Selecione a cidade',
    'Ji-Paraná',
    'Ouro Preto',
    'Jaru',
    'Ariquemes',
    'Cacoal',
    'Médici',
  ];
  Future<void> _pickerImage() async {
    final _picker = ImagePicker();
    var imagemSelecionada;

    imagemSelecionada = (await _picker.getImage(
        source: ImageSource.gallery,
        imageQuality:100,
        maxWidth:400));


    setState(() {
      if (imagemSelecionada != null) {
        _subindoImagem = true;
        _imagem = File(imagemSelecionada.path);
        _uploadImagem();
      } else {
        print('No image selected.');
      }
    });
  }
  Future _uploadImagem() async {

    ProgressDialog progressDialog = ProgressDialog(context,
      title:Text("Carregando imagem"),
      message:Text("Por favor,aguarde..."),);
    progressDialog.setLoadingWidget(CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.redAccent)));
    progressDialog.show();

    var file = File(_imagem.path);

    FirebaseStorage storage = FirebaseStorage.instance;
    Reference pastaRaiz = storage.ref();
    Reference arquivo = pastaRaiz
        .child("perfil")
        .child(_idUsuarioLogado + ".jpg");

    //Upload da imagem
    UploadTask task = arquivo.putFile(file);

    task.snapshotEvents.listen((TaskSnapshot storageEvent) {
      if (storageEvent.state == TaskState.running) {
        setState(() {
          progressDialog.show();
          _subindoImagem = true;
        });
      } else if (storageEvent.state == TaskState.success) {
        progressDialog.dismiss();
        _subindoImagem = false;
        ToastMensagem(
            "Imagem carregada com sucesso.", context);
      }
    });

    //Recuperar URL da imagem
    task.then((TaskSnapshot taskSnapshot) {
      _recuperarUrlImagem(taskSnapshot);
    });
  }

  Future _recuperarUrlImagem(TaskSnapshot snapshot) async {
    String url = await snapshot.ref.getDownloadURL();
    _atualizarUrlImagemFirestore(url);
    setState(() {
      _urlImagemRecuperada = url;

    });
  }

  _atualizarDadosFirestore(){

    String nome = _alterarNome.text;
    String telefone = _alterarTelefone.text;
    String modelo = _alterarModelo.text;
    String cor = _alterarCor.text;
    String placa = _alterarPlaca.text;
    FirebaseFirestore db = FirebaseFirestore.instance;
    String codcity;
    if(dropdownValue=="Ji-Paraná"){
      codcity="jipa";
    }else if(dropdownValue=="Ouro Preto"){
      codcity="ouropreto";
    }else if(dropdownValue=="Jaru"){
      codcity="jaru";
    }else if(dropdownValue=="Ariquemes"){
      codcity="ariquemes";
    }else if(dropdownValue=="Cacoal"){
      codcity="cacoal";
    }else if(dropdownValue=="Médici"){
      codcity="medici";
    }
    Map<String, dynamic> dadosAtualizar = {
      "nome" : nome,
      "telefone" : telefone,
      "modelo" : modelo,
      "cor" : cor,
      "placa" : placa,
      "cidade" : dropdownValue,
      "cod" : codcity,
    };

    db.collection("user_motoboy")
        .doc(_idUsuarioLogado)
        .update( dadosAtualizar );
    ToastMensagem("Dados Atualizado com Sucesso!", context);
  }

  _atualizarUrlImagemFirestore(String url){

    FirebaseFirestore db = FirebaseFirestore.instance;
    Map<String, dynamic> dadosAtualizar = {
      "icon_foto" : url
    };

    db.collection("user_motoboy")
        .doc(_idUsuarioLogado)
        .update( dadosAtualizar );

  }

  _recuperarDadosUsuario() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    User usuarioLogado = await auth.currentUser;
    _idUsuarioLogado = usuarioLogado.uid;

    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot snapshot = await db.collection("user_motoboy")
        .doc( _idUsuarioLogado )
        .get();

    Map<String, dynamic> dados = snapshot.data();
    _alterarNome.text = dados["nome"];
    _alterarTelefone.text = dados["telefone"];
    _alterarModelo.text = dados["modelo"];
    _alterarCor.text = dados["cor"];
    _alterarPlaca.text = dados["placa"];
    _alterarCity.text=dados["cidade"];
    dropdownValue=dados["cidade"];
    if( dados["icon_foto"] != "" ){
      setState(() {
        _urlImagemRecuperada = dados["icon_foto"];
      });

    }
    print("URL DA IMAGEM DO BANCO::");
    print( _urlImagemRecuperada);
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();

  }

  @override
  Widget build(BuildContext context) {
    themeChanger = Provider.of<ThemeChanger>(context, listen: false);
    String url="https://firebasestorage.googleapis.com/v0/b/fogaca-app.appspot.com/o/perfil%2Ftestnimial.png?alt=media&token=343acf84-2f78-4c13-8631-7a5fc7bec90f";

    final dados_provider=Provider.of<Dados_usuario>(context);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 30),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ClipOval(
                  child: Image.network(
                    _urlImagemRecuperada!=""?_urlImagemRecuperada:url,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton.icon(
                      icon: Icon(Icons.image, color: Colors.redAccent),
                      label: Text(
                        'Adicionar imagem',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                      onPressed: _pickerImage,
                    )
                  ],
                ),
                ListTile(
                  leading: Icon(Icons.wb_incandescent_outlined),
                  title: Text(
                    "Modo Escuro",
                    style: TextStyle(fontSize: 15.0),
                  ),
                  trailing: Switch(
                    activeColor: Theme
                        .of(context)
                        .accentColor,
                    inactiveThumbColor: Theme
                        .of(context)
                        .primaryColor,
                    value: themeChanger.isDark(),
                    onChanged: (status) {
                      themeChanger.setDarkStatus(status);

                    },

                  ),
                ),
                DropdownButton<String>(
                  value: dropdownValue,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Theme.of(context).textTheme.headline4.color, fontSize: 18,fontFamily:  "Brand Bold"),
                  underline: Container(
                    height: 2,
                    color: Theme.of(context).textTheme.headline4.color,
                  ),
                  onChanged: (String data) {
                    setState(() {
                      dropdownValue = data;
                    });
                  },
                  items: spinnerItems.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 2),

                  child: TextField(
                    //  maxLengthEnforced:true,
                    maxLength:25,
                    textAlign: TextAlign.center,
                    controller: _alterarNome,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: "Nome",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Theme.of(context).textTheme.subtitle1.color,
                          fontSize: 10.0,
                        )),
                    onChanged:(value){
                      dados_provider.alterarNome(value);
                    },
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),  Padding(
                  padding: EdgeInsets.only(bottom: 2),

                  child: TextField(
                    enabled: false,
                    textAlign: TextAlign.center,
                    controller: _alterarCity,
                    decoration: InputDecoration(
                        labelText: "Cidade",
                        labelStyle: TextStyle(
                          fontSize: 14.0,

                        ),
                        hintStyle: TextStyle(

                          fontSize: 10.0,
                        )),
                    onChanged:(value){
                    },
                    style: TextStyle(fontSize: 16.0,color: Colors.grey),
                  ),
                ),   Padding(
                  padding: EdgeInsets.only(bottom: 2),
                  child: TextField(
                    //  maxLengthEnforced:true,
                    maxLength:25,
                    textAlign: TextAlign.center,
                    controller: _alterarTelefone,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: "Telefone",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Theme.of(context).textTheme.subtitle1.color,
                          fontSize: 10.0,
                        )),
                    onChanged:(value){
                      dados_provider.alterarNome(value);
                    },
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),  Padding(
                  padding: EdgeInsets.only(bottom: 2),
                  child: TextField(
                    //  maxLengthEnforced:true,
                    maxLength:25,
                    textAlign: TextAlign.center,
                    controller: _alterarModelo,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: "Modelo",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Theme.of(context).textTheme.subtitle1.color,
                          fontSize: 10.0,
                        )),
                    onChanged:(value){
                      dados_provider.alterarNome(value);
                    },
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),  Padding(
                  padding: EdgeInsets.only(bottom: 2),
                  child: TextField(
                    //  maxLengthEnforced:true,
                    maxLength:25,
                    textAlign: TextAlign.center,
                    controller: _alterarCor,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: "Cor",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Theme.of(context).textTheme.subtitle1.color,
                          fontSize: 10.0,
                        )),
                    onChanged:(value){
                      dados_provider.alterarNome(value);
                    },
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),  Padding(
                  padding: EdgeInsets.only(bottom: 2),
                  child: TextField(
                    //  maxLengthEnforced:true,
                    maxLength:25,
                    textAlign: TextAlign.center,
                    controller: _alterarPlaca,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: "Placa",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Theme.of(context).textTheme.subtitle1.color,
                          fontSize: 10.0,
                        )),
                    onChanged:(value){
                      dados_provider.alterarNome(value);
                    },
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 4, bottom: 10),
                  child: ElevatedButton(
                      child: Text('Atualizar dados'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red[900],
                        //  onPrimary: Colors.white,
                        onSurface: Colors.grey,
                        shape: const BeveledRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),

                        textStyle: TextStyle(
                            color: Colors.white54,
                            fontSize: 18,
                            fontFamily: "Brand Bold"),
                      ),
                      onPressed:(){
                        _atualizarDadosFirestore();
                      }
                    // _atualizarNomeFirestore,

                  ),
                ),
              ],
            ),
          ),
        ),
      ),

    );

  }
  _launchWhatsapp() async {
    const url = "https://api.whatsapp.com/send?phone=556992417580&text=ol%C3%A1";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}
