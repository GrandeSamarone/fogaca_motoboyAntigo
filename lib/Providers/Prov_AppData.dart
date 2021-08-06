
import 'package:flutter/cupertino.dart';
import 'package:fogaca_app/Model/Endereco.dart';

class AppData extends ChangeNotifier
{
Endereco localidade,dropOffLocation;

void atualizarlocalEndereco(Endereco endereco){

  localidade=endereco;
   notifyListeners();

}
void atualizarDropOffEndereco(Endereco dropOffendereco){

  dropOffLocation=dropOffendereco;
  notifyListeners();

}
}