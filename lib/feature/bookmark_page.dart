import 'package:flutter/material.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project_praktikum/feature/detail_juz_page.dart';
import 'package:project_praktikum/helper/bookmark_helper.dart';
import 'package:project_praktikum/tools/menu_tools.dart';
import 'package:material_dialogs/material_dialogs.dart';

import 'detail_surah_page.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({Key? key}) : super(key: key);

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  final String label = 'Bookmark';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Al-Quran'),
      ),
      body: Column(
        children: [
          Menu(label: label),
          Container(child: _buildLastReadList()),
          Divider(height: 3, color: Colors.blueGrey[50]),
          Expanded(child: _buildBookmarkList()),
        ],
      ),
    );
  }

  Widget _buildBookmarkList() {
    final bookmark = getBookmark().values;
    if(bookmark.isEmpty) {
      return const SizedBox(height: 0);
    } else {
      final bookmarks = bookmark.toList();
      return ListView.builder(
      itemCount: bookmarks.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [ index == 0
            ? const ListTile(
                minLeadingWidth : 10,
                leading: Icon(Icons.bookmark),
                title: Text("Bookmark"),
              )
            : const SizedBox(height: 0),
            InkWell(
              onTap: () {
                showModalBottomSheet(context: context, builder: (BuildContext bc) {
                  return Container(
                      padding: const EdgeInsets.all(15),
                      child: Wrap(
                        children: [
                          Center(child: Text('QS. ${bookmarks[index].surah}: Ayah ${bookmarks[index].numberAyah}')),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(context, PageTransition(type: PageTransitionType.fade,
                                  child: DetailSurah(engName: bookmarks[index].surah, number: bookmarks[index].numberSurah,
                                    ayah: bookmarks[index].numberAyah)));
                            },
                            child: const ListTile(
                              leading: Icon(Icons.local_library),
                              title: Text('Read as Surah'),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              debugPrint(bookmarks[index].numberAyahs.toString());
                              Navigator.push(context, PageTransition(type: PageTransitionType.fade,
                                  child: DetailJuz(number: bookmarks[index].juz!, numberAyahs: bookmarks[index].numberAyahs)));
                            },
                            child: const ListTile(
                              leading: Icon(Icons.local_library),
                              title: Text('Read as Juz'),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              Dialogs.materialDialog(
                                  msg: 'Are you sure ? you can\'t undo this',
                                  title: "Delete",
                                  color: Colors.white,
                                  context: context,
                                  actions: [
                                    IconsOutlineButton(
                                      onPressed: () {Navigator.pop(context);},
                                      text: 'Cancel',
                                      iconData: Icons.cancel_outlined,
                                      textStyle: TextStyle(color: Colors.grey),
                                      iconColor: Colors.grey,
                                    ),
                                    IconsButton(
                                      onPressed: () {
                                        getBookmark().deleteAt(index).whenComplete(() =>
                                            setState(() {Navigator.pop(context);}));
                                      },
                                      text: 'Delete',
                                      iconData: Icons.delete,
                                      color: Colors.red,
                                      textStyle: TextStyle(color: Colors.white),
                                      iconColor: Colors.white,
                                    ),
                                  ]);
                            },
                            child: const ListTile(
                              leading: Icon(Icons.delete),
                              title: Text('Delete Bookmark'),
                            ),
                          )
                        ],
                      )
                  );
                });
              },
              child: ListTile(
                minLeadingWidth : 25,
                leading: const Text(""),
                title: Text('QS. ${bookmarks[index].surah} ${bookmarks[index].numberSurah}: Ayah ${bookmarks[index].numberAyah} (Juz ${bookmarks[index].juz})'),
                trailing: Text("${bookmarks[index].date}", textAlign: TextAlign.right, style: const TextStyle(fontSize: 12, color: Colors.blueGrey))
              )
            ),
            Divider(height: 3, color: Colors.blueGrey[50])
          ],
        );
      },
    );
    }
  }

  Widget _buildLastReadList() {
    final get = getLastRead().values;
    if(get.isEmpty) {
      return SizedBox(height: 0);
    } else {
      final lastRead = get.toList();
      return InkWell(
      onTap: (){
        showModalBottomSheet(context: context, builder: (BuildContext bc) {
          return Container(
              padding: const EdgeInsets.all(15),
              child: Wrap(
                children: [
                  Center(child: Text('QS. ${lastRead[0].surah}: Ayah ${lastRead[0].numberAyah}')),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, PageTransition(type: PageTransitionType.fade,
                          child: DetailSurah(engName: lastRead[0].surah, number: lastRead[0].numberSurah,
                              ayah: lastRead[0].numberAyah)));
                    },
                    child: const ListTile(
                      leading: Icon(Icons.local_library),
                      title: Text('Read as Surah'),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      debugPrint(lastRead[0].numberAyahs.toString());
                      Navigator.push(context, PageTransition(type: PageTransitionType.fade,
                          child: DetailJuz(number: lastRead[0].juz!, numberAyahs: lastRead[0].numberAyahs)));
                    },
                    child: const ListTile(
                      leading: Icon(Icons.local_library),
                      title: Text('Read as Juz'),
                    ),
                  ),
                ],
              )
          );
        }
      );},
      child: ListTile(
        minLeadingWidth : 10,
        leading: const Icon(Icons.menu_book),
        title: const Padding(
          padding: EdgeInsets.only(bottom: 4),
          child: Text("Last Read"),
        ),
        subtitle: Text('QS. ${lastRead[0].surah} ${lastRead[0].numberSurah}: Ayah ${lastRead[0].numberAyah} (Juz ${lastRead[0].juz})',
            style: const TextStyle(fontSize: 14, color: Colors.black)),
        trailing: Text("${lastRead[0].date}", textAlign: TextAlign.right, style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
      ),
    );
    }
  }
}
