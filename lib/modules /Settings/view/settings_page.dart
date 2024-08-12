import 'package:flutter/material.dart';
import 'package:medi_alert/modules%20/Vitals/view/widgets/history.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
    List<BPMRecord> _bpmHistory = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SettingsPage'),
        centerTitle: true,
      ),
      body: HistoryPage(history: _bpmHistory)
    );
  }
}
