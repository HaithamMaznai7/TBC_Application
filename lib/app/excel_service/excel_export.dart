import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
// import 'dart:html' as html; // Add only for web

typedef ModelToCsvRow<T> = List<String> Function(T);

class ExportController<T> {
  final List<String> headers;
  final ModelToCsvRow<T> toCsvRow;

  ExportController({
    required this.headers,
    required this.toCsvRow,
  });

  Future<void> exportToCsv(List<T> data, String fileName) async {
    final rows = <List<String>>[headers];
    for (var item in data) {
      rows.add(toCsvRow(item));
    }
    final csv = const ListToCsvConverter().convert(rows);
    final file = await _saveFile(csv, fileName);
    if(kIsWeb){
      print("Exported to Downloads");
    }else if (file != null) {
      print("Exported to ${file.path}");
    } else {
      print("Export failed: File not saved.");
    }
  }

  // Future<File?> _saveFile(String content, String fileName) async {
  //   // if (kIsWeb) {
  //   //   final bytes = utf8.encode(content);
  //   //   final blob = html.Blob([bytes]);
  //   //   final url = html.Url.createObjectUrlFromBlob(blob);
  //   //   final anchor = html.AnchorElement(href: url)
  //   //     ..setAttribute("download", "$fileName.csv")
  //   //     ..click();
  //   //   html.Url.revokeObjectUrl(url);
  //   //   return null;
  //   // } else {
  //   // }
  // }
  Future<File?> _saveFile(String content, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    print('Saving to directory: ${directory.path}'); // <-- debug
    final path = '${directory.path}/$fileName';
    final file = File(path);

    final saved = await file.writeAsString(content);
    print('File saved at: ${saved.path}'); // <-- debug
    return saved;
  }

}
