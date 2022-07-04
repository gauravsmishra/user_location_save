import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';
import '../model/location_model.dart';

class StorageServices {
  static Future<int> saveDetails(
      String place, double latitude, double longitude) async {
    var database = await DatabaseProvider.db.database;
    return await database.insert(
        LocationModel.TABLE_NAME,
        {
          "date": DateTime.now().toIso8601String(),
          "place": place,
          "latitude": latitude,
          "longitude": longitude
        },
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  static Future<List<LocationModel>> getDetails() async {
    var database = await DatabaseProvider.db.database;
    List<LocationModel> locationModel = [];
    List<Map<String, Object?>> result =
        await database.query(LocationModel.TABLE_NAME);
    result.forEach((element) {
      LocationModel data = LocationModel.fromJson(element);
      locationModel.add(data);
    });
    print('Result ${result.first}');
    return locationModel;
  }
}
