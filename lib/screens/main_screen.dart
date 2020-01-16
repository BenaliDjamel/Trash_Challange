import 'dart:async';

import 'package:flutter/material.dart';
import 'package:trash_app/widgets/my-drawer.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:new_geolocation/geolocation.dart';



class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  MapController _controller = MapController();

   
  dynamic _latitude = 0.0;
  dynamic _longitude = 0.0;
  var points = <LatLng>[
    LatLng(36.363920, 6.60855),
    LatLng(36.348505, 6.601099),
    LatLng(36.245138, 6.570929),


  ];

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


    
            
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Trash app'),
        ),
        drawer: MyDrawer(),
        body: FlutterMap(
          mapController: _controller,
          options: MapOptions(minZoom: 10.0, center: LatLng(36.363920, 6.60855)/*  buildMap() */),
          layers: [
            TileLayerOptions(
                urlTemplate:
                    'https://api.mapbox.com/styles/v1/benalidjamel/ck53xfs440a0c1cpaupy963iz/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYmVuYWxpZGphbWVsIiwiYSI6ImNrNTMybjRsdzAxMG8zbW9oOWQ4MjZzY20ifQ.Y9hFim_o5zIwd8vLu5APAA',
                //    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                /* subdomains: ['a', 'b', 'c']*/
                additionalOptions: {
                  'accessToken':
                      'pk.eyJ1IjoiYmVuYWxpZGphbWVsIiwiYSI6ImNrNTMybjRsdzAxMG8zbW9oOWQ4MjZzY20ifQ.Y9hFim_o5zIwd8vLu5APAA',
                  'id': 'mapbox.mapbox-streets-v8'
                }),
           /*  MarkerLayerOptions(markers: [
              Marker(
                  width: 45,
                  height: 45,
                  point: LatLng(_latitude, _longitude),
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
                      ))
            ]), */
            PolylineLayerOptions(
              
              polylines: [
              Polyline(

                points: points,
                strokeWidth: 5,
                color: Colors.blue
              )
              ]
                
              )
            
          ],
        ));
  }
}
