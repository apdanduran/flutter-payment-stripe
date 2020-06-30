import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/app/hata_exception.dart';
import 'package:flutterapp/common_widget/platform_duyarli_alert_dialog.dart';
import 'package:flutterapp/common_widget/social_login_button.dart';
import 'package:flutterapp/model/user.dart';
import 'package:flutterapp/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

enum FormType { Register, Login }

class EmailveSifreLoginPage extends StatefulWidget {
  @override
  _EmailveSifreLoginPageState createState() => _EmailveSifreLoginPageState();
}

class _EmailveSifreLoginPageState extends State<EmailveSifreLoginPage> {
  String _email, _sifre;
  String _butonText, _linkText;
  var _formType = FormType.Login;

  final _formKey = GlobalKey<FormState>();

  void _formitSubmit() async {
    _formKey.currentState.save();
    debugPrint("email :" + _email + "sifre:" + _sifre);
    final _userModel = Provider.of<UserModel>(context);

    if (_formType == FormType.Login) {
      try {
        User _girisYapanUser =
            await _userModel.signInWithEmailAndPassword(_email, _sifre);
        if (_girisYapanUser != null)
          print("Widget giriş yapan user id: " +
              _girisYapanUser.userID.toString());
      } on PlatformException catch (e) {
        PlatformDuyarliAlertDialog(
          baslik: "HATA",
          icerik: Hatalar.goster(e.code),
          anaButonYazisi: "Tamam",
        ).goster(context);
      }
    } else {
      try {
        User _olusturulanUser =
            await _userModel.createUserWithEmailAndPassword(_email, _sifre);
        if (_olusturulanUser != null)
          print(
              "Widget Kaydolan user id: " + _olusturulanUser.userID.toString());
      } on PlatformException catch (e) {
        PlatformDuyarliAlertDialog(
          baslik: "HATA",
          icerik: Hatalar.goster(e.code),
          anaButonYazisi: "Tamam",
        ).goster(context);
      }
    }
  }

  void _degistir() {
    setState(() {
      _formType =
          _formType == FormType.Login ? FormType.Register : FormType.Login;
    });
  }

  @override
  Widget build(BuildContext context) {
    _butonText = _formType == FormType.Login ? "Giriş Yap" : "Kayıt Ol";
    _linkText = _formType == FormType.Login
        ? "Hesabınız Yok Mu? Kayıt Olun"
        : "Hesabınız Var mı? Giriş Yapın";

    final _userModel = Provider.of<UserModel>(context);

    if (_userModel.user != null) {
      Future.delayed(Duration(milliseconds: 10), () {
        Navigator.of(context).pop();
      });
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Giriş / Kayıt"),
        ),
        body: _userModel.state == ViewState.Idle
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        /*    if (_formType == FormType.Register) ...[
                          TextFormField(
                            initialValue: "sehir",
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              errorText: _userModel.emailHataMesaji != null
                                  ? _userModel.emailHataMesaji
                                  : null,
                              prefixIcon: Icon(Icons.mail),
                              hintText: 'deneme',
                              labelText: 'deneme',
                              border: OutlineInputBorder(),
                            ),
                            onSaved: (String girilenSehir) {
                              _sehir = girilenSehir;
                            },
                          ),
                        ],*/
                        Image(
                          width: 150,
                          height: 150,
                          image: AssetImage(
                            "assets/logo.jpg",
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "DNC STUDIO",
                          style: TextStyle(fontSize: 50, color: Colors.purple),
                        ),
                        FlatButton(
                          onPressed: () => _degistir(),
                          child: Text(
                            _linkText,
                            style: TextStyle(
                                color: Colors.orange.shade900, fontSize: 20),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        TextFormField(
                          initialValue: "",
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            errorText: _userModel.emailHataMesaji != null
                                ? _userModel.emailHataMesaji
                                : null,
                            prefixIcon: Icon(Icons.mail),
                            hintText: 'Email',
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                          onSaved: (String girilenEmail) {
                            _email = girilenEmail;
                          },
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                            initialValue: "",
                            obscureText: true,
                            decoration: InputDecoration(
                              errorText: _userModel.sifreHataMesaji != null
                                  ? _userModel.sifreHataMesaji
                                  : null,
                              prefixIcon: Icon(Icons.email),
                              hintText: 'Şifre',
                              labelText: 'Şifre',
                              border: OutlineInputBorder(),
                            ),
                            onSaved: (String girilenSifre) {
                              _sifre = girilenSifre;
                            }),
                        SizedBox(
                          height: 8,
                        ),
                        SocialLoginButton(
                          butonText: _butonText,
                          butonColor: Theme.of(context).primaryColor,
                          radius: 10,
                          onPressed: () => _formitSubmit(),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
