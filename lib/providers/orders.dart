import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  final String url =
      "https://shopapp-84e75-default-rtdb.europe-west1.firebasedatabase.app/";

  List<OrderItem> orders = [];
  final String? authToken;
  final String? userId;
  Orders({this.authToken, this.orders = const [], this.userId});

  List<OrderItem> get getOrders {
    return [...orders];
  }

  Future<void> fetchAndGetData() async {
    orders = [];
    try {
      http.Response response = await http
          .get(Uri.parse(url + 'orders/$userId.json?auth=$authToken'));

      var orders = jsonDecode(response.body);
      if (orders != null) {
        List<OrderItem> listOfOrders = [];
        orders.forEach((key, value) {
          List<CartItem> listOfProducts = [];

          for (var product in (value['products'] as List<dynamic>)) {
            listOfProducts.add(CartItem(
                id: product['id'],
                title: product['title'],
                price: product['price'],
                quantity: product['quantity']));
          }

          listOfOrders.add(OrderItem(
              id: key,
              amount: value['amount'],
              products: listOfProducts,
              dateTime: DateTime.parse(value['dateTime'])));
        });
        this.orders = listOfOrders;
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

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    if (cartProducts.isNotEmpty) {
      List<Map> cartItems = [];
      for (var element in cartProducts) {
        cartItems.add({
          'id': element.id,
          'title': element.title,
          'price': element.price,
          'quantity': element.quantity
        });
      }
      try {
        final timestamp = DateTime.now();
        await http.post(
          Uri.parse(url + 'orders/$userId.json?auth=$authToken'),
          body: jsonEncode(
            {
              'amount': total,
              'products': cartItems,
              'dateTime': timestamp.toIso8601String()
            },
          ),
        );
        orders.add(
          OrderItem(
              id: timestamp.toString(),
              amount: total,
              products: cartProducts,
              dateTime: timestamp),
        );
        notifyListeners();
      } catch (e) {
        rethrow;
      }
    }
  }
}
