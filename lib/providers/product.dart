import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  _hadleError(String message, value) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.black54,
    );
    isFavorite = value;
    notifyListeners();
  }

  void changeFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    Uri url = Uri.parse(
        "https://shopapp-84e75-default-rtdb.europe-west1.firebasedatabase.app/userFavorites/$userId/$id.json?auth=$token");

    try {
      http.Response response = await http.put(
        url,
        body: json.encode(
          isFavorite,
        ),
      );

      if (response.statusCode >= 400) {
        throw Exception();
      }
    } on SocketException {
      _hadleError("Connexion Problem", oldStatus);
    } catch (e) {
      _hadleError("Something went wrong.", oldStatus);
    }
  }
}
