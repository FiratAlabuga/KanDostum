import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:progress_indicator_button/progress_button.dart';


class SifreUnutma extends StatefulWidget {
  @override
  _SifreUnutmaState createState() => _SifreUnutmaState();
}

class _SifreUnutmaState extends State<SifreUnutma> {
  TextEditingController _emailController;
  bool inProgress = false;
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: inProgress,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/hand.png', height: 150, width: 150,),
            SizedBox(
              width: 20,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16,),
              child: TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)
                  ),
                  hintText: 'Email Giriniz',
                  labelText: 'Email',
                  prefixIcon: Icon(
                      Icons.email
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
              width: MediaQuery.of(context).size.width-32,
              child: ProgressButton(
                color: Colors.red,
                onPressed: (AnimationController _controller) async{
                  bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_emailController.text.trim());
                  if (emailValid){
                    _controller.forward();
                    FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim()).catchError((e){
                      _controller.reverse();
                      BotToast.showText(
                          text: e.toString(),
                          contentColor: Colors.red,
                          textStyle: TextStyle(
                              color: Colors.white
                          )
                      );
                    }).whenComplete(() => (){
                      _controller.reverse();
                      BotToast.showText(
                          text: 'Emailinizi Kontrol Ediniz Şifre Yenileme Linki Gönderilmiştir!',
                          contentColor: Colors.green,
                          textStyle: TextStyle(
                              color: Colors.white
                          )
                      );
                    });
                  } else {
                    BotToast.showText(
                        text: 'Email Giriniz!',
                        contentColor: Colors.red,
                        textStyle: TextStyle(
                            color: Colors.white
                        )
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Text(
                      'Gönder',
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: Text(
                'Zaten Üye Misin? Giriş Yap',
                style: TextStyle(
                    fontSize: 16
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
