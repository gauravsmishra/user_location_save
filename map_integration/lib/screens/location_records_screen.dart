import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';
import '../model/location_model.dart';
import '../services/storeage_services.dart';
import '../utils/pdf_api.dart';

class LocationRecordsScreen extends StatefulWidget {
  const LocationRecordsScreen({Key? key}) : super(key: key);

  @override
  _LocationRecordsScreenState createState() => _LocationRecordsScreenState();
}

class _LocationRecordsScreenState extends State<LocationRecordsScreen> {
  List<LocationModel> locationModel = [];

  @override
  void initState() {
    getLocationRecordList();
    super.initState();
  }

  void getLocationRecordList() async {
    var record = await StorageServices.getDetails();
    setState(() {
      locationModel.addAll(record);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Location List')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (locationModel.isEmpty) {
            Fluttertoast.showToast(msg: 'No Records found');
          } else {
            final pdfFile = await PdfApi.generateTable(locationModel);
            PdfApi.openFile(pdfFile);
          }
        },
        child: Icon(Icons.picture_as_pdf),
      ),
      body: locationModel.isEmpty
          ? Center(
              child: Text('No records found'),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  margin: const EdgeInsets.only(left: 12, right: 12, top: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Place : ${locationModel[index].place}'),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          'Latitude : ${locationModel[index].latitude}',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w300),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Longitude : ${locationModel[index].longitude}',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w300),
                            ),
                            Text(
                              'Date : ${DateFormat('dd MMM yyyy').format(locationModel[index].date ?? DateTime.now())}',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w300),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: locationModel.length),
    );
  }
}
