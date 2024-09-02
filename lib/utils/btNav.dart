// ignore_for_file: use_key_in_widget_constructors, no_leading_underscores_for_local_identifiers, prefer_const_constructors

import 'package:medi_alert/modules%20/Settings/view/settings_page.dart';
import 'package:medi_alert/modules%20/Vitals/view/vitals_page.dart';

import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_plus/persistent_bottom_nav_bar_plus.dart';

import '../modules /home/view/home_page.dart';
import 'colors.dart';
import 'textStyles.dart';

class BTNAV extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<PersistentBottomNavBarItem> _navBarItems = [
      PersistentBottomNavBarItem(
          activeColorPrimary: GREEN,
          inactiveColorPrimary: WHITE,
          inactiveIcon: Icon(
            Icons.dashboard_outlined,
            color: BLACK,
          ),
          icon: Icon(
            Icons.dashboard_outlined,
            color: WHITE,
          ),
          title: "Home",
          textStyle: btBAV),
      PersistentBottomNavBarItem(
          activeColorPrimary: GREEN,
          inactiveColorPrimary: WHITE,
          inactiveIcon: Image.asset(
            'assets/vital.png',
            width: 24,
            height: 24,
            color: WHITE,
          ),
          icon: Image.asset(
            'assets/vital.png',
            width: 24,
            height: 24,
            color: WHITE,
          ),
          title: "Vitals",
          textStyle: btBAV),
      PersistentBottomNavBarItem(
          activeColorPrimary: GREEN,
          inactiveColorPrimary: WHITE,
          inactiveIcon: Image.asset(
            'assets/setting.png',
            width: 24,
            height: 24,
            color: WHITE,
          ),
          icon: Image.asset(
            'assets/setting.png',
            width: 24,
            height: 24,
            color: WHITE,
          ),
          title: "Settings",
          textStyle: btBAV),
    ];

    return PersistentTabView(
      context,
      controller: PersistentTabController(initialIndex: 0),
      screens: _buildScreens(),
      items: _navBarItems,
      confineInSafeArea: true,
      backgroundColor: Color.fromARGB(255, 239, 236, 236),
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBar: false,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(5.0),
      ),
      popAllScreensOnTapOfSelectedTab: false,
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 50),
        curve: Curves.bounceInOut,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.bounceInOut,
        duration: Duration(milliseconds: 200),
      ),
      navBarHeight: 70,
      navBarStyle: NavBarStyle.style4,
    );
  }

  List<Widget> _buildScreens() {
    return [HomePage(), VitalsPage(), SettingsPage()];
    //, SettingsPage()
  }
}
