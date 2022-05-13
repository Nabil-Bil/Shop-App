import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart';

import '../providers/cart.dart';
import '../widgets/cart_list.dart';

class CartScreen extends StatefulWidget {
  static const String routeName = "/cart";
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isLoading = false;

  Future<void> addOrder() async {
    Cart cart = Provider.of<Cart>(context, listen: false);
    Orders orders = Provider.of<Orders>(context, listen: false);
    setState(() {
      isLoading = true;
    });
    try {
      await orders.addOrder(cart.cartList, cart.totalPrice);
      cart.removeAll();
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Something went wrong.',
        backgroundColor: Colors.black54,
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Cart cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Row(mainAxisSize: MainAxisSize.min, children: [
                      Chip(
                        label: Text('\$' + cart.totalPrice.toStringAsFixed(2)),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        labelStyle: const TextStyle(color: Colors.white),
                      ),
                      isLoading
                          ? Row(
                              children: const [
                                TextButton(
                                  onPressed: null,
                                  child: Text('ORDER NOW'),
                                ),
                                CircularProgressIndicator()
                              ],
                            )
                          : TextButton(
                              onPressed: addOrder,
                              child: const Text('ORDER NOW'))
                    ]),
                  ]),
            ),
          ),
          cart.itemsCount == 0
              ? Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "The Cart is Empty!",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                )
              : const Expanded(child: CartList()),
        ],
      ),
    );
  }
}
