import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:bus_tracker/Objects/bus.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
class FileStorage {
  

static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }


  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/info.json');
  }

  static readJson() async {
    String contents = "null value";
    final file = await _localFile;
    try {
      

      // Read the file
      contents = await file.readAsString();

      return jsonDecode(contents);
    } catch (e) {
      print(e);
      return contents;
    }
    
  }

  static Future<File> writeCounter(String vid, String uid) async {
    final file = await _localFile;
    final Bus bus = Bus.namedConst(vid,uid);
    // Write the file
    return file.writeAsString(json.encode(bus.toJson()));
  }
}