import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trash_app/providers/challange.dart';
import 'package:trash_app/screens/user_challange.dart';
import 'package:trash_app/widgets/image_input.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import 'dart:io';

class AddChallangeForm extends StatefulWidget {
  static const routeName = '/add-challange';
  @override
  _AddChallangeFormState createState() => _AddChallangeFormState();
}

class _AddChallangeFormState extends State<AddChallangeForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime _startDate;
  DateTime _endDate;
  bool _isLoading = false;
  bool _isloading = false;
  double _latitude = 0.0;
  double _longitude = 0.0;
  String _myLocationInfo = '';

  List<String> _imgsUrl = [];
  List<File> _images = [];
  MapController _controller = MapController();

  Map<String, dynamic> _challangeData = {
    'startDate': null,
    'endDate': null,
    'street': '',
    'city': '',
    'zipCode': null,
    'country': ''
  };

  void _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        _isLoading = true;
      });

      Provider.of<ChallangeNotifier>(context)
          .addChallange(Challange(
              startDate: _challangeData['startDate'].toString(),
              endDate: _challangeData['endDate'].toString(),
              latitude: _latitude,
              longitude: _longitude,
              street: _challangeData['street'],
              city: _challangeData['city'],
              zipCode: _challangeData['zipCode'],
              country: _challangeData['country']))
          .then((challangeId) {
        print('challange id $challangeId');
        _startUpload(challangeId);

        Navigator.of(context).pushReplacementNamed(UserChallange.routeName);
      });
    }
  }

  void _startUpload(int challangeId) async {
    final challange = Provider.of<ChallangeNotifier>(context);
    _images.forEach((image) async {
      String fileName = path.basename(image.path);
      StorageReference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(image);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

      var dowurl = await taskSnapshot.ref.getDownloadURL();
      if (dowurl != null) {
        await challange.storePhoto(challangeId, dowurl.toString());
      }
      // _imgsUrl.add(dowurl.toString());
    });

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _getCurrentUserLocation() async {
    setState(() {
      _isloading = true;
    });
    final locData = await Location().getLocation();
    if (locData != null) {
      setState(() {
        _latitude = locData.latitude;
        _longitude = locData.longitude;
      });
      // From coordinates
      final coordinates = new Coordinates(_latitude, _longitude);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;

      setState(() {
        _challangeData['country'] = first.countryName;
        _challangeData['street'] = first.featureName;
        _challangeData['city'] = '${first.subLocality} ${first.subAdminArea}';
        _challangeData['zipCode'] = first.postalCode;

        _myLocationInfo =
            '${first.adminArea}, ${first.subLocality}, ${first.addressLine}';
        _isloading = false;
      });
    }
  }

  @override
  void initState() {
    _getCurrentUserLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My challanges'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _submit,
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ImageInput(_images),
                      SizedBox(
                        height: 10,
                      ),
                      Card(
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 250,
                              width: double.infinity,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  //border: Border.all(width: 1, color: Colors.grey),
                                  ),
                              child: _isloading
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : FlutterMap(
                                      mapController: _controller,
                                      options: MapOptions(
                                          minZoom: 5.0,
                                          center:
                                              LatLng(_latitude, _longitude)),
                                      layers: [
                                        TileLayerOptions(
                                            urlTemplate:
                                                'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                            subdomains: ['a', 'b', 'c']),
                                        MarkerLayerOptions(markers: [
                                          Marker(
                                              width: 45,
                                              height: 45,
                                              point:
                                                  LatLng(_latitude, _longitude),
                                              builder: (context) => Container(
                                                    child: IconButton(
                                                      icon: Icon(
                                                        Icons.location_on,
                                                        color:
                                                            Colors.blueAccent,
                                                      ),
                                                      iconSize: 45,
                                                      onPressed: () {
                                                        print('get location');
                                                      },
                                                    ),
                                                  ))
                                        ]),
                                      ],
                                    ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  _myLocationInfo.trim().isNotEmpty
                                      ? _myLocationInfo
                                      : 'Fetching location...',
                                  softWrap: true,
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                  )),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      /* LocationInput(_latitude, _longitude), */
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.grey.shade300),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.date_range,
                                color: Colors.grey.shade700,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(_startDate == null
                                  ? 'Select Starting date'
                                  : _startDate.toString()),
                            ],
                          ),
                        ),
                        onTap: () async {
                          DateTime picked = await showDatePicker(
                              context: context,
                              initialDate: _startDate == null
                                  ? DateTime.now()
                                  : _startDate,
                              firstDate: DateTime(2019),
                              lastDate: DateTime(2060));

                          if (picked != null) {
                            setState(() {
                              _startDate = picked;
                              print('------------------------- $_startDate');
                              _challangeData['startDate'] = _startDate;
                              // _getCurrentUserLocation();
                            });
                          }
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.grey.shade300),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.date_range,
                                color: Colors.grey.shade700,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(_endDate == null
                                  ? 'Select Ending Date'
                                  : _endDate.toString()),
                            ],
                          ),
                        ),
                        onTap: () async {
                          DateTime picked = await showDatePicker(
                              context: context,
                              initialDate: _startDate == null
                                  ? DateTime.now()
                                  : _startDate,
                              firstDate: DateTime(2019),
                              lastDate: DateTime(2060));

                          if (picked != null) {
                            setState(() {
                              _endDate = picked;
                              print('------------------------- $_endDate');
                              _challangeData['endDate'] = _endDate;
                              // _getCurrentUserLocation();
                            });
                          }
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      /*  TextFormField(
                        decoration: InputDecoration(labelText: 'Latitude'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          try {
                            if (double.parse(value) != null) {
                              return null;
                            }
                          } catch (e) {
                            return 'Latitude is required';
                          }

                          return null;
                        },
                        onSaved: (value) {
                          _challangeData['latitude'] = double.parse(value);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Longitude'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          try {
                            if (double.parse(value) != null) {
                              return null;
                            }
                          } catch (e) {
                            return 'Latitude is required';
                          }
                        },
                        onSaved: (value) {
                          _challangeData['longitude'] = double.parse(value);
                        },
                      ), */
                      /*  SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Street'),
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return 'Street is required';
                          }

                          return null;
                        },
                        onSaved: (value) {
                          _challangeData['street'] = value;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'City'),
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return 'City is required';
                          }

                          return null;
                        },
                        onSaved: (value) {
                          _challangeData['city'] = value;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Zip code'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          try {
                            if (int.parse(value) != null) {
                              return null;
                            }
                          } catch (e) {
                            return 'Zip code is required';
                          }

                          return null;
                        },
                        onSaved: (value) {
                          _challangeData['zipCode'] = int.parse(value);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Country'),
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return 'Country is required';
                          }

                          return null;
                        },
                        onSaved: (value) {
                          _challangeData['country'] = value;
                        },
                      ), */
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
