// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:medi_alert/auth/Login/view/login_page.dart';
import 'package:medi_alert/auth/Profile/views/profile.dart';
import 'package:medi_alert/utils/colors.dart';

import '../modules /Vitals/view/widgets/BPMhistory.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: WHITE,
      child: Column(
        children: <Widget>[
          DrawerHeader(
              decoration: BoxDecoration(),
              child: Container(
                width: double.infinity,
                child: Image.asset(
                  'assets/bgImage.png',
                  fit: BoxFit.contain,
                ),
              )),
          _buildDrawerItem(
            text: 'Profile',
            icon: Icons.person,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfilePage()));
            },
          ),
          SizedBox(height: 20),
          _buildDrawerItem(
            text: 'History',
            icon: Icons.history,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HistoryPage(
                            history: [],
                          )));
            },
          ),
          SizedBox(height: 20),
          _buildDrawerItem(
            text: 'Settings',
            icon: Icons.settings,
            onTap: () {

              Navigator.pop(context);
            },
          ),
          SizedBox(height: 20),
          _buildDrawerItem(
            text: 'Share App',
            icon: Icons.ios_share,
            onTap: () {

              Navigator.pop(context);
            },
          ),
          Spacer(),
          _buildDrawerItem(
            text: 'Logout',
            icon: Icons.logout,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
              // Handle logout
            },
          ),
          SizedBox(height: 20)
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required String text,
    required IconData icon,
    required GestureTapCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon),
        title: Text(text),
        onTap: onTap,
      ),
    );
  }
}
