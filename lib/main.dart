import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project_praktikum/feature/surah_page.dart';

import 'model/bookmark_model.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(BookmarkModelAdapter());
  await Hive.openBox<BookmarkModel>('bookmark');
  await Hive.openBox<BookmarkModel>('last_read');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Al-Quran',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String _urlImage = 'https://www.seekpng.com/png/full/411-4111212_al-quran-kareem-png.png';

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3),
            ()=>Navigator.pushReplacement(context,
            PageTransition(child: const SurahPage(), type: PageTransitionType.fade)
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Center(
          child: Image.network(_urlImage, height: 200),
        )
    );
  }
}