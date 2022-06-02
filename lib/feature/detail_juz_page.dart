import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:arabic_numbers/arabic_numbers.dart';

import 'package:project_praktikum/api/juz_api.dart';
import 'package:project_praktikum/model/bookmark_model.dart';
import 'package:project_praktikum/model/juz_model.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DetailJuz extends StatefulWidget {
  final int number; final int? numberAyahs;
  const DetailJuz({Key? key, required this.number, this.numberAyahs}) : super(key: key);

  @override
  State<DetailJuz> createState() => _DetailJuzState();
}

class _DetailJuzState extends State<DetailJuz> {
  final _bookmark = Hive.box<BookmarkModel>('bookmark');
  final _lastRead = Hive.box<BookmarkModel>('last_read');
  bool check = false;
  final arabicNumber = ArabicNumbers();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Juz ${widget.number}"),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Expanded(child: _buildData())]
      ),
    );
  }

  Widget _buildData() {
    return FutureBuilder (
        future: getJuz(widget.number),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            JuzModel? juz = JuzModel.fromJson(snapshot.data);
            return _buildDataLists(juz.data!.ayahs);
          } else if (snapshot.hasError) {
            debugPrint('${snapshot.error}');
            return Text('${snapshot.error}');
          }
          return (SizedBox(height: 0,));
        }
    );
  }

  Widget _buildDataLists(List<Ayahs>? data) {
    return FutureBuilder (
        future: getTrans(widget.number),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            JuzModel? juz = JuzModel.fromJson(snapshot.data);
            return _buildDataSuccess(juz.data!.ayahs, data);
          } else if (snapshot.hasError) {
            debugPrint('${snapshot.error}');
            return Text('${snapshot.error}');
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Center(child: (CircularProgressIndicator()))
            ],
          );
        }
    );
  }

  Widget _buildDataSuccess(List<Ayahs>? trans, List<Ayahs>? data) {
    return ScrollablePositionedList.builder(
      initialScrollIndex: widget.numberAyahs != null? _searchData(data) : 0,
      itemCount: data!.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          color: (index % 2 == 0) ? Colors.blueGrey[50] : Colors.grey[50],
          child: Column(
            children: [
              data[index].numberInSurah == 1
                  ? Column(
                      children: [
                        _buildTitle(data[index].surah!),
                        data[index].number == 1  || data[index].surah!.number == 9
                          ? SizedBox(height: 0)
                          : _buildBasmallah()
                      ],
                    )
                  : SizedBox(height: 0),
              InkWell(
                onTap: () {
                  showModalBottomSheet(context: context, builder: (BuildContext bc) {
                    return Container(
                        padding: const EdgeInsets.all(15),
                        child: Wrap(
                          children: [
                            Center(child: Text('QS. ${data[index].surah!.englishName}: Ayah ${data[index].numberInSurah}')),
                            InkWell(
                              onTap: () {
                                DateTime today = DateTime.now();
                                String date = "${today.day}/${today.month}/${today.year} ${today.hour}:${today.minute}";
                                final bookmark = BookmarkModel(
                                  numberSurah: data[index].surah!.number,
                                  surah: data[index].surah!.englishName,
                                  numberAyah: data[index].numberInSurah,
                                  juz: data[index].juz,
                                  date: date,
                                  numberAyahs: data[index].number,
                                );
                                for(var mark in _bookmark.values) {
                                  if(mark.numberAyahs == bookmark.numberAyahs) {
                                    setState(() {
                                      check = true;
                                    });
                                  }
                                }
                                Navigator.pop(context);
                                if(check == false) {
                                  _bookmark.add(bookmark).whenComplete(() =>
                                      Fluttertoast.showToast(
                                          msg: "Added to bookmark",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM
                                      )
                                  );
                                }else {
                                  Fluttertoast.showToast(
                                      msg: "Added to bookmark",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM
                                  );
                                }
                                setState(() {
                                  check = false;
                                });
                              },
                              child: const ListTile(
                                leading: Icon(Icons.add),
                                title: Text('Add to bookmark'),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                DateTime today = DateTime.now();
                                String date = "${today.day}/${today.month}/${today.year} ${today.hour}:${today.minute}";
                                final lastRead = BookmarkModel(
                                  numberSurah: data[index].surah!.number,
                                  surah: data[index].surah!.englishName,
                                  numberAyah: data[index].numberInSurah,
                                  juz: data[index].juz,
                                  date: date,
                                  numberAyahs: data[index].number,
                                );
                                Navigator.pop(context);
                                _lastRead.put('read', lastRead).whenComplete(() =>
                                    Fluttertoast.showToast(
                                      msg: "Saved as last read",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                    )
                                );

                                debugPrint(_lastRead.get('read')!.surah.toString());
                              },
                              child: const ListTile(
                                leading: Icon(Icons.receipt),
                                title: Text('Save as last read'),
                              ),
                            ),
                          ],
                        )
                    );
                  });
                },
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text(
                        arabicNumber.convert(data[index].numberInSurah),
                        style: const TextStyle(fontSize: 20)
                    )],
                  ),
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: data[index].numberInSurah != 1 || data[index].surah!.number == 9
                        ? Text(
                          '${data[index].text}',
                          textAlign: TextAlign.right, style: const TextStyle(fontSize: 25)) :
                          _splitString('${data[index].text}'),
                  ),
                  subtitle: Text('${trans![index].text}'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTitle(Surah data) {
    return Container(
      decoration: BoxDecoration(
        border: Border.symmetric(horizontal: BorderSide(color: Colors.blueGrey.shade300)),
        color: Colors.blueGrey[100],
      ),
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 64.0),
      child: ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("${data.revelationType}")]
        ),
        title: Text("${data.englishName}",
          textAlign: TextAlign.center),
        subtitle: Text("${data.englishNameTranslation}", textAlign: TextAlign.center),
        trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("${data.numberOfAyahs}\nAyah", textAlign: TextAlign.center)]
        ),
      )
    );
  }

  Widget _buildBasmallah(){
    return (
      Container(
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.blueGrey),
          color: Colors.white,
        ),
        padding: EdgeInsets.symmetric(vertical: 12.0),
        child: const ListTile(
            title: Text("بِسْمِ ٱللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ",
              textAlign: TextAlign.center, style: TextStyle(fontSize: 25),)
        ),
      )
    );
  }

  Widget _splitString(String text) {
    String finalText;
    List<String> textList = text.split(" ");
    textList.removeRange(0, 4);
    textList.isEmpty ? finalText = text : finalText = textList.join(" ");
    return Text(finalText, textAlign: TextAlign.right, style: const TextStyle(fontSize: 25));
  }

  int _searchData(List<Ayahs>? data) {
    int i = 0;
    for(var data in data!) {
      if(data.number == widget.numberAyahs) {
        return i;
      }
      i++;
    }
    return 0;
  }
}
