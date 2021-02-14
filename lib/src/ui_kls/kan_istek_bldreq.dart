import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicator_button/progress_button.dart';

class KanIstekYonet extends StatefulWidget {
  @override
  KanIstekYonetState createState() => KanIstekYonetState();
}

class KanIstekYonetState extends State<KanIstekYonet> {
  bool inProgress = false;
  Firestore _fireStore = Firestore.instance;
  String uid;

  @override
  void initState() {
    super.initState();
    getRequest();
  }

  Widget mainList;

  Future<bool> getRequest() async {
    try {
      setState(() {
        inProgress = true;
      });
      final FirebaseUser user = await FirebaseAuth.instance.currentUser();
      uid = user.uid;
      setState(() {
        mainList = StreamBuilder(
          stream: Firestore.instance
              .collection('Kan_Arama_Gerekliliği')
              .where('kullanici_id', isEqualTo: uid)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              var trains = snapshot.data.documents;
              List<Card> allTrains = [];
              for (var doc in trains) {
                final kullaniciAdi = doc.data['Kullanıcı Adı'];
                final telNu = doc.data['Telefon Numarası'];
                final adres = doc.data['Adres'];
                final kanGrubu = doc.data['Kan Grubu'];
                final requestMessage = doc.data['Gereklilik Mesajı'];
                final uniteKan = doc.data['Gerekli Ünite Sayısı'];
                final docID = doc.documentID;

                final listTile = Card(
                    elevation: 4,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            '$kullaniciAdi',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                                fontSize: 16),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          color: Colors.red,
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              'Aranıyor..',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: 10,
                            ),
                            CircleAvatar(
                              radius: 30,
                              child: Text(
                                '$kanGrubu',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600),
                              ),
                              backgroundColor: Colors.red,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.location_on,
                                        color: Colors.red,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '$adres',
                                        style: TextStyle(color: Colors.red),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.call,
                                        color: Colors.red,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '$telNu',
                                        style: TextStyle(color: Colors.red),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.play_arrow,
                                        color: Colors.red,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '$uniteKan Unite',
                                        style: TextStyle(color: Colors.red),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ProgressButton(
                          color: Colors.red,
                          onPressed: (AnimationController _animation){
                            _animation.forward();
                            _fireStore.collection('Kan_Arama_Gerekliliği').document(docID).delete().whenComplete(() {
                              _animation.reverse();
                              Scaffold.of(context).showSnackBar(
                                  SnackBar(content: Text(
                                    'Kan İsteği Silindi!',
                                    style: TextStyle(
                                        color: Colors.white
                                    ),
                                  ), backgroundColor: Colors.green,
                                  )
                              );
                            }).catchError((onError){
                              _animation.reverse();
                              Scaffold.of(context).showSnackBar(
                                  SnackBar(content: Text(
                                    'Kan İsteği Silinemedi',
                                    style: TextStyle(
                                        color: Colors.white
                                    ),
                                  ), backgroundColor: Colors.red,
                                  )
                              );
                            });
                          },
                          child: Text(
                              'İsteği Kaldır/Sil',
                            style: TextStyle(
                              color: Colors.white
                            ),
                          ),
                        )
                      ],
                    ));
                allTrains.add(listTile);
              }
              if (allTrains.length == 0){
                return Center(
                  child: Text('Bildirim Yok'),
                );
              } else {
                return  ListView(
                  children: allTrains,
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        );
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
    return Scaffold(
        appBar: AppBar(
          title: Text('Bildirilen Tüm İstekler'),
        ),
        body: mainList
    );
  }
}
