import 'dart:core';
import 'package:shop_app/providers/product.dart';
import 'package:test/test.dart';
import 'package:shop_app/providers/products.dart';

void main() {
  test('Add new row', () async {
    final products = Products(authToken: '');

    await products.addProduct(
      Product(
        id: "p1",
        title: "Test",
        description: "This is Just a test",
        price: 15.99,
        imageUrl:
            "https://www.gstatic.com/mobilesdk/160503_mobilesdk/logo/2x/firebase_28dp.png",
      ),
    );
  });
}
