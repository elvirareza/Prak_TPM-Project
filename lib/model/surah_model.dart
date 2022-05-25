class SurahList {
  int? number;
  String? name;
  String? engName;
  int? ayah;
  String? type;

  SurahList({
    this.number,
    this.name,
    this.engName,
    this.ayah,
    this.type,
  });

  factory SurahList.fromJson(Map<String, dynamic> json) {
    return SurahList(
        number: json['number'],
        name: json['name'],
        engName: json['englishName'],
        ayah: json['numberOfAyahs'],
        type: json['revelationType']
    );
  }
}

class Surah {
  List? number;
  List? surah;
  List? trans;
  List? juz;

  Surah({
    this.number,
    this.surah,
    this.trans,
    this.juz,
  });
}