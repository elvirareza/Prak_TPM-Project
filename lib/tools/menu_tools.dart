import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project_praktikum/feature/bookmark_page.dart';
import 'package:project_praktikum/feature/juz_page.dart';
import 'package:project_praktikum/feature/surah_page.dart';

class Menu extends StatelessWidget {
  final String label;
  const Menu({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint(label);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: InkWell(
            onTap: () {
              (label != 'Surah')?
                Navigator.pushReplacement(context,
                    PageTransition(
                      child: const SurahPage(),
                      type: PageTransitionType.fade,
                  )
                )
                : null;
            },
            child: Container(
                padding: const EdgeInsets.all(15),
                height: 50,
                decoration: (label == 'Surah')?
                const BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Color(0XFF263238)))) :
                const BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Surah', style: TextStyle(
                        color: (label == 'Surah')? Colors.blueGrey[900] : Colors.grey,
                        fontWeight: (label == 'Surah')? FontWeight.w600 : null),
                    )
                  ],
                )
            ),
          )
        ),
        Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                (label != 'Juz')?
                Navigator.pushReplacement(context,
                    PageTransition(
                      child: const JuzPage(),
                      type: PageTransitionType.fade,
                    )
                )
                : null;
              },
              child: Container(
                  padding: const EdgeInsets.all(15),
                  height: 50,
                  decoration: (label == 'Juz')?
                  const BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Color(0XFF263238)))) :
                  const BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Juz', style: TextStyle(
                          color: (label == 'Juz')? Colors.blueGrey[900] : Colors.grey,
                          fontWeight: (label == 'Juz')? FontWeight.w600 : null),
                      )
                    ],
                  )
              ),
            )
        ),
        Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                (label != 'Bookmark')?
                Navigator.pushReplacement(context,
                    PageTransition(
                      child: const BookmarkPage(),
                      type: PageTransitionType.fade,
                    )
                ) : null;
              },
              child: Container(
                  padding: const EdgeInsets.all(15),
                  height: 50,
                  decoration: (label == 'Bookmark')?
                  const BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Color(0XFF263238)))) :
                  const BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Bookmark', style: TextStyle(
                          color: (label == 'Bookmark')? Colors.blueGrey[900] : Colors.grey,
                          fontWeight: (label == 'Bookmark')? FontWeight.w600 : null),
                      )
                    ],
                  )
              ),
            )
        ),
      ],
    );
  }
}
