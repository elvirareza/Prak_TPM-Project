import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:project_praktikum/model/surah_model.dart';

Future getSurahList() async {
  final response = await http
      .get(Uri.parse('https://api.alquran.cloud/v1/surah'));

  Map<String, dynamic> jsonBody = json.decode(response.body);

  if(jsonBody['code'] == 200) {
    Iterable data = jsonBody['data'];
    List<SurahList> surahList = data.map((e) => SurahList.fromJson(e)).toList();

    return surahList;
  }else {
    debugPrint('Error Response');
    throw Exception('Failed to load surah');
  }
}

Future getSurah(String number) async {
  var value = <Map<String, dynamic>>[];

  final response = await Future.wait([
      http
        .get(Uri.parse('https://api.alquran.cloud/v1/surah/$number')),
      http
      .get(Uri.parse('https://api.alquran.cloud/v1/surah/$number/en.asad')),
  ]);

  for(var res in response) {
    if(res.statusCode != 200) throw Exception('Failed to load surah');
    value.add(jsonDecode(res.body));
  }

  List num = []; List surah = []; List juz = []; List numberAyahs = [];
  for(var val in value[0]['data']['ayahs']) {
    num.add(val['numberInSurah']);
    numberAyahs.add(val['number']);
    surah.add(val['text']);
    juz.add(val['juz']);
  }

  List trans = [];
  for(var val in value[1]['data']['ayahs']) {
    trans.add(val['text']);
  }

  Surah surahs = Surah(
    number: num,
    numberAyahs: numberAyahs,
    surah: surah,
    trans: trans,
    juz: juz,
  );

  return surahs;
}