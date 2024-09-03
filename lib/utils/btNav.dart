// ignore_for_file: use_key_in_widget_constructors, no_leading_underscores_for_local_identifiers, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:medi_alert/modules%20/Settings/view/settings_page.dart';
import 'package:medi_alert/modules%20/Vitals/view/vitals_page.dart';

import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_plus/persistent_bottom_nav_bar_plus.dart';

import '../modules /home/view/home_page.dart';
import 'colors.dart';
import 'textStyles.dart';

class BTNAV extends StatefulWidget {
  const BTNAV({Key? key, required this.pageIndex}) : super(key: key);
  final int pageIndex;

  @override
  State<BTNAV> createState() => _BTNAVState();
}

class _BTNAVState extends State<BTNAV> {
  final pages = [HomePage(), VitalsPage(), SettingsPage()];

  late int _pageIndex;

  @override
  void initState() {
    super.initState();
    _pageIndex = widget.pageIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_pageIndex],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
            indicatorColor: WHITE,
            labelTextStyle: MaterialStatePropertyAll(TextStyle(
                fontSize: 10,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
                color: WHITE)),
            indicatorShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)))),
        child: NavigationBar(
            height: 63,
            backgroundColor: BLUE,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            animationDuration: Duration(seconds: 1),
            selectedIndex: _pageIndex,
            onDestinationSelected: (pageIndex) =>
                setState(() => _pageIndex = pageIndex),
            destinations: [
              NavigationDestination(
                icon: Icon(
                  Icons.tips_and_updates,
                  color: BLACK,
                ),
                selectedIcon: Icon(
                  Icons.tips_and_updates,
                  color: BLACK,
                ),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.monitor_heart_sharp,
                  color: BLACK,
                ),
                selectedIcon: Icon(
                  Icons.chat,
                  color: Colors.black,
                ),
                label: 'Vitals',
              ),
              NavigationDestination(
                  icon: Icon(
                    Icons.settings,
                    color: BLACK,
                  ),
                  selectedIcon: Icon(
                    Icons.settings,
                    color: BLACK,
                  ),
                  label: 'Settings'),
            ]),
      ),
    );
  }
}
