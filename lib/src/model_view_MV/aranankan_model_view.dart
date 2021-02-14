import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ildonor/src/model_kls/kbagis_gerekli.dart';

class KanAramaViewModel {
  Firestore _fireStore = Firestore.instance;
  String _hataMesaj;
  String get errorMessage => this._hataMesaj;


  Future<bool> postSearchBlood(KanGerekli kanGerekli) async{
    try {
      final FirebaseUser user = await FirebaseAuth.instance.currentUser();
      final uid = user.uid;
      var results = await _fireStore.collection('Kullanıcılar')
        ..where("kullanici_id",isEqualTo: uid)
            .getDocuments().then((value){
              var data = value.documents[0].data;
            kanGerekli.kullaniciAdi = data['Ad Soyad'];
            kanGerekli.telefonNumarasi = data['Telefon Numarası'];
        }).then((value) async{
          await _fireStore.collection('Kan_Arama_Gerekliliği').add({
          'Kullanıcı Adı': kanGerekli.kullaniciAdi,
          'Kan Grubu': kanGerekli.kanGrubu,
          'Telefon Numarası': kanGerekli.telefonNumarasi,
          'Adres': kanGerekli.adres,
          'Gerekli Ünite Sayısı': kanGerekli.uniteSayisi,
          'Gereklilik Mesajı': kanGerekli.gerekliMesaj,
          'Toplanan Puan':kanGerekli.toplananPuan,
          'kullanici_id': uid,
          });
        });

      return true;
    } catch (e){
      _hataMesaj = e.toString();
      return false;
    }
  }
}