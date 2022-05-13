import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_item_tile.dart';
import '../providers/cart.dart';

class CartList extends StatelessWidget {
  const CartList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Cart cart = Provider.of<Cart>(context);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: ListView(children: 
      cart.items.entries.map((e) => CartItemTile(productId:e.key,title:e.value.title,price:e.value.price,quantity:e.value.quantity)).toList(),
    ),
      // child: ListView.builder(
      //   itemBuilder: (context, index) =>
      //       CartItemTile(cartItem: cart.cartList[index]),
      //   itemCount: cart.itemsCount,
      // ),
    );
  }
}
