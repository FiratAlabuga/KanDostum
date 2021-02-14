import 'package:firebase_auth/firebase_auth.dart';

class GirisYapViewModel {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _hataMesaj;

  String get errorMessage => this._hataMesaj;

  Future<bool> signInUser(String email, String password) async{
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch(e){
      _hataMesaj = e.toString();
      return false;
    }
  }
}