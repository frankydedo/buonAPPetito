import 'package:flutter/material.dart';

class PreferitiPage extends StatefulWidget {
  const PreferitiPage({super.key});

  @override
  State<PreferitiPage> createState() => _PreferitiPageState();
}

class _PreferitiPageState extends State<PreferitiPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("preferiti")
        ],
      ),
    );
  }
}