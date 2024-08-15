// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:medi_alert/utils/colors.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:provider/provider.dart';

import '../../model/appointment.dart';

class AddDataPage extends StatefulWidget {
  final DateTime date;

  AddDataPage({required this.date});

  @override
  _AddDataPageState createState() => _AddDataPageState();
}

class _AddDataPageState extends State<AddDataPage> {
  final TextEditingController _oxygenSaturationController =
      TextEditingController();
  final TextEditingController _supplementalOxygenController =
      TextEditingController();

  String _oxygenTherapy = 'Not set';
  String _readingMethod = 'Not set';
  String _measurementType = 'Not set';

  @override
  void dispose() {
    _oxygenSaturationController.dispose();
    _supplementalOxygenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Data'),
        actions: [
          TextButton(
            onPressed: _saveData,
            child: Text('Save', style: TextStyle(color: BLACK)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text('Time'),
              trailing: Text('Today, ${TimeOfDay.now().format(context)}'),
            ),
            Divider(),
            ListTile(
              title: Text('Oxygen saturation'),
              trailing: TextButton(
                onPressed: () {
                  _showOxygenSaturationInput();
                },
                child: Text('Add %'),
              ),
            ),
            Divider(),
            ListTile(
              title: Text('Supplemental oxygen'),
              trailing: TextButton(
                onPressed: () {
                  _showSupplementalOxygenInput();
                },
                child: Text('Add L/min'),
              ),
            ),
            ListTile(
              title: Text('Oxygen therapy'),
              trailing: TextButton(
                onPressed: () {
                  _showBottomSheet(
                      'Oxygen Therapy', ['Not set', 'Nasal Cannula'], (value) {
                    setState(() {
                      _oxygenTherapy = value;
                    });
                  });
                },
                child: Text(_oxygenTherapy),
              ),
            ),
            Divider(),
            ListTile(
              title: Text('Reading method'),
              trailing: TextButton(
                onPressed: () {
                  _showBottomSheet(
                      'Reading Method', ['Not set', 'Pulse oximetry (SpO2)'],
                      (value) {
                    setState(() {
                      _readingMethod = value;
                    });
                  });
                },
                child: Text(_readingMethod),
              ),
            ),
            Divider(),
            ListTile(
              title: Text('Measurement type'),
              trailing: TextButton(
                onPressed: () {
                  _showBottomSheet('Measurement Type',
                      ['Not set', 'Peripheral capillaries (SpO2)'], (value) {
                    setState(() {
                      _measurementType = value;
                    });
                  });
                },
                child: Text(_measurementType),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOxygenSaturationInput() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Oxygen Saturation (%)'),
          content: TextField(
            controller: _oxygenSaturationController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "0-100"),
            onChanged: (value) {
              if (int.tryParse(value) != null && int.parse(value) > 100) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('Oxygen Saturation should not be more than 100'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                _oxygenSaturationController.clear();
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showSupplementalOxygenInput() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Supplemental Oxygen (L/min)'),
          content: TextField(
            controller: _supplementalOxygenController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "L/min"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showBottomSheet(
      String title, List<String> options, Function(String) onSelect) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: options.map((option) {
            return ListTile(
              title: Text(option),
              onTap: () {
                onSelect(option);
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  void _saveData() {
    final oxygenSaturation = _oxygenSaturationController.text;
    final supplementalOxygen = _supplementalOxygenController.text;

    final newAppointment = Appointment(
      startTime: widget.date,
      endTime: widget.date.add(Duration(minutes: 30)),
      subject: 'Oxygen Saturation: $oxygenSaturation%, '
          'Supplemental Oxygen: $supplementalOxygen L/min, '
          'Therapy: $_oxygenTherapy, '
          'Method: $_readingMethod, '
          'Type: $_measurementType',
      color: Colors.blue,
    );

    // Save to provider
    context.read<AppointmentProvider>().addAppointment(newAppointment);

    // Return the new appointment to the previous page
    Navigator.pop(context, newAppointment);
  }
}
