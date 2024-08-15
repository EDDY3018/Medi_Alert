import 'package:flutter/material.dart';
import 'package:share/share.dart';

class BPMRecord {
  final DateTime timestamp;
  final int bpm;

  BPMRecord({required this.timestamp, required this.bpm});
}

class HistoryPage extends StatefulWidget {
  final List<BPMRecord> history;

  const HistoryPage({Key? key, required this.history}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  void _deleteRecord(int index) {
    setState(() {
      widget.history.removeAt(index);
    });
  }

  void _shareRecord(BPMRecord record) {
    final text = 'BPM: ${record.bpm} measured on ${record.timestamp}';
    Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BPM History'),
      ),
      body: widget.history.isEmpty
          ? const Center(
              child: Text('No records found.'),
            )
          : ListView.builder(
              itemCount: widget.history.length,
              itemBuilder: (context, index) {
                final record = widget.history[index];
                return Card(
                  child: ListTile(
                    title: Text('BPM: ${record.bpm}'),
                    subtitle: Text('Measured on: ${record.timestamp}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.share),
                          onPressed: () => _shareRecord(record),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteRecord(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
