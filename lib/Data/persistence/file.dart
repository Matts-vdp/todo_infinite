import 'package:path_provider/path_provider.dart';
import 'dart:io';

// used to find the local directory path
Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

// used to get the storage File object
Future<File> getLocalFile(String file) async {
  final path = await _localPath;
  return File('$path/$file');
}

// write a string to a local file
Future<void> writeToFile(String s, String file) async {
  final f = await getLocalFile(file);
  f.writeAsString(s);
}

//read a string from the local file
Future<String> readFromFile(String file) async {
  try {
    final f = await getLocalFile(file);
    final contents = await f.readAsString();
    return contents;
  } catch (e) {
    return "";
  }
}