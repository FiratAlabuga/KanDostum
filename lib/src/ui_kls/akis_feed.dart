import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ildonor/src/ui_kls/harita_map.dart';
import 'package:ildonor/src/ui_kls/haritahast.dart';
import 'package:url_launcher/url_launcher.dart';


class HaberAkis extends StatefulWidget {
  @override
  _HaberAkisState createState() => _HaberAkisState();
}

class _HaberAkisState extends State<HaberAkis> {
  Firestore _firestore;
  int puan;
  @override
  void initState() {
    super.initState();
    _firestore = Firestore.instance;
  }

    _guncelPuan() async {
    Map<String, dynamic> data = <String, dynamic>{
      "Toplanan Puan": puan + 10,
    };
    await Firestore.instance
        .collection("Kan_Arama_Gerekliliği")
        .document()
        .updateData(data)
        .whenComplete(() {
      print("puan güncellendi");
    }).catchError((e) => print(e));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Haber Akışı'
        ),
        actions: <Widget>[
          IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) => HaritadaBul()
              ));
            },
            icon: Icon(
              Icons.map
            ),
          )
        ],
      ),
      body: StreamBuilder(
        stream: _firestore.collection('Kan_Arama_Gerekliliği').snapshots(),
        builder: (context, snapshot){

              if (snapshot.hasData){
                var trains = snapshot.data.documents;
                List<Card> allTrains = [];
                for (var doc in trains){
                  final adSoyad = doc.data['Kullanıcı Adı'];
                  final telefonNu = doc.data['Telefon Numarası'];
                  final adres = doc.data['Adres'];
                  final kanGrubu = doc.data['Kan Grubu'];
                  final reqMesaj = doc.data['Gereklilik Mesajı'];
                  final units = doc.data['Gerekli Ünite Sayısı'];
                  final mesaj="Merhaba Ben $adSoyad, acil $kanGrubu tipi kana ihtiyacımız vardır. Şuan ki konum:$adres , İletişim Kurmak İçin Bana Ulaşın.";

                  final listTile = Card(
                    elevation: 4,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            '$adSoyad',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                              fontSize: 16
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          color: Colors.red,
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              'Kullanıcının Mesajı: $reqMesaj',
                              style: TextStyle(
                                color: Colors.white
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10
                        ),
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
                                  fontWeight: FontWeight.w600
                                ),
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
                                      Icon(Icons.location_on, color: Colors.red,),
                                      SizedBox(width: 5,),
                                      Text(
                                        '$adres',
                                        style: TextStyle(
                                          color: Colors.red
                                        ),
                                      )
                                    ],
                                  ),
                                  InkWell(
                                    onTap: (){
                                      _guncelPuan();
                                      launch("tel://$telefonNu");
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.call, color: Colors.red,),
                                        SizedBox(width: 5,),
                                        Text(
                                          '$telefonNu',
                                          style: TextStyle(
                                            color: Colors.red
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      launch("sms://phone$telefonNu&text=$mesaj");
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.call, color: Colors.red,),
                                        SizedBox(width: 5,),
                                        Text(
                                          'Whatsapp İletişim: $telefonNu',
                                          style: TextStyle(
                                            color: Colors.red
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.play_arrow, color: Colors.red,),
                                      SizedBox(width: 5,),
                                      Text(
                                        '$units Unite',
                                        style: TextStyle(
                                          color: Colors.red
                                        ),
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
                        )
                      ],
                    )
                  );
                  allTrains.add(listTile);
                }
                return ListView(
                  children: allTrains,
                );
              } else {
                return Center(
                  child: Text(
                    'Kan İsteği Boş!'
                  ),
                );
              }

        },
      )
    );
  }
}