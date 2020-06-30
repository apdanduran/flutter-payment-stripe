import 'package:flutter/material.dart';
import 'package:flutterapp/app/Konusma.dart';
import 'package:flutterapp/app/konusmalarim_page.dart';
import 'package:flutterapp/common_widget/platform_duyarli_alert_dialog.dart';
import 'package:flutterapp/model/ilan.dart';
import 'package:flutterapp/model/user.dart';
import 'package:flutterapp/services/payment_services.dart';
import 'package:flutterapp/viewmodel/user_model.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class IlanlarPage extends StatefulWidget {
  @override
  _IlanlarPageState createState() => _IlanlarPageState();
}

class _IlanlarPageState extends State<IlanlarPage> {
  @override
  void initState() {
    super.initState();
    StripeService.init();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    UserModel _userModel = Provider.of<UserModel>(context);
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text(
          "İlanlar",
          style: TextStyle(color: Colors.white),
        ),
        leading: FlatButton(
          onPressed: () => _KonusmalarimPage(context),
          child: Icon(
            Icons.mail,
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () => _cikisIcinOnayIste(context),
            child: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Ilan>>(
        future: _userModel.getAllUser(),
        builder: (context, sonuc) {
          if (sonuc.hasData) {
            var tumIlanlar = sonuc.data;
            if (tumIlanlar.length > 0) {
              return RefreshIndicator(
                onRefresh: _yenile,
                child: ListView.builder(
                  itemCount: tumIlanlar.length,
                  itemBuilder: (context, index) {
                    var oankiIlan = sonuc.data[index];
                    if (oankiIlan.userID != _userModel.user.userID) {
                      return GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: height / 2,
                              width: 300,
                              child: Card(
                                child: Image.network(
                                  oankiIlan.postURL,
                                  fit: BoxFit.fill,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                elevation: 5,
                                margin: EdgeInsets.all(10),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  bottom: 30.0, top: 10, left: 10, right: 10),
                              padding: EdgeInsets.all(1.0),
                              decoration: BoxDecoration(
                                  color: Colors.purple.shade50,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15.0),
                                  ),
                                  border: Border.all(
                                      color: Colors.purple.shade100)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(left: 20.0),
                                    child: Text(
                                      oankiIlan.aciklama,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        FlatButton(
                                          onPressed: () => message(
                                              context,
                                              _userModel.user,
                                              oankiIlan.userID),
                                          child: Icon(
                                            Icons.mail,
                                            color: Colors.black,
                                          ),
                                        ),
                                        FlatButton(
                                          onPressed: () =>
                                              satinAl(context, oankiIlan.fiyat),
                                          child: Icon(
                                            Icons.add_shopping_cart,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    } else {
                      Container();
                    }
                  },
                ),
              );
            } else {
              return Center(
                child: Text("Kayıtlı bir ilan yok"),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future _cikisIcinOnayIste(BuildContext context) async {
    final sonuc = await PlatformDuyarliAlertDialog(
      baslik: "Emin misiniz ?",
      icerik: "Çıkmak istediğinizden emin misiniz ?",
      anaButonYazisi: "Evet",
      iptalButonYazisi: "Vazgeç",
    ).goster(context);
    if (sonuc == true) {
      _cikisYap(context);
    }
  }

  Future<bool> _cikisYap(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context);
    bool sonuc = await _userModel.signOut();
    return sonuc;
  }

  Future<Null> _yenile() async {
    setState(() {});
    await Future.delayed(Duration(seconds: 1));
    return null;
  }

  satinAl(BuildContext context, fiyat) async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    var response =
        await StripeService.payWithNewCard(amount: '15000', currency: 'USD');
    await dialog.hide();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(response.message),
      duration:
          new Duration(milliseconds: response.success == true ? 1200 : 3000),
    ));
  }

  message(BuildContext context, User user, String ilan) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => Konusma(
          currentUser: user,
          sohbetEdilenUser: ilan,
        ),
      ),
    );
  }

  _KonusmalarimPage(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);

    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => KonusmalarimPage(),
      ),
    );
  }
}
