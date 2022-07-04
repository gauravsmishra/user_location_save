import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map_integration/utils/utils.dart';

class UserCurrentLocation {
  Position? _currentPosition;

  static Future<String> getUserCurrentLocation(BuildContext context) async {
    Position position = await determinePosition();

    return await _getAddressFromLatLng(position.latitude, position.longitude);
  }

  static Future<String> _getAddressFromLatLng(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];
      print("placeccccccccc  ${place}");
      String _currentAddress =
          "${place.thoroughfare}${place.thoroughfare!.isEmpty ? "" : ","}${place.subLocality}${place.subLocality!.isEmpty ? "" : ","}${place.locality},${place.administrativeArea}, ${place.postalCode}, ${place.country}";
      /*_currentAddress = place.toString();*/
      Utils.CURRENT_LOCATION_URL = _currentAddress;
      return _currentAddress;
    } catch (e) {
      print(e);
      return '$e';
    }
  }

  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      permission = await Geolocator.checkPermission();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
