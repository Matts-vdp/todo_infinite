import 'package:path_provider/path_provider.dart';
import 'dart:io';

// used to find the local directory path
Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

// used to get the storage File object
Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/data.json');
}

// write a string to a local file
Future<File> writeFile(String s) async {
  final file = await _localFile;
  return file..writeAsString(s);
}

//read a string from the local file
Future<String> readFile() async {
  try {
    final file = await _localFile;
    final contents = await file.readAsString();
    return contents;
  } catch (e) {
    return "";
  }
}