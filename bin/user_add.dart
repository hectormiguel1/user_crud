import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:pedantic/pedantic.dart';

void main(List<String> arguments) {
  print('Proccessing Passed Arguements $arguments');
  if (arguments.isEmpty) {
    print('No Arguments Passed, CSV File is required');
    exit(1);
  } else {
    print('Attempting to Open ${arguments.first}!');
    openFile(arguments.first).then((results) {
      print('Loaded ${results.length} fields from CSV');
      print('Being batch adding users to System....');
      createUsers(results);
    });
  }
}

//Opens the file and loads CSV into fields.
Future<List<dynamic>> openFile(String filePath) async {
  final file = File(filePath);
  if (!file.existsSync()) {
    print('File $filePath does not exits!');
    exit(1);
  } else {
    final input = file.openRead();
    final fields =
        input.transform(utf8.decoder).transform(CsvToListConverter());
    return fields.first.then((result) => result);
  }
}

/// Method adds users to the computer in async fanction.
void createUsers(List<dynamic> users) async {
  var userCount = 0;
  while (userCount < 500) {
    unawaited(Process.run('useradd', [users[userCount * 11]])
        .then((_) => print('Added user ${users[userCount * 11]}')));
  }
  while (userCount < 1000) {
    unawaited(Process.run('useradd', [
      users[userCount * 11],
      '-c',
      '${users[(userCount * 11) + 1]} ${users[(userCount * 11) + 2]}'
    ]).then((_) => print('Added user ${users[userCount * 11]}')));
  }
}
