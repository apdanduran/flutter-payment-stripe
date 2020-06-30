import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/model/ilan.dart';
import 'package:flutterapp/model/mesaj.dart';
import 'package:flutterapp/model/user.dart';
import 'package:flutterapp/viewmodel/user_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Konusma extends StatefulWidget {
  final User currentUser;
  final String sohbetEdilenUser;

  const Konusma({Key key, this.currentUser, this.sohbetEdilenUser})
      : super(key: key);
  @override
  _KonusmaState createState() => _KonusmaState();
}

class _KonusmaState extends State<Konusma> {
  var _mesajController = TextEditingController();
  ScrollController _scrollController = new ScrollController();
  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context);
    User _currentUser = widget.currentUser;
    String _sohbetEdilenUserID = widget.sohbetEdilenUser;
    return Scaffold(
      appBar: AppBar(
        title: Text("Sohbet"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder<List<Mesaj>>(
                stream: _userModel.getMessages(
                  _currentUser.userID,
                  _sohbetEdilenUserID,
                ),
                builder: (context, streamMesajlarListesi) {
                  if (!streamMesajlarListesi.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  var tumMesajlar = streamMesajlarListesi.data;
                  return ListView.builder(
                    controller: _scrollController,
                    itemBuilder: (context, index) {
                      return _konusmaBalonuOlustur(tumMesajlar[index]);
                    },
                    itemCount: tumMesajlar.length,
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 8, left: 8),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: TextField(
                        controller: _mesajController,
                        cursorColor: Colors.blueGrey,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Mesajınızı Yazın",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 4,
                    ),
                    child: FloatingActionButton(
                      elevation: 0,
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.navigation,
                        size: 35,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        if (_mesajController.text.trim().length > 0) {
                          Mesaj _kaydedilecekMesaj = Mesaj(
                            kimden: _currentUser.userID,
                            kime: _sohbetEdilenUserID,
                            bendenMi: true,
                            mesaj: _mesajController.text,
                          );
                          _mesajController.clear();
                          await _userModel.saveMessage(_kaydedilecekMesaj);
                          _scrollController.animateTo(
                            0,
                            curve: Curves.easeInOut,
                            duration: Duration(milliseconds: 100),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _konusmaBalonuOlustur(Mesaj oankiMesaj) {
    Color _gelenMesajRenk = Colors.blue;
    Color _gidenMesajRenk = Theme.of(context).primaryColor;
    var _saatDakikaDegeri = "";

    try {
      _saatDakikaDegeri = _saatDakikaGoster(oankiMesaj.date ?? Timestamp(1, 1));
    } catch (e) {
      print("hata var:" + e.toString());
    }

    var _benimMesajimMi = oankiMesaj.bendenMi;
    if (_benimMesajimMi) {
      return Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: _gidenMesajRenk,
                    ),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(4),
                    child: Text(
                      oankiMesaj.mesaj,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Text(_saatDakikaDegeri),
              ],
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: _gelenMesajRenk,
                    ),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(4),
                    child: Text(oankiMesaj.mesaj),
                  ),
                ),
                Text(_saatDakikaDegeri),
              ],
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      );
    }
  }

  String _saatDakikaGoster(Timestamp date) {
    var _formatter = DateFormat.Hm();
    var _formatlanmisTarih = _formatter.format(date.toDate());
    return _formatlanmisTarih;
  }
}
