// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:medi_alert/utils/colors.dart';

class BottomSheetContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
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
            title: Text('Call Emergency Health Personal'),
            onTap: () {
              // Implement call functionality
            },
          ),
          ListTile(
            leading: Icon(Icons.local_hospital),
            title: Text('Call Ambulance'),
            onTap: () {
              // Implement call functionality
            },
          ),
        ],
      ),
    );
  }
}

