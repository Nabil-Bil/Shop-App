import 'package:flutter/cupertino.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
  });
}

class Cart with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  List<CartItem> get cartList {
    List<CartItem> cartList = [];
    _items.forEach((key, value) {
      cartList.add(value);
    });
    return cartList;
  }

  int get itemsCount {
    return _items.length;
  }

  double get totalPrice {
    double total = 0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void addItem(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _items.update(productId, (cartItem) {
        cartItem.quantity++;
        return cartItem;
      });
    } else {
      _items.putIfAbsent(productId, () {
        return CartItem(
            id: DateTime.now().toString(),
            title: title,
            quantity: 1,
            price: price);
      });
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.removeWhere((key, value) => key == productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items[productId]!.quantity--;
    } else {
      removeItem(productId);
    }
  }

  void removeAll() {
    _items.clear();
    notifyListeners();
  }
}
