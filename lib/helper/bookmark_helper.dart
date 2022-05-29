import 'package:hive/hive.dart';
import 'package:project_praktikum/model/bookmark_model.dart';

Box<BookmarkModel> getBookmark() => Hive.box<BookmarkModel>('bookmark');
Box<BookmarkModel> getLastRead() => Hive.box<BookmarkModel>('last_read');