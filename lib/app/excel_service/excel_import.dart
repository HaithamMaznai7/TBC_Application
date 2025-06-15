import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:tbc_application/app/widgets/toast/custom_toast.dart';

typedef CsvRowToModel<T> = T Function(Map<String, dynamic>);
typedef SaveToFirebase<T> = Future<void> Function(List<T>);

class ImportController<T> {
  final List<String> headers;
  final CsvRowToModel<T> fromCsvRow;

  ImportController({
    required this.headers,
    required this.fromCsvRow,
  });

  Future<List<T>> importFromFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    print(result);
    final importedItems = <T>[];

    if (result != null) {
      String? fileContent;

      if (result.files.single.bytes != null) {
        fileContent = utf8.decode(result.files.single.bytes!);
      } else if (result.files.single.path != null) {
        final file = File(result.files.single.path!);
        fileContent = await file.readAsString();
      }

      if (fileContent != null) {
        final csv = const CsvToListConverter().convert(fileContent);
        if (csv.isEmpty || csv.length <= 1) {
          CustomToast.errorToast('Error', 'CSV file is empty or invalid');
          return [];
        }

        for (int i = 1; i < csv.length; i++) {
          final row = csv[i];
          final map = Map<String, dynamic>.fromIterables(headers, row);
          T item = fromCsvRow(map);
          importedItems.add(item);
        }
      }
    }

    return importedItems;
  }

}
