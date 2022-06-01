import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:project_praktikum/api/surah_api.dart';
import 'package:project_praktikum/model/bookmark_model.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class DetailSurah extends StatefulWidget {
  final String? engName; final int? number, ayah;
  const DetailSurah({Key? key, this.engName, this.number, this.ayah}) : super(key: key);

  @override
  State<DetailSurah> createState() => _DetailSurahState();
}

class _DetailSurahState extends State<DetailSurah> {
  final _bookmark = Hive.box<BookmarkModel>('bookmark');
  final _lastRead = Hive.box<BookmarkModel>('last_read');
  final ItemScrollController itemScrollController = ItemScrollController();
  final arabicNumber = ArabicNumbers();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.engName.toString()),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Expanded(child: _buildDataList())]
      ),
    );
  }

  Widget _buildDataList() {
    return FutureBuilder(
        future: getSurah(widget.number!.toString()),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return _buildSuccess(snapshot);
          } else if (snapshot.hasError) {
            debugPrint('${snapshot.error}');
            return Text('${snapshot.error}');
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Center(
                child: CircularProgressIndicator(),
              )
            ],
          );
        }
    );
  }

  Widget _buildSuccess(snapshot) {
    return ScrollablePositionedList.builder(
        initialScrollIndex: widget.ayah != null? widget.ayah! - 1 : 0,
        itemBuilder: (BuildContext context, int index) {
        return Container(
          color: (index % 2 == 0) ? Colors.transparent : Colors.blueGrey.shade50,
          child: Column(
            children: [
              snapshot.data?.number[index] == 1
                  ? _buildBasmallah()
                  : const SizedBox(height: 0),
              InkWell(
                onTap: () {
                  showModalBottomSheet(context: context, builder: (BuildContext bc) {
                    return Container(
                        padding: const EdgeInsets.all(15),
                        child: Wrap(
                          children: [
                            Center(child: Text('QS. ${widget.engName}: Ayah ${snapshot.data?.number[index]}')),
                            InkWell(
                              onTap: () {
                                DateTime today = DateTime.now();
                                String date = "${today.day}/${today.month}/${today.year} ${today.hour}:${today.minute}";
                                final bookmark = BookmarkModel(
                                    numberSurah: widget.number,
                                    surah: widget.engName,
                                    numberAyah: snapshot.data?.number[index],
                                    juz: snapshot.data?.juz[index],
                                    date: date,
                                    numberAyahs: snapshot.data?.numberAyahs[index],
                                );
                                _bookmark.add(bookmark);
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
                                    numberSurah: widget.number,
                                    surah: widget.engName,
                                    numberAyah: snapshot.data?.number[index],
                                    juz: snapshot.data?.juz[index],
                                    date: date,
                                    numberAyahs: snapshot.data?.numberAyahs[index]
                                );
                                _lastRead.put('read', lastRead);
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
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text(
                        arabicNumber.convert(snapshot.data?.number[index]),
                        style: const TextStyle(fontSize: 20)
                    )],
                  ),
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: snapshot.data?.number[index] == 1
                        ? _splitString(snapshot.data?.surah[index])
                        : Text('${snapshot.data?.surah[index]}',
                        textAlign: TextAlign.right, style: const TextStyle(fontSize: 25)),

                  ),
                  subtitle: Text('${snapshot.data?.trans[index]}'),
                ),
              )
            ],
          ),
        );
      },
      itemCount: snapshot.data.number.length,
    );
  }

  Widget _buildBasmallah(){
    return (
        Container(
          decoration: BoxDecoration(
            // border: Border.all(color: Colors.blueGrey),
            color: Colors.blueGrey.shade100,
          ),
          padding: const EdgeInsets.symmetric(vertical: 12.0),
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
}
