import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:map_integration/screens/location_records_screen.dart';
import 'package:map_integration/screens/map_screen.dart';
import '../services/save_user_location.dart';
import '../services/storeage_services.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key}) : super(key: key);

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  TextEditingController _dateController = TextEditingController();
  TextEditingController _placeController = TextEditingController();
  Completer<GoogleMapController> _controller = Completer();
  MapType _currentMapType = MapType.normal;
  Set<Marker> markers = {};

  LatLng? _center;
  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    if (_center != null) {
      setState(() {
        markers.add(Marker(
          markerId: MarkerId('1'),
          position: _center!,
        ));
      });
    }
  }

  @override
  void initState() {
    _dateController.text = DateFormat('dd MMM yyyy').format(DateTime.now());
    getLocation();
    super.initState();
  }

  Future<void> getLocation() async {
    _placeController.text =
        await UserCurrentLocation.getUserCurrentLocation(context);

    Position position = await UserCurrentLocation.determinePosition();
    setState(() {
      _center = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Location Form')),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(children: [
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: _dateController,
            readOnly: true,
            decoration: InputDecoration(
                labelText: 'Date',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
          ),
          const SizedBox(
            height: 20,
          ),
          _center == null
              ? Center(
                  child: Text('Fetching current location...'),
                )
              : Column(
                  children: [
                    TextField(
                      controller: _placeController,
                      readOnly: true,
                      decoration: InputDecoration(
                          labelText: 'Location',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8))),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    _center == null
                        ? SizedBox.shrink()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                child: GoogleMap(
                                  onMapCreated: _onMapCreated,
                                  mapType: _currentMapType,
                                  initialCameraPosition: CameraPosition(
                                    target: _center!,
                                    zoom: 12.0,
                                  ),
                                  mapToolbarEnabled: true,
                                  buildingsEnabled: false,
                                  myLocationButtonEnabled: true,
                                  markers: markers,
                                  zoomControlsEnabled: true,
                                ),
                              ),
                              InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: ((context) => MapScreen(
                                                  location: _center!,
                                                ))));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Text(
                                      'Open Map',
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 17),
                                    ),
                                  )),
                            ],
                          ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () async {
                        StorageServices.saveDetails(_placeController.text,
                                _center!.latitude, _center!.longitude)
                            .then((value) {
                          Fluttertoast.showToast(msg: 'Location Saved');
                        });
                      },
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                            color: Theme.of(context).accentColor,
                            borderRadius: BorderRadius.circular(6)),
                        child: Center(
                            child: Text(
                          'Save',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        )),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => LocationRecordsScreen()));
                      },
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                            color: Theme.of(context).accentColor,
                            borderRadius: BorderRadius.circular(6)),
                        child: Center(
                            child: Text(
                          'Records',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        )),
                      ),
                    )
                  ],
                ),
        ]),
      ),
    );
  }
}
