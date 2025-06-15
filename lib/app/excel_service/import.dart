import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:tbc_application/app/widgets/toast/custom_toast.dart';

class ImportProvider<T> {
  final T Function(Map<String, dynamic>) fromCsvRow;

  ImportProvider({required this.fromCsvRow});

  Future<List<T>> importFromFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

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

        final headers = csv.first.cast<String>();

        for (int i = 1; i < csv.length; i++) {
          final row = csv[i];
          if (row.length != headers.length) continue; // skip malformed rows

          final map = Map<String, dynamic>.fromIterables(headers, row);
          importedItems.add(fromCsvRow(map));
        }
      }
    }

    return importedItems;
  }
}
