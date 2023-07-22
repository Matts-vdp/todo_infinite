import 'package:flutter/foundation.dart';
import 'package:todo_infinite/data/persistence/file.dart';
import 'package:todo_infinite/data/persistence/localstorage.dart';

// write a string to a local file
Future<void> writeToPersistence(String s, String file) async {
  if (kIsWeb)
    await writeToLocalStorage(s, file);
  else
    await writeToFile(s, file);
}

//read a string from the local file
Future<String> readFromPersistence(String file) async {
  try {
    if (kIsWeb)
      return await readFromLocalStorage(file);
    else
      return await readFromFile(file);
  } catch (e) {
    return "";
  }
}