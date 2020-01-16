import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trash_app/providers/api.dart';
import 'package:http/http.dart' as http;
import 'package:trash_app/providers/auth.dart';

class Challange {
  final int id;
  final String startDate;
  final String endDate;
  final double latitude;
  final double longitude;
  final int zipCode;
  final String street;
  final String city;
  final String country;
  List photos = [];
 final String created_at;

  Challange(
      {this.id,
      @required this.startDate,
      @required this.endDate,
      @required this.latitude,
      @required this.longitude,
      @required this.zipCode,
      @required this.street,
      @required this.city,
      @required this.country,
      this.photos,
       this.created_at
      });
}

class ChallangeNotifier with ChangeNotifier {
  List<Challange> _challanges = [];
  String authToken;
  int userId;

  ChallangeNotifier(this.authToken, this.userId, this._challanges);

  List<Challange> get challanges {
    return [..._challanges];
  }

  Future<int> addChallange(Challange challange) async {
    try {
      final response = await http.post('${Api.url}/api/challange/store',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': authToken
          },
          body: json.encode({
            'startDate': challange.startDate,
            'endDate': challange.endDate,
            'latitude': challange.latitude,
            'longitude': challange.longitude,
            'street': challange.street,
            'city': challange.city,
            'zipCode': challange.zipCode,
            'country': challange.country
          }));

      // print(' responsive body ${response.body}');

      if (response.statusCode >= 400) {
        print(response.statusCode);
        return null;
      }

      _challanges.add(new Challange(
          id: json.decode(response.body)['id'],
          startDate: challange.startDate,
          endDate: challange.endDate,
          latitude: challange.latitude,
          longitude: challange.longitude,
          street: challange.street,
          city: challange.city,
          photos: [],
          created_at: json.decode(response.body)['created_at'] ,
          zipCode: challange.zipCode,
          country: challange.country));

      notifyListeners();

      // await fetchAndSetUserChallange();
      return json.decode(response.body)['id'];
    } catch (e) {
      throw e;
    }
  }

  Future<void> storePhoto(int id, _imgUrl) async {
    print('  $id        urls $_imgUrl   ');
    try {
      final photoResponse = await http.post('${Api.url}/api/photo/store/$id',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': authToken
          },
          body: json.encode({
            'path': _imgUrl,
          }));

      if (photoResponse.statusCode >= 400) {
        print(photoResponse.statusCode);
        return;
      }
      final body = json.decode(photoResponse.body);

      _challanges.firstWhere((challange) => challange.id == id).photos.add({
        'id': body['id'],
        'path': body['path'],
        'challange_id': body['challange_id'],
        'created_at': body['created_at'],
        'updated_at': body['updated_at']
      });
      // print('--------------------${_challanges[index].photos}');

      _challanges.forEach((challange) => print('${challange.photos}'));
    } catch (e) {
      throw e;
    }
  }

  Future<void> fetchAndSetUserChallange() async {
    try {
      final response = await http.get('${Api.url}/api/challanges/me', headers: {
       
        'Authorization': authToken
      });

      if (response.statusCode >= 400) {
        print(response.statusCode);
        return;
      }

      final responseData = json.decode(response.body) as List<dynamic>;
      //print('response body from server  ${response.body}');
      final List<Challange> loadedChallange = [];

      responseData.forEach((challangeData) => loadedChallange.add(Challange(
          id: challangeData['id'],
          startDate: challangeData['startData'],
          endDate: challangeData['endData'],
          latitude: challangeData['latitude'].toDouble(),
          longitude: challangeData['longitude'].toDouble(),
          city: challangeData['city'],
          country: challangeData['country'],
          street: challangeData['street'],
          photos: challangeData['photos'],
          created_at: challangeData['created_at'],
          zipCode: challangeData['zipCode'])));

      _challanges = loadedChallange;
      // _challanges.forEach((challange) => print('${challange.latitude}'));

      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> fetchAndSetChallanges() async {
    try {
      final response = await http.get('${Api.url}/api/challanges', headers: {
       
        'Authorization': authToken
      });

      if (response.statusCode >= 400) {
        print(response.statusCode);
        return;
      }

      final responseData = json.decode(response.body) as List<dynamic>;
      print('response body from server  ${response.body}');
      final List<Challange> loadedChallanges = [];

      responseData.forEach((challangeData) => loadedChallanges.add(Challange(
          id: challangeData['id'],
          startDate: challangeData['startData'],
          endDate: challangeData['endData'],
          latitude: challangeData['latitude'].toDouble(),
          longitude: challangeData['longitude'].toDouble(),
          city: challangeData['city'],
          country: challangeData['country'],
          street: challangeData['street'],
          photos: challangeData['photos'],
           created_at: challangeData['created_at'],
          zipCode: int.parse(challangeData['zipCode']))));

      _challanges = loadedChallanges;
      // _challanges.forEach((challange) => print('${challange.latitude}'));

      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> removeChallange(int id) async {
    final response = await http.delete('${Api.url}/api/challange/delete/$id',
        headers: {'Authorization': authToken});

    if (response.statusCode >= 400) {
      print(response.statusCode);
      return;
    }

    _challanges.removeWhere((challange) => challange.id == id);
    notifyListeners();

    print('-----------------${response.body}');
  }
}
