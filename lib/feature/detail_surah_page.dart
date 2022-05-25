import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:project_praktikum/api/surah_api.dart';
import 'package:project_praktikum/model/bookmark_model.dart';
import 'package:project_praktikum/model/surah_model.dart';

class DetailSurah extends StatefulWidget {
  final SurahList? snapshot;
  const DetailSurah({Key? key, required this.snapshot}) : super(key: key);

  @override
  State<DetailSurah> createState() => _DetailSurahState();
}

class _DetailSurahState extends State<DetailSurah> {
  final _bookmark = Hive.box<BookmarkModel>('bookmark');
  final _lastRead = Hive.box<BookmarkModel>('last_read');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.snapshot!.engName.toString()),
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
        future: getSurah(widget.snapshot!.number.toString()),
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
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            InkWell(
              onTap: () {
                showModalBottomSheet(context: context, builder: (BuildContext bc) {
                  return Container(
                    padding: const EdgeInsets.all(15),
                    child: Wrap(
                      children: [
                        Center(child: Text('QS. ${widget.snapshot!.engName}: Ayah ${snapshot.data?.number[index]}')),
                        InkWell(
                          onTap: () {
                            final bookmark = BookmarkModel(
                                numberSurah: widget.snapshot!.number,
                                surah: widget.snapshot!.engName,
                                numberAyah: snapshot.data?.number[index],
                                juz: snapshot.data?.juz[index],
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
                            final lastRead = BookmarkModel(
                              numberSurah: widget.snapshot!.number,
                              surah: widget.snapshot!.engName,
                              numberAyah: snapshot.data?.number[index],
                              juz: snapshot.data?.juz[index],
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
                  children: [Text('${snapshot.data?.number[index]}')],
                ),
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text('${snapshot.data?.surah[index]}',
                      textAlign: TextAlign.right, style: const TextStyle(fontSize: 25)),
                ),
                subtitle: Text('${snapshot.data?.trans[index]}'),
              ),
            )
          ],
        );
      },
      itemCount: snapshot.data.number.length,
    );
  }
}
