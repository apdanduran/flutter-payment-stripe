import 'package:flutter/material.dart';

enum TabItem { IlanlarPage, PaylasPage }

class TabItemData {
  final String title;
  final IconData icon;

  TabItemData(this.title, this.icon);
  static Map<TabItem, TabItemData> tumTablar = {
    TabItem.IlanlarPage: TabItemData("İlanlar", Icons.home),
    TabItem.PaylasPage: TabItemData("Paylaş", Icons.add_a_photo),
  };
}
