// ignore_for_file: prefer_const_declarations, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:medi_alert/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomSheetContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
          color: WHITE,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Icon(Icons.call),
            title: Text('Call Emergency Health Personal\n 0551215140'),
            onTap: () async {
              final phoneUrl = 'tel:0551215140';
              if (await canLaunch(phoneUrl)) {
                await launch(phoneUrl);
              } else {
                throw 'Could not launch $phoneUrl';
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.local_hospital),
            title: Text('Call Ambulance\n 0249954276'),
            onTap: () async {
              final phoneUrl = 'tel:0249954276';
              if (await canLaunch(phoneUrl)) {
                await launch(phoneUrl);
              } else {
                throw 'Could not launch $phoneUrl';
              }
            },
          ),
        ],
      ),
    );
  }
}
