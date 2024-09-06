// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:medi_alert/modules%20/Vitals/view/widgets/respositeryRate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../../../../utils/navigator.dart';
import '../vitals_page.dart';

class RespiratoryRateHistoryPage extends StatefulWidget {
  @override
  _RespiratoryRateHistoryPageState createState() =>
      _RespiratoryRateHistoryPageState();
}

class _RespiratoryRateHistoryPageState
    extends State<RespiratoryRateHistoryPage> {
  Future<List<String>> _getRespiratoryRateHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history =
        prefs.getStringList('respiratory_rate_history') ?? [];
    return history.reversed
        .toList(); // Reverse the list to show recent entries first
  }

  Future<void> _deleteHistoryItem(int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history =
        prefs.getStringList('respiratory_rate_history') ?? [];
    history = history.reversed
        .toList(); // Reverse before deleting to match displayed order
    if (index >= 0 && index < history.length) {
      history.removeAt(index);
      await prefs.setStringList(
          'respiratory_rate_history', history.reversed.toList());
      setState(() {}); // Refresh the list
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
       onWillPop: () async {
        customNavigator(context, RespiratoryRatePage());

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Respiratory Rate History'),
           leading: IconButton(
            onPressed: () {
              customNavigator(context, RespiratoryRatePage());
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: FutureBuilder<List<String>>(
          future: _getRespiratoryRateHistory(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No history available.'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(snapshot.data![index]),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        final confirmDelete = await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Confirm Deletion'),
                              content: Text(
                                  'Are you sure you want to delete this entry?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: Text('Delete'),
                                ),
                              ],
                            );
                          },
                        );
      
                        if (confirmDelete == true) {
                          await _deleteHistoryItem(index);
                        }
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

Future<void> _saveRespiratoryRateToHistory(int rate) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> history = prefs.getStringList('respiratory_rate_history') ?? [];

  // Format the time as 'hh:mm a'
  String formattedTime = DateFormat('hh:mm a').format(DateTime.now());

  // Add the respiratory rate with the formatted time to the history list
  history.add('Respiratory Rate: $rate breaths per minute - $formattedTime');
  await prefs.setStringList('respiratory_rate_history', history);
}
