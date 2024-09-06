// ignore_for_file: prefer_const_declarations, prefer_const_constructors, prefer_const_literals_to_create_immutables

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
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  blurRadius: 2,
                  spreadRadius: 2,
                  color: const Color.fromARGB(76, 210, 213, 221),
                  offset: Offset.zero)
            ]),
            child: ListTile(
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
          ),
          SizedBox(height: 15),
          Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  blurRadius: 2,
                  spreadRadius: 2,
                  color: const Color.fromARGB(76, 210, 213, 221),
                  offset: Offset.zero)
            ]),
            child: ListTile(
              leading: Icon(Icons.local_hospital),
              title: Text('Call Ambulance\n 193'),
              onTap: () async {
                final phoneUrl = 'tel:193';
                if (await canLaunch(phoneUrl)) {
                  await launch(phoneUrl);
                } else {
                  throw 'Could not launch $phoneUrl';
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
