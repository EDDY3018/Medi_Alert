import 'package:flutter/material.dart';

class VitalsPage extends StatefulWidget {
  const VitalsPage({super.key});

  @override
  State<VitalsPage> createState() => _VitalsPageState();
}

class _VitalsPageState extends State<VitalsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VitalsPage'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'VitalsPage is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
