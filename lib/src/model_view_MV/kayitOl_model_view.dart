import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ildonor/src/model_kls/kullaniciModel.dart';

class KayitOlViewModel{
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Firestore _firestore = Firestore.instance;
  FirebaseUser _kullanici;
  String _hataMesaj;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  FirebaseUser get firebaseUser => this._kullanici;
  String get errorMessage => this._hataMesaj;

  Future<bool> createNewUser(String email, password)async{
    try {
      var _authResult = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (_authResult != null){
        _kullanici =  _authResult.user;
        return true;
      }
    } catch (e){
      _hataMesaj = e.toString();
      return false;
    }
  }

  Future<bool> uploadUserData(Kullanici kullanici, {String image})async{
    try {
      await _firestore.collection('Kullanıcılar').add({
        'kullanici_id': kullanici.uid,
        'Ad Soyad': kullanici.adSoyad,
        'Email': kullanici.email,
        'Telefon Numarası': kullanici.telefonNu,
        'Kan Grubu': kullanici.kanGrubu,
        'Adres': kullanici.adres,
        'Profil-img' : image!=null ? image : 'default'
      });
      return true;
    } catch (e){
      _hataMesaj = e.toString();
      return false;
    }
  }

  Future<String> uploadImage(File imageFile)async{
    try {
      StorageReference ref =
      _firebaseStorage.ref().child('Kullanıcılar-Profil-img');
      StorageUploadTask uploadTask = ref.putFile(imageFile);
      return await (await uploadTask.onComplete).ref.getDownloadURL();
    } catch (e){
      _hataMesaj = e.toString();
      return null;
    }
  }

}