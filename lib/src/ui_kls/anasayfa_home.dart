import 'package:flutter/material.dart';
import 'package:ildonor/src/ui_kls/akis_feed.dart';
import 'package:ildonor/src/ui_kls/bildirim_notificate.dart';
import 'package:ildonor/src/ui_kls/kanArama_blds.dart';
import 'package:ildonor/src/ui_kls/profil_profile.dart';
class AnaEkran extends StatefulWidget {
  @override
  _AnaEkranState createState() => _AnaEkranState();
}

class _AnaEkranState extends State<AnaEkran> {
  List<Widget> _pages = [
    HaberAkis(),
    KanArama(),
    Bildirimler(),
    Profile()
  ];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.red,
        elevation: 6,
        onTap: (index){
          setState(() {
            selectedIndex = index;
          });
        },
        currentIndex: selectedIndex,
        unselectedIconTheme: IconThemeData(
          color: Colors.black87,
        ),
        selectedItemColor: Colors.red,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            title: Text('Canlı Akış'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.search),
              title: Text('Ara')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            title: Text('Bildirimler'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Profil')
          )
        ],
      ),
      body: _pages[selectedIndex],
    );
  }
}
