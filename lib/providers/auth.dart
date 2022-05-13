import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../exceptions/http_exception.dart';

class Auth extends ChangeNotifier {
  final String _key = "AIzaSyCM9XRM7N6l4RNsCqmlwlEvVrXLcf-ygJg";
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? authTimer;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token!;
    } else {
      return null;
    }
  }

  String? get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String uriSegment) async {
    try {
      final response = await http.post(
          Uri.parse(
              "https://identitytoolkit.googleapis.com/v1/accounts:$uriSegment?key=$_key"),
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      final responseData = jsonDecode(response.body);
      if (response.statusCode == 400) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      autoLogout();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = jsonEncode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String(),
      });
      prefs.setString('userData', userData);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }

  Future<void> signin(String email, String password) async {
    return _authenticate(email, password, "signInWithPassword");
  }

  Future<void> logout() async {
    _token = null;
    _expiryDate = null;
    _userId = null;
    if (authTimer != null) {
      authTimer!.cancel();
      authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
  }

  void autoLogout() {
    if (authTimer != null) {
      authTimer!.cancel();
    } else {}
    final int? timeToExpiry = _expiryDate?.difference(DateTime.now()).inSeconds;
    authTimer = Timer(
        Duration(seconds: timeToExpiry ?? Duration.zero.inSeconds), logout);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('userData');
    if (userData == null) {
      return false;
    }
    final decodedUserData = json.decode(userData) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(decodedUserData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = decodedUserData['token'];
    _userId = decodedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    autoLogout();
    return true;
  }
}
