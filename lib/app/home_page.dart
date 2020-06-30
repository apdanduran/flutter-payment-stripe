import 'package:flutter/material.dart';
import 'package:flutterapp/app/ilanlar_page.dart';
import 'package:flutterapp/app/my_custom_bottom_navi.dart';
import 'package:flutterapp/app/paylas_page.dart';
import 'package:flutterapp/app/tab_items.dart';
import 'package:flutterapp/model/user.dart';

class HomePage extends StatefulWidget {
  final User user;

  HomePage({Key key, @required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.IlanlarPage;

  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.IlanlarPage: GlobalKey<NavigatorState>(),
    TabItem.PaylasPage: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, Widget> tumSayfalar() {
    return {
      TabItem.IlanlarPage: IlanlarPage(),
      TabItem.PaylasPage: PaylasPage(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: MyCustomBottomNavigation(
        sayfaOlusturucu: tumSayfalar(),
        navigatorKeys: navigatorKeys,
        currentTab: _currentTab,
        onSelectedTab: (secilenTab) {
          if (secilenTab == _currentTab) {
            navigatorKeys[secilenTab]
                .currentState
                .popUntil((route) => route.isFirst);
          } else {
            setState(() {
              _currentTab = secilenTab;
            });
          }
        },
      ),
    );
  }
}
