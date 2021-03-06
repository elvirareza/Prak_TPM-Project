import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project_praktikum/api/juz_api.dart';
import 'package:project_praktikum/feature/detail_juz_page.dart';
import 'package:project_praktikum/model/juz_model.dart';
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
      body: Column(
        children: [
          Menu(label: label),
          Expanded(child: _buildDataList()),
        ],
      )
    );
  }

  Widget _buildDataList() {
    return LayoutBuilder(builder: (context, constraints) {
      return GridView.builder(
        itemCount: 30,
        itemBuilder: (context, index) => _buildItem(index+1),
        padding: EdgeInsets.all(5.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: constraints.maxWidth > 700 ? 6 : 3,
          childAspectRatio: 2,
        ),
      );
    });
  }

  Widget _buildItem(int index) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(context, PageTransition(type: PageTransitionType.fade,
              child: DetailJuz(number: index)));
        },
        child: Center(
          child: Text("Juz $index"),
        ),
      )
    );
  }
}
