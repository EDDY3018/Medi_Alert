import 'package:flutter/material.dart';

class AddDataPage extends StatefulWidget {
  @override
  _AddDataPageState createState() => _AddDataPageState();
}

class _AddDataPageState extends State<AddDataPage> {
  String _oxygenSaturation = '';
  String _supplementalOxygen = '';
  String _oxygenTherapy = '';
  String _readingMethod = '';
  String _measurementType = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Data'),
        actions: [
          TextButton(
            onPressed: () {
              // Implement save functionality here
            },
            child: Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text('Time'),
              subtitle: Text('Today, ${TimeOfDay.now().format(context)}'),
            ),
            Divider(),
            ListTile(
              title: Text('Oxygen saturation'),
              trailing: TextButton(
                onPressed: () {
                  // Implement add percentage functionality here
                },
                child: Text('Add %'),
              ),
            ),
            Divider(),
            ListTile(
              title: Text('Supplemental oxygen'),
              trailing: TextButton(
                onPressed: () {
                  // Implement add L/min functionality here
                },
                child: Text('Add L/min'),
              ),
            ),
            ListTile(
              title: Text('Oxygen therapy'),
              trailing: TextButton(
                onPressed: () {
                  // Implement select functionality here
                },
                child: Text('Select'),
              ),
            ),
            Divider(),
            ListTile(
              title: Text('Reading method'),
              trailing: TextButton(
                onPressed: () {
                  // Implement select functionality here
                },
                child: Text('Select'),
              ),
            ),
            Divider(),
            ListTile(
              title: Text('Measurement type'),
              trailing: TextButton(
                onPressed: () {
                  // Implement select functionality here
                },
                child: Text('Select'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
