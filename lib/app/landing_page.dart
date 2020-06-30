import "package:flutter/material.dart";
import 'package:flutterapp/app/home_page.dart';
import 'package:flutterapp/app/sign_in/email_sifre_giris_ve_kayit.dart';
import 'package:flutterapp/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context);

    if (_userModel.state == ViewState.Idle) {
      if (_userModel.user == null) {
        return EmailveSifreLoginPage();
      } else {
        return HomePage(user: _userModel.user);
      }
    } else {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
