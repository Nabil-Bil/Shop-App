import 'dart:convert';
import 'dart:io';

import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'product.dart';

class Products with ChangeNotifier {
  List<Product> items = [];
  String? authToken;
  String? userId;
  List<Product> _managedProducts = [];
  Products({this.authToken, this.userId, this.items = const []});

  List<Product> get getItems {
    return [...items];
  }

  List<Product> get getManagedProducts {
    return [..._managedProducts];
  }

  List<Product> get favItems {
    return items.where((element) => element.isFavorite).toList();
  }

  Future<void> addProduct(Product value) async {
    try {
      Uri productUrl = Uri.parse(
          'https://shopapp-84e75-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authToken');

      final productResponse = await http.post(
        productUrl,
        body: json.encode(
          {
            'title': value.title,
            'price': value.price,
            'description': value.description,
            'imageUrl': value.imageUrl,
            'creatorId': userId
          },
        ),
      );

      var productData = jsonDecode(productResponse.body);

      _managedProducts.add(Product(
        id: productData['name'],
        title: value.title,
        description: value.description,
        price: value.price,
        imageUrl: value.imageUrl,
      ));
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchAndGetData() async {
    Uri productsUrl = Uri.parse(
        'https://shopapp-84e75-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authToken');
    Uri favoritesUrl = Uri.parse(
        "https://shopapp-84e75-default-rtdb.europe-west1.firebasedatabase.app/userFavorites/$userId.json?auth=$authToken");
    try {
      http.Response productResponse = await http.get(productsUrl);
      var productData = jsonDecode(productResponse.body);
      if (productData == null) {
        items = [];
      } else {
        http.Response favoritesResponse = await http.get(favoritesUrl);
        var favoritesData = jsonDecode(favoritesResponse.body);

        List<Product> retrievedList = [];
        productData.forEach((key, value) {
          retrievedList.add(Product(
              id: key,
              title: value['title'],
              description: value['description'],
              price: value['price'],
              imageUrl: value['imageUrl'],
              isFavorite:
                  favoritesData == null ? false : favoritesData[key] ?? false));
        });
        items = retrievedList;
      }
      notifyListeners();
    } on SocketException {
      Fluttertoast.showToast(
        msg: 'Connexion Problem !',
        backgroundColor: Colors.black54,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Something went wrong.',
        backgroundColor: Colors.black54,
      );
    }
  }

  Future<void> fetchAndGetManagedProducts() async {
    Uri productsUrl = Uri.parse(
        'https://shopapp-84e75-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authToken');
    Uri favoritesUrl = Uri.parse(
        "https://shopapp-84e75-default-rtdb.europe-west1.firebasedatabase.app/userFavorites/$userId.json?auth=$authToken");
    try {
      http.Response productResponse = await http.get(productsUrl);
      var productData = jsonDecode(productResponse.body);
      if (productData == null) {
        items = [];
      } else {
        http.Response favoritesResponse = await http.get(favoritesUrl);
        var favoritesData = jsonDecode(favoritesResponse.body);

        List<Product> retrievedList = [];
        productData.forEach((key, value) {
          if (value['creatorId'] == userId) {
            retrievedList.add(Product(
                id: key,
                title: value['title'],
                description: value['description'],
                price: value['price'],
                imageUrl: value['imageUrl'],
                isFavorite: favoritesData == null
                    ? false
                    : favoritesData[key] ?? false));
          }
        });
        _managedProducts = retrievedList;
      }
      notifyListeners();
    } on SocketException {
      Fluttertoast.showToast(
        msg: 'Connexion Problem !',
        backgroundColor: Colors.black54,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Something went wrong.',
        backgroundColor: Colors.black54,
      );
    }
  }

  Future<void> removeProduct(String productId) async {
    Uri url = Uri.parse(
        'https://shopapp-84e75-default-rtdb.europe-west1.firebasedatabase.app/products/$productId.json?auth=$authToken');

    try {
      var response = await http.delete(url);
      if (response.statusCode >= 400) {
        throw Exception();
      } else {
        _managedProducts.removeWhere((element) => element.id == productId);
        notifyListeners();
      }
    } on SocketException {
      Fluttertoast.showToast(
        msg: 'Connexion Problem',
        backgroundColor: Colors.black54,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Something went wrong.',
        backgroundColor: Colors.black54,
      );
    }
  }

  List get getIds {
    List ids = [];
    for (var element in items) {
      ids.add(element.id);
    }
    return ids;
  }

  Product findById(String id) {
    return items.firstWhere((product) => product.id == id);
  }

  Future<void> updateProduct(String productId, Product newProduct) async {
    try {
      await http.patch(
        Uri.parse(
            "https://shopapp-84e75-default-rtdb.europe-west1.firebasedatabase.app/products/$productId.json?auth=$authToken"),
        body: jsonEncode(
          {
            'title': newProduct.title,
            'price': newProduct.price,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
          },
        ),
      );
      final prodIndex =
          _managedProducts.indexWhere((element) => element.id == productId);
      _managedProducts[prodIndex] = newProduct;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
