import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ildonor/src/model_kls/kullaniciModel.dart';
import 'package:ildonor/src/services_kls/authservice.dart';
import 'package:ildonor/src/ui_kls/sifreDegis_changePass.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:ildonor/src/ui_kls/profil_duzenle_ep.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool inProgress = false;
  Firestore _fireStore = Firestore.instance;
  String _adSoyad, _kanGrubu, _telefonNu, _email, _adres, uid;

  @override
  void initState() {
    super.initState();
    getProfileDetails();
  }

  Future<bool> getProfileDetails() async {
    try {
      setState(() {
        inProgress = true;
      });
      final FirebaseUser kullanici = await FirebaseAuth.instance.currentUser();
      uid = kullanici.uid;
      _fireStore.collection('Kullanıcılar')
        ..where("kullanici_id", isEqualTo: uid).getDocuments().then((value) {
          var data = value.documents[0].data;
          _adSoyad = data['Ad Soyad'];
          _telefonNu = data['Telefon Numarası'];
          _adres = data['Adres'];
          _email = data['Email'];
          _kanGrubu = data['Kan Grubu'];
        }).whenComplete(() {
          setState(() {
            inProgress = false;
          });
        });
      return true;
    } catch (e) {
      BotToast.showText(
          text: e.toString(),
          contentColor: Colors.red,
          textStyle: TextStyle(color: Colors.white));
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: inProgress,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Profil',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w600),
                      ),
                      IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: () {
                          getProfileDetails();
                        },
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: <Widget>[
                      Hero(
                        tag: 'profile-img',
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              image: DecorationImage(
                                  image: AssetImage('assets/images/user.png'),
                                  fit: BoxFit.cover),
                              boxShadow: [
                                BoxShadow(color: Colors.grey, blurRadius: 3)
                              ]),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '$_adSoyad',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            '$_kanGrubu',
                            style: TextStyle(color: Colors.black54),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            '$_telefonNu',
                            style: TextStyle(color: Colors.black54),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            '$_adres',
                            style: TextStyle(color: Colors.black54),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          OutlineButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          EditProfile(
                                            kullanici: Kullanici(
                                                adres: _adres,
                                                kanGrubu: _kanGrubu,
                                                uid: uid,
                                                telefonNu: _telefonNu,
                                                adSoyad: _adSoyad,
                                                email: _email),
                                          )));
                            },
                            child: Text('Düzenle'),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Card(
                    elevation: 2,
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          onTap: () {
                            _showPG2(
                                text:
                                    'Uygulama Sürümü : v1.0.0\nUygulama Geliştirilmeye Devam Edilmekte.\nPowered by JFA');
                          },
                          leading: Icon(
                            Icons.info_outline,
                            color: Colors.red,
                          ),
                          title: Text('Hakkında'),
                        ),
                        Divider(
                          height: 10,
                        ),
                        ListTile(
                          onTap: () {
                            _showPG(
                                text:
                                    'Bu uygulama bir acil yardım uygulaması olduğundan dolayı iletişim bilgileriniz paylaşılmaktadır.');
                          },
                          leading: Icon(
                            Icons.security,
                            color: Colors.red,
                          ),
                          title: Text('Gizlilik ve Politika'),
                        ),
                        Divider(
                          height: 10,
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SifreDegis(
                                          kullanici: Kullanici(
                                              adres: _adres,
                                              kanGrubu: _kanGrubu,
                                              uid: uid,
                                              telefonNu: _telefonNu,
                                              adSoyad: _adSoyad,
                                              email: _email),
                                        )));
                          },
                          leading: Icon(
                            Icons.vpn_key,
                            color: Colors.red,
                          ),
                          title: Text('Parolanı Değiştir'),
                        ),
                        Divider(
                          height: 10,
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.exit_to_app,
                            color: Colors.red,
                          ),
                          title: Text('Çıkış Yap'),
                          onTap: () {
                            AuthService().signOut();
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showPG({@required String text}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          elevation: 0,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: IntrinsicWidth(
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Gizlilik ve Politika ",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      text,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Tamam"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showPG2({@required String text}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          elevation: 0,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: IntrinsicWidth(
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Hakkında ",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      text,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Tamam"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
