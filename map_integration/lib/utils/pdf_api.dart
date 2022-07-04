import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../model/location_model.dart';

class PdfApi {
  static Future<File> generateTable(List<LocationModel> locations) async {
    final pdf = Document();

    final headers = ['Sr No.', 'Date', 'Place', 'Latitude', 'Longitude'];

    final recorde = [];
    final data = locations
        .map((element) => [
              element.srNo.toString(),
              DateFormat('dd MMM yyyy hh:mm:ss').format(element.date!),
              element.place,
              element.latitude.toString(),
              element.longitude.toString()
            ])
        .toList();

    pdf.addPage(Page(
      build: (context) => Table.fromTextArray(
        headers: headers,
        data: data,
        cellPadding: EdgeInsets.all(2),
      ),
    ));

    return saveDocument(name: 'my_example.pdf', pdf: pdf);
  }

  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }
}
