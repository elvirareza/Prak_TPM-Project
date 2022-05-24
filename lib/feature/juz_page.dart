import 'package:flutter/material.dart';
import 'package:project_praktikum/tools/menu_tools.dart';

class JuzPage extends StatefulWidget {
  const JuzPage({Key? key}) : super(key: key);

  @override
  State<JuzPage> createState() => _JuzPageState();
}

class _JuzPageState extends State<JuzPage> {
  final String label = 'Juz';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Al-Quran'),
      ),
      body: Menu(label: label),
    );
  }
}
