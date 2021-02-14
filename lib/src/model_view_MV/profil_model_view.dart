import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ProfilViewModel{
  Firestore _fireStore = Firestore.instance;
  String _errorMessage, _adSoyad, _kanGrubu, _telefonNumarasi, _email, _adres;
  String get errorMessage => this._errorMessage;
  String get adSoyad => this._adSoyad;
  String get kanGrubu => this._kanGrubu;
  String get telefonNumarasi => this._telefonNumarasi;
  String get email => this._email;
  String get adres => this._adres;


  Future<bool> getProfileDetails() async{
    try {
      final FirebaseUser user = await FirebaseAuth.instance.currentUser();
      final uid = user.uid;
      _fireStore.collection('Kullanıcılar')
        ..where("kullanici_id",isEqualTo: uid)
            .getDocuments().then((value){
          var data = value.documents[0].data;
          _adSoyad = data['Ad Soyad'];
          _telefonNumarasi = data['Telefon Numarası'];
          _adres = data['Adres'];
          _email = data['Email'];
          _kanGrubu = data['Kan Grubu'];
        }).whenComplete(() {
        });
      return true;
    } catch (e){
      _errorMessage = e.toString();
      return false;
    }
  }
}