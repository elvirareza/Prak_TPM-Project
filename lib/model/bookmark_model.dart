import 'package:hive/hive.dart';

part 'bookmark_model.g.dart';

@HiveType(typeId: 0)
class BookmarkModel extends HiveObject {
  BookmarkModel({
    required this.numberSurah,
    required this.surah,
    required this.numberAyah,
    required this.juz,
    required this.date,
    required this.numberAyahs,
  });

  @HiveField(0)
  int? numberSurah;

  @HiveField(1)
  String? surah;

  @HiveField(2)
  int? numberAyah;

  @HiveField(3)
  int? juz;

  @HiveField(4)
  String? date;

  @HiveField(5)
  int? numberAyahs;
}