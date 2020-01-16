import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geocoder/geocoder.dart';

class LocationInput extends StatefulWidget {
  double _latitude;
  double _longitude;

  LocationInput(this._latitude, this._longitude);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  /* double _latitude;
  double _longtitude; */
  bool _isloading = false;
  bool _isInit = true;
  String _myLocationInfo = '';
  MapController _controller = MapController();

  Future<void> _getCurrentUserLocation() async {
    setState(() {
      _isloading = true;
    });
    final locData = await Location().getLocation();
    if (locData != null) {
      if (this.mounted) {
        setState(() {
          widget._latitude = locData.latitude;
          widget._longitude = locData.longitude;
          _isloading = false;
        });

        // From coordinates
        final coordinates =
            new Coordinates(widget._latitude, widget._longitude);
        var addresses =
            await Geocoder.local.findAddressesFromCoordinates(coordinates);
        var first = addresses.first;

        setState(() {
          _myLocationInfo =
              '${first.adminArea}, ${first.subLocality}, ${first.addressLine} ${first.toMap()}';
        });
      }
    }
    print(widget._latitude);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    _getCurrentUserLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
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
                        center: LatLng(widget._latitude, widget._longitude)),
                    layers: [
                      TileLayerOptions(
                          urlTemplate:
                              'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          subdomains: ['a', 'b', 'c']),
                      MarkerLayerOptions(markers: [
                        Marker(
                            width: 45,
                            height: 45,
                            point: LatLng(widget._latitude, widget._longitude),
                            builder: (context) => Container(
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.location_on,
                                      color: Colors.blueAccent,
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
          SizedBox(height: 10,),
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
          SizedBox(height: 10,),
          
        ],
      ),
    );
  }
}
