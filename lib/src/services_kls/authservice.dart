import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ildonor/src/ui_kls/anasayfa_home.dart';
import 'package:ildonor/src/ui_kls/girisYap_signIn.dart';

class AuthService {
  //Handles Auth
  handleAuth() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return AnaEkran();
          } else {
            return GirisYap();
          }
        });
  }

  signOut(){
    FirebaseAuth.instance.signOut();
  }
}