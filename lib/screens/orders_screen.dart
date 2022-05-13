import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_drawer.dart';
import '../providers/orders.dart';
import '../widgets/order_item_tile.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _isLoading = false;
  Future<void> _refreshOrders() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Orders>(context, listen: false).fetchAndGetData();
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Something went wrong.',
        backgroundColor: Colors.black54,
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _refreshOrders();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Orders orders = Provider.of<Orders>(context);
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('Your Orders'),
        actions: [
          IconButton(
            onPressed: () => _refreshOrders(),
            icon: const Icon(
              Icons.refresh,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : orders.orders.isEmpty
                ? Center(
                    child: Text(
                      'No Orders!',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  )
                : ListView.builder(
                    itemBuilder: (context, index) => OrderItemTile(
                        total: orders.orders[index].amount,
                        dateTime: orders.orders[index].dateTime,
                        products: orders.orders[index].products),
                    itemCount: orders.orders.length,
                  ),
      ),
    );
  }
}
