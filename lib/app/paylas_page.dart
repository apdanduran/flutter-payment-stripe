import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutterapp/common_widget/platform_duyarli_alert_dialog.dart';
import 'package:flutterapp/common_widget/social_login_button.dart';
import 'package:flutterapp/model/ilan.dart';
import 'package:flutterapp/viewmodel/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class PaylasPage extends StatefulWidget {
  @override
  _PaylasPageState createState() => _PaylasPageState();
}

class _PaylasPageState extends State<PaylasPage> {
  final _formKey = GlobalKey<FormState>();
  File _profilFoto;

  final focus = FocusNode();
  TextEditingController _controllerBio;
  TextEditingController _fiyatGir;

  @override
  void initState() {
    super.initState();
    _controllerBio = TextEditingController();
    _fiyatGir = TextEditingController();
  }

  @override
  void dispose() {
    _controllerBio.dispose();
    _fiyatGir.dispose();
    super.dispose();
  }

  final FocusNode aciklama = FocusNode();
  final FocusNode fiyat = FocusNode();

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);
    print("edit profildeki user degerleri :" + _userModel.user.toString());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        centerTitle: true,
        title: new Text(
          "Ürün ilanı",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        behavior: HitTestBehavior.opaque,
        onPanDown: (_) {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 25.0),
                    child: _profilFoto == null
                        ? FlatButton(
                            onPressed: () => {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      height: 160,
                                      child: Column(
                                        children: <Widget>[
                                          ListTile(
                                            leading: Icon(Icons.camera),
                                            title: Text("Kamera"),
                                            onTap: () {
                                              _kameradanFotoCek();
                                            },
                                          ),
                                          ListTile(
                                            leading: Icon(Icons.image),
                                            title: Text("Galeri"),
                                            onTap: () {
                                              _galeridenResimSec();
                                            },
                                          )
                                        ],
                                      ),
                                    );
                                  })
                            },
                            child: Padding(
                              padding: EdgeInsets.only(left: 60.0, top: 50),
                              child: Icon(
                                Icons.add_shopping_cart,
                                color: Colors.purple,
                                size: 150.0,
                              ),
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.only(left: 20, top: 40),
                            child: Container(
                              height: 250,
                              child: Card(
                                child: new Container(
                                  decoration: new BoxDecoration(
                                    image: new DecorationImage(
                                      colorFilter: new ColorFilter.mode(
                                          Colors.black.withOpacity(1),
                                          BlendMode.dstATop),
                                      image: FileImage(_profilFoto),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                elevation: 5,
                                margin: EdgeInsets.all(10),
                              ),
                            ),
                          ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: _controllerBio,
                    textInputAction: TextInputAction.next,
                    focusNode: aciklama,
                    onFieldSubmitted: (term) {
                      _fieldFocusChange(context, aciklama, fiyat);
                    },
                    style: TextStyle(fontSize: 18.0),
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.add_comment,
                        size: 30.0,
                        color: Colors.purple,
                      ),
                      hintText: "Ne Satıyorsun?",
                      hintStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                    ),
                    validator: (input) => input.trim().length > 150
                        ? 'Lütfen 150 karakterden az giriniz.'
                        : null,
                    onSaved: (input) => _controllerBio.text = input,
                  ),
                  TextFormField(
                    controller: _fiyatGir,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    focusNode: fiyat,
                    onFieldSubmitted: (value) {
                      fiyat.unfocus();
                    },
                    style: TextStyle(fontSize: 18.0),
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.attach_money,
                        size: 30.0,
                        color: Colors.purple,
                      ),
                      hintText: "Fiyatı Girin",
                      hintStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                    ),
                    onSaved: (input) => _fiyatGir.text = input,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SocialLoginButton(
                      butonText: 'Paylaş',
                      butonColor: Theme.of(context).primaryColor,
                      radius: 10,
                      onPressed: () => {
                        _profilFotoGuncelle(context),
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _profilFotoGuncelle(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context);
    if (_profilFoto != null) {
      _formKey.currentState.save();
      Ilan kaydedilecekIlan = Ilan(
        aciklama: _controllerBio.text,
        userID: _userModel.user.userID,
        fiyat: _fiyatGir.text,
        postURL: _profilFoto.toString(),
      );
      ProgressDialog dialog = new ProgressDialog(context);
      dialog.style(message: 'Please wait...');
      await dialog.show();
      var url = await _userModel.uploadFile(
          _userModel.user.userID, _profilFoto, kaydedilecekIlan);
      print("gelen url" + url);
      await dialog.hide();

      if (url != null) {
        setState(() {
          _controllerBio.text = "";
          _profilFoto = null;
          _fiyatGir.text = "";
        });
      }
    } else {
      PlatformDuyarliAlertDialog(
        baslik: "Uyarı ",
        icerik: "Fotoğraf seçmediniz",
        anaButonYazisi: "Tamam",
        iptalButonYazisi: "",
      ).goster(context);
    }
  }

  void _kameradanFotoCek() async {
    var _yeniResim = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _profilFoto = _yeniResim;
    });
    Navigator.of(context).pop();
  }

  void _galeridenResimSec() async {
    var _yeniResim = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _profilFoto = _yeniResim;
    });
    Navigator.of(context).pop();
  }
}
