// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:medi_alert/modules%20/Vitals/view/widgets/RRhistory.dart';
import 'package:medi_alert/utils/navigator.dart';

import '../models/ewsModel.dart';

class EarlyWarningSignPage extends StatelessWidget {
  final EarlyWarningSign ews;

  EarlyWarningSignPage({required this.ews});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        customNavigator(context, RespiratoryRateHistoryPage());

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Early Warning Signs'),
          leading: IconButton(
            onPressed: () {
              customNavigator(context, RespiratoryRateHistoryPage());
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('Heart Rate: ${ews.heartRate}'),
              Text('Oxygen Saturation: ${ews.oxygenSaturation}'),
              Text('Respiratory Rate: ${ews.respiratoryRate}'),
              SizedBox(height: 20),
              Text(
                'EWS Score: ${ews.ewsScore}',
                style: TextStyle(
                  fontSize: 24,
                  color: ews.ewsScore > 0 ? Colors.red : Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
