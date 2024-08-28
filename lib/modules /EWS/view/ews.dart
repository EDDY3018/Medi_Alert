import 'package:flutter/material.dart';

import '../models/ewsModel.dart';

class EarlyWarningSignPage extends StatelessWidget {
  final EarlyWarningSign ews;

  EarlyWarningSignPage({required this.ews});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Early Warning Signs'),
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
    );
  }
}
