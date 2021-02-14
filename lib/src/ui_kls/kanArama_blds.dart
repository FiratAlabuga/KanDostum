import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ildonor/src/model_kls/kbagis_gerekli.dart';
import 'package:ildonor/src/model_view_MV/aranankan_model_view.dart';
import 'package:ildonor/src/ui_kls/kan_istek_bldreq.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class KanArama extends StatefulWidget {
  @override
  _KanAramaState createState() => _KanAramaState();
}

class _KanAramaState extends State<KanArama> {
  TextEditingController _addressController, _requestMessageController;
  var dropDownSelected = 'A+';
  var quantityDropdownSelected = "1";
  bool inProgress = false;
  KanAramaViewModel _searchBloodViewModel = KanAramaViewModel();

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController();
    _requestMessageController = TextEditingController();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _requestMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: inProgress,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'İhtiyacın Olan Kanı Bul'
          ),
          actions: <Widget>[
            IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context)=> KanIstekYonet()
                ));
              },
              icon: Icon(
                Icons.view_list,
                color: Colors.white,
                size: 24,
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Kan Grubunu Seç')
              ),
              SizedBox(
                height:5,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16,),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder()
                  ),
                  value: 'A+',
                  items: <String>['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      dropDownSelected = value;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Kaç Ünite İstediğini Seç')
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16,),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder()
                  ),
                  value: '1',
                  items: <String>['1', '2', '3', '4', '5', '6', '7', '8']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      quantityDropdownSelected = value;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16,),
                child: TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)
                    ),
                    hintText: 'Bağış Bölgesi/İstekle Lazımdır.',
                    labelText: 'Adres',
                    prefixIcon: Icon(
                        Icons.location_on
                    ),
                  ),
                  style: TextStyle(
                    letterSpacing: .8,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 200,
                margin: EdgeInsets.symmetric(horizontal: 16,),
                child: TextField(
                  controller: _requestMessageController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)
                    ),
                    hintText: 'İstek Mesajını Buraya Giriniz',
                    labelText: 'İstek/Talep Mesajı',

                    alignLabelWithHint: true
                  ),
                  maxLines: 10,
                  style: TextStyle(
                    letterSpacing: .8,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: RaisedButton(
                  onPressed: () async{
                    if (_addressController.text.trim().isNotEmpty){
                      KanGerekli bloodReq = KanGerekli(
                        kanGrubu: dropDownSelected,
                        adres: _addressController.text.trim(),
                        gerekliMesaj: _requestMessageController.text.trim(),
                        uniteSayisi: quantityDropdownSelected.toString(),
                      );
                      var result = await _searchBloodViewModel.postSearchBlood(bloodReq);
                      if (result){
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text(
                              'Kan İsteğin Aciliyeti İle Bildirildi!',
                              style: TextStyle(
                                  color: Colors.white
                              ),
                            ), backgroundColor: Colors.green,
                            )
                        );
                        _addressController.clear();
                        _requestMessageController.clear();
                      } else {
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text(
                              'İstek İlertilirken Problem Oluştu!',
                              style: TextStyle(
                                  color: Colors.white
                              ),
                            ), backgroundColor: Colors.red,
                            )
                        );
                      }
                    } else {
                      BotToast.showText(
                        text: 'Lütfen Adres/Bölge Belirtin',
                        textStyle: TextStyle(
                          color: Colors.white
                        ),
                        contentColor: Colors.red
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text(
                        'İsteği Bildir'
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
