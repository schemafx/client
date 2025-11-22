import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:schemafx/models/models.dart';

class ExportService {
  String toCsv(List<Map<String, dynamic>> data, AppTable table) {
    if (data.isEmpty) return '';

    final headers = data.first.keys.map((key) {
      try {
        return table.fields.firstWhere((field) => field.id == key).name;
      } catch (e) {
        return key;
      }
    }).toList();

    final List<List<dynamic>> rows = [];
    rows.add(headers);

    for (final row in data) {
      rows.add(row.values.toList());
    }

    return const ListToCsvConverter().convert(rows);
  }

  String toJson(List<Map<String, dynamic>> data) => jsonEncode(data);
}
