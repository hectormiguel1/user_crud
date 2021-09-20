import 'dart:io';
import 'package:cli_dialog/cli_dialog.dart';
import 'package:dart_console/dart_console.dart';

import 'record.dart';

List<CSVRecord> records = [];
final console = Console();

Future<void> main(List<String> arguments) async {
  console.clearScreen();
  print('Proccessing Passed Arguements $arguments');
  if (arguments.isEmpty) {
    print('No Arguments Passed, CSV File is required');
    exit(1);
  } else {
    print('Attempting to Open ${arguments.first}!');
    openFile(arguments.first).then((results) {
      print('Loaded ${results.length} Records from CSV');
      print('Parsed CSV Records: ${results.map((record) => record.username)}');
      records = results;
      displayMenu();
    }
        //createUsers(results);

        );
  }
}

void displayMenu() async {
  var selection = '';

  final menu = [
    [
      {
        'question': 'What would you like to do?',
        'options': [
          'Add Users',
          'Add Groups',
          'Delete Users',
          'Delete Groups',
          'Update Users',
          'Update User Groups',
          'Exit'
        ]
      },
      'operation'
    ]
  ];
  final dialog = CLI_Dialog(listQuestions: menu);
  while (selection != 'Exit') {
    // console.clearScreen();
    final response = dialog.ask();
    selection = response['operation'];
    selection != 'Exit'
        ? await handleSelection(selection)
        : print('Exiting Application!');
  }
}

Future<void> handleSelection(String selection) async {
  // console.clearScreen();
  switch (selection) {
    case 'Add Users':
      return await createUsers();
    case 'Add Groups':
      return await addGroups();
    case 'Delete Users':
      return await deleteOUsers();
    case 'Delete Groups':
      return await deleteLanaguges();
    case 'Update Users':
      return await addUserComments();
    case 'Update User Groups':
      return await addUsersToGroups();
    default:
      print('Encoundered option: $selection without handler!');
  }
}

//Opens the file and loads CSV into fields.
Future<List<CSVRecord>> openFile(String filePath) async {
  final file = File(filePath);
  if (!file.existsSync()) {
    print('File $filePath does not exits!');
    exit(1);
  } else {
    return file
        .readAsLinesSync()
        .map((line) => CSVRecord.fromList(line.split(',')))
        .toList();
  }
}

void displayProcessResult(
        ProcessResult proc, CSVRecord record, bool withComment) =>
    proc.exitCode == 0
        ? withComment
            ? print(
                'User ${record.username} Added with Comment \'${record.first} ${record.last}\'')
            : print('Added User ${record.username}')
        : print('Unale to add user, Error Message: ${proc.stderr}');

Future<ProcessResult> addUser(
        {required CSVRecord record, required bool withComment}) =>
    withComment
        ? Process.run('useradd',
            [record.username, '-c', ' \'${record.first} ${record.last}\''])
        : Process.run('useradd', [record.username]);

/// Method adds users to the computer in async fanction.
Future<void> createUsers() async {
  var currentRecord = 0;
  ProcessResult result;
  while (currentRecord < records.length) {
    print('Current Iteration: ${currentRecord + 1}/${records.length}');
    result = await addUser(
        record: records[currentRecord], withComment: (currentRecord > 500));
    displayProcessResult(result, records[currentRecord], (currentRecord > 500));
    currentRecord++;
  }
}

//Adds the groups to the system using command groupadd, optionally a group id can be passed.
Future<ProcessResult> addGroup({required String groupName, int? groupID}) =>
    groupID == null
        ? Process.run('groupadd', [groupName])
        : Process.run('groupadd', [groupName, '-g', groupID.toString()]);

Future<void> addConstellationsGroups() async {
  List<String> constellations = [];
  //Add Constellations from records to the list.
  records.forEach((element) => constellations.contains(element.constilation)
      ? null
      : constellations.add(element.constilation));
  print('Found ${constellations.length} constellations.');

  for (var index = 0; index < constellations.length; index++) {
    var result = await addGroup(groupName: constellations[index]);
    result.exitCode == 0
        ? print(
            '[${index + 1}/${constellations.length}] Added Group: ${constellations[index]} Suncessfully!')
        : print(
            '[${index + 1}/${constellations.length}] Error Adding Group: ${constellations[index]}. Error: ${result.stderr}');
  }
}

Future<void> addTVGeneraGroups() async {
  List<String> tvGeneres = [];
  records.forEach((element) => tvGeneres.contains(element.tv_genera)
      ? null
      : tvGeneres.add(element.tv_genera));
  print('Found ${tvGeneres.length} TV Generas');
  int groupID = 5001;
  for (var index = 0; index < tvGeneres.length; index++) {
    var result =
        await addGroup(groupName: tvGeneres[index], groupID: groupID++);
    result.exitCode == 0
        ? print(
            '[${index + 1}/${tvGeneres.length}] Added Group: ${tvGeneres[index]} with GroupID: ${groupID - 1} Successfully!')
        : print(
            '[${index + 1}/${tvGeneres.length}] Error Adding Group: ${tvGeneres[index]} with Group ID: ${groupID - 1}. Error: ${result.stderr}');
  }
}

Future<void> addGroups() async {
  await addConstellationsGroups();
  await addTVGeneraGroups();
}

Future<void> deleteOUsers() async {
  List<String> oBloodUsers = [];
  //Get users with O Blood Type
  records.forEach((element) =>
      element.bloodType == 'o' ? oBloodUsers.add(element.username) : null);
  print('Found ${oBloodUsers.length} users with O Blood Type!');
  for (var index = 0; index < oBloodUsers.length; index++) {
    final result = await Process.run('userdel', [oBloodUsers[index]]);
    result.exitCode == 0
        ? print(
            '[${index + 1}/${oBloodUsers.length}] Removed User ${oBloodUsers[index]} Suncessfully!')
        : print(
            '[${index + 1}/${oBloodUsers.length}] Failed to remove User: ${oBloodUsers[index]}, Error: ${result.stderr}');
  }
}

Future<void> deleteLanaguges() async {
  List<String> languagesToRemove = [];
  RegExp matchingPattern = RegExp(r'[a-m]');
  //Add languages to the list which start with letters from a-m, application will check with both cases
  records.forEach((element) => element.language.startsWith(matchingPattern)
      ? languagesToRemove.contains(element.language)
          ? null
          : languagesToRemove.add(element.language)
      : null);
  print(
      'Found ${languagesToRemove.length} Languages which match Pattern: Starts with ${matchingPattern.pattern}');
  for (var index = 0; index < languagesToRemove.length; index++) {
    final result = await Process.run('groupdel', [languagesToRemove[index]]);
    result.exitCode == 0
        ? print(
            '[${index + 1}/${languagesToRemove.length}] Sucessfeully Removed Group: ${languagesToRemove[index]}')
        : print(
            '[${index + 1}/${languagesToRemove.length}] Error Removeing Group: ${languagesToRemove[index]}, Error: ${result.stderr}');
  }
}

Future<List<PASSWDRecord>> parsePasswd() async {
  final process = await Process.run('cat', ['/etc/passwd']);
  if (process.exitCode == 0) {
    return parseOutput(process.stdout.toString());
  } else
    throw 'Error Reading /etc/passwd, Error Message: ${process.stderr}';
}

List<PASSWDRecord> parseOutput(String output) {
  List<PASSWDRecord> passwdRecords = [];
  List<String> lines = output.split('\n');
  lines.removeWhere((line) => line.isEmpty);
  lines.forEach(
      (line) => passwdRecords.add(PASSWDRecord.fromList(line.split(':'))));
  return passwdRecords;
}

Future<void> addUserComments() async {
  List<PASSWDRecord> passwdRecords = await parsePasswd();
  print('Loaded ${passwdRecords.length} records from /etc/passwd');
  //Remove users whos User ID is less than or equals 1000 and greater then or equals 2000.
  passwdRecords
      .removeWhere((record) => record.uid <= 1000 || record.uid >= 2000);
  print(
      'Remaining Records after Removing those with UID <= 1000 || >= 2000: ${passwdRecords.length}');
  for (var index = 0; index < passwdRecords.length; index++) {
    final csvRecord = records.firstWhere(
        (element) => element.username == passwdRecords[index].username);
    final result =
        await Process.run('usermod', [csvRecord.username, '-c', csvRecord.dob]);
    result.exitCode == 0
        ? print(
            '[${index + 1}/${passwdRecords.length}] Sucessfully added Comment ${csvRecord.dob} to User: ${csvRecord.username}')
        : print(
            '[${index + 1}/${passwdRecords.length}] Unable to add Comment ${csvRecord.dob} to User: ${csvRecord.username}. Error Code: ${result.stderr}');
  }
}

Future<void> addPlanetGroups() async {
  List<String> groupsToAdd = [];
  records.forEach((element) => groupsToAdd.contains(element.planet)
      ? null
      : groupsToAdd.add(element.planet));
  for (var index = 0; index < groupsToAdd.length; index++) {
    var result = await addGroup(groupName: groupsToAdd[index]);
    result.exitCode == 0
        ? print(
            '[${index + 1}/${groupsToAdd.length}] Added Group: ${groupsToAdd[index]} Successfully!')
        : print(
            '[${index + 1}/${groupsToAdd.length}] Error Adding Group: ${groupsToAdd[index]}. Error: ${result.stderr}');
  }
}

Future<void> addUsersToGroups() async {
  await addPlanetGroups();
  List<PASSWDRecord> passwdRecords = await parsePasswd();
  print('Loaded ${passwdRecords.length} records from /etc/passwd');
  passwdRecords.removeWhere((record) => record.uid >= 2000);
  print(
      'Remaining Records after Removing those with UID >= 2000: ${passwdRecords.length}');
  for (var index = 0; index < passwdRecords.length; index++) {
    if (records
        .any((element) => element.username == passwdRecords[index].username)) {
      final csvRecord = records.firstWhere(
          (element) => element.username == passwdRecords[index].username);
      final result = await Process.run(
          'usermod', ['-a', '-G', csvRecord.planet, csvRecord.username]);
      result.exitCode == 0
          ? print(
              '[${index + 1}/${passwdRecords.length}] Added ${csvRecord.username} to ${csvRecord.planet} group!')
          : print(
              '[${index + 1}/${passwdRecords.length}] Error adding ${csvRecord.username} to ${csvRecord.planet} group!, Error: ${result.stderr}');
    }
  }
}
