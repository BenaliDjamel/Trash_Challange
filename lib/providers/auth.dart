import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trash_app/providers/api.dart';

class Auth extends ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  int _userId;
  Timer _authTimer;

 

  bool get isAuth {
    return token != null;
  }

  int get userId {
    return _userId;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> register(
      {@required String firstname,
      @required String lastname,
      @required String email,
      @required String password,
      DateTime birthdate,
      String phoneNumber,
      String androidVersion}) async {
    try {
      print(birthdate is String);
      final response = await http.post('${Api.url}/api/auth/register',
          body: {
            'firstname': firstname,
            'lastname': lastname,
            'email': email,
            'password': password,
            'birthdate': birthdate.toString(),
            'phoneNumber': phoneNumber,
            'androidVersion': androidVersion
          });

      if (400 <= response.statusCode) {
        throw Exception('invalid ');
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> login(
    String email,
    String password,
  ) async {
    try {
      final response = await http.post('${Api.url}/api/auth/login', body: {
        'email': email,
        'password': password,
      });

      if (400 <= response.statusCode) {
        throw Exception('invalid ');
      }
      var responseData = json.decode(response.body);
      print('this this response from login $responseData ');
      _token = responseData['access_token'];
      print('----------------$_token');
      _userId = responseData['user_id'];

      _expiryDate =
          DateTime.now().add(Duration(seconds: responseData['expires_in']));

      autoLogout();

      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);
    } catch (e) {
      throw e;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate'].toString());

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();
  }

  void autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }

    final timeToExpire = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpire), logout);
  }
}
