import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:new_geolocation/geolocation.dart';
import 'package:provider/provider.dart';
import 'package:trash_app/providers/challange.dart';

class MapChallange extends StatefulWidget {
  @override
  _MapChallangeState createState() => _MapChallangeState();
}

class _MapChallangeState extends State<MapChallange> {
  MapController _controller = MapController();
  dynamic _latitude = 0.0;
  dynamic _longitude = 0.0;
  bool _isInit = true;

  Future<void> _refreshChallanges(BuildContext context) async {
    if (_isInit) {
      await Provider.of<ChallangeNotifier>(context, listen: false)
          .fetchAndSetChallanges();
    }

    _isInit = false;
  }

  getPermission() async {
    final GeolocationResult result =
        await Geolocation.requestLocationPermission(const LocationPermission(
            android: LocationPermissionAndroid.fine,
            ios: LocationPermissionIOS.always));
    return result;
  }

  getLocation() async {
    final GeolocationResult result =
        await Geolocation.requestLocationPermission(const LocationPermission(
            android: LocationPermissionAndroid.fine,
            ios: LocationPermissionIOS.always));

    if (result.isSuccessful) {
      StreamSubscription<LocationResult> subscription =
          Geolocation.currentLocation(accuracy: LocationAccuracy.best)
              .listen((res) {
        if (res.isSuccessful) {
          _controller.move(
              new LatLng(res.location.latitude, res.location.longitude), 15);
          setState(() {
            _latitude = res.location.latitude;
            _longitude = res.location.longitude;
          });
          // todo with result
        }
      });
    }
  }

  buildMap() {
    getLocation();
  }

  markers(ChallangeNotifier data) {
    final _challanges =  data.challanges
        .map((challange) => Marker(
            width: 45,
            height: 45,
            point: LatLng(challange.latitude, challange.longitude),
            builder: (context) => Container(
                  child: IconButton(
                    icon: Icon(
                      Icons.location_on,
                      color: Colors.green,
                    ),
                    iconSize: 45,
                    onPressed: () {
                      print('get location');
                    },
                  ),
                )))
        .toList();
       _challanges  .add(Marker(
            width: 45,
            height: 45,
            point: LatLng(_latitude, _longitude),
            builder: (context) => Container(
                  child: IconButton(
                    icon: Icon(
                      Icons.my_location,
                      color: Colors.blue,
                    ),
                    iconSize: 45,
                    onPressed: () {
                      print('get location');
                    },
                  ),
                ))); 

                return _challanges;
  }

  @override
  void initState() {
    // TODO: implement initState
    buildMap();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /*  return FutureBuilder(
      future: _refreshChallanges(context),
      builder: (context, snapshoot) =>
          snapshoot.connectionState == ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Consumer<ChallangeNotifier>(
                  builder: (context, challangeData, _) => FlutterMap(
                    mapController: _controller,
                    options: MapOptions(
                        minZoom: 5.0,
                        center:  LatLng(36.363920, 6.60855)  buildMap()),
                    layers: [
                      TileLayerOptions(
                          urlTemplate:
                              'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          subdomains: ['a', 'b', 'c']),
                      MarkerLayerOptions(markers: markers(challangeData)),
                    ],
                  ),
                ),
    ); */

    return Consumer<ChallangeNotifier>(
      builder: (context, challangeData, _) => FlutterMap(
        mapController: _controller,
        options:
            MapOptions(minZoom: 5.0, center: LatLng(_latitude, _longitude)),
        layers: [
          TileLayerOptions(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c']),
          MarkerLayerOptions(markers: markers(challangeData)),
        ],
      ),
    );
  }
}
