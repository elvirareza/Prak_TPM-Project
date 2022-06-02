import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project_praktikum/api/surah_api.dart';
import 'package:project_praktikum/feature/detail_surah_page.dart';
import 'package:project_praktikum/tools/menu_tools.dart';

class SurahPage extends StatefulWidget {
  const SurahPage({Key? key}) : super(key: key);

  @override
  State<SurahPage> createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  final String label = 'Surah';

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
      ),
    );
  }

  Widget _buildDataList() {
    return FutureBuilder(
      future: getSurahList(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return _buildSuccess(snapshot);
        } else if (snapshot.hasError) {
          debugPrint('${snapshot.error}');
          return Text('${snapshot.error}');
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
          ],
        );
      }
    );
  }

  Widget _buildSuccess(snapshot) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(context, PageTransition(type: PageTransitionType.fade,
                    child: DetailSurah(engName: snapshot.data[index].engName, number: snapshot.data[index].number)));
              },
              child: ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text('${snapshot.data?[index].number}')],
                ),
                title: Text('${snapshot.data?[index].engName}'),
                subtitle: Text('${snapshot.data?[index].type} | ${snapshot.data?[index].ayah} ayahs'),
                trailing: Text('${snapshot.data?[index].name}', textAlign: TextAlign.right,),
              ),
            ),
            Divider(height: 3, color: Colors.blueGrey[50])
          ],
        );
      },
      itemCount: snapshot.data.length,
    );
  }
}
