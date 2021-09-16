import 'dart:convert';

class CSVRecord {
  late String username;
  late String first;
  late String last;
  late String gender;
  late String dob;
  late String language;
  late String bloodType;
  late String zodiac;
  late String constilation;
  late String planet;
  late String tv_genera;
  late String dino;

  CSVRecord(
      {required this.username,
      required this.first,
      required this.last,
      required this.gender,
      required this.dob,
      required this.language,
      required this.bloodType,
      required this.zodiac,
      required this.constilation,
      required this.planet,
      required this.tv_genera,
      required this.dino});

  CSVRecord.fromList(List<dynamic> list) {
    username = list[0];
    first = list[1];
    last = list[2];
    gender = list[3];
    dob = list[4];
    language = list[5];
    bloodType = list[6];
    zodiac = list[7];
    constilation = list[8];
    planet = list[9];
    tv_genera = list[10];
    dino = list[11];
  }

  @override
  String toString() => '''
  CSV Record:
  {
       username: $username,
       first: $first,
       last: $last,
       gender: $gender,
       dob: $dob,
       language: $language,
       blood type: $bloodType,
       zodiac: $zodiac,
       constilation: $constilation,
       planet: $planet,
       tv_genera: $tv_genera,
       dino: $dino
 }
''';
}

class PASSWDRecord {
  late String username;
  late String x;
  late int uid;
  late int gid;
  late String comment;
  late String homeDir;
  late String shellPath;

  PASSWDRecord(
      {required this.username,
      required this.x,
      required this.uid,
      required this.gid,
      required this.comment,
      required this.homeDir,
      required this.shellPath});

  PASSWDRecord.fromList(List<String> list) {
    username = list[0];
    x = list[1];
    uid = int.parse(list[2]);
    gid = int.parse(list[3]);
    comment = list[4];
    homeDir = list[5];
    shellPath = list[6];
  }

  @override
  String toString() => '''
  PASSWDRecord: {
    username: $username, 
    x: $x,
    uid: $uid,
    gid: $gid,
    comment: $comment, 
    homeDir: $homeDir, 
    shellPath: $shellPath
  }
   ''';
}
