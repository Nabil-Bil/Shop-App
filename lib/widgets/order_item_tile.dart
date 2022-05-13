import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/cart.dart';

class OrderItemTile extends StatelessWidget {
  final double total;
  final DateTime dateTime;
  final List<CartItem> products;
  const OrderItemTile(
      {Key? key,
      required this.total,
      required this.dateTime,
      required this.products})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: ExpandablePanel(
            header: Column(
              children: [
                Text(
                  "\$" + total.toStringAsFixed(2),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  DateFormat().addPattern("dd/MM/yyyy hh:mm").format(dateTime),
                  style: const TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.bold),
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
            collapsed: Container(),
            expanded: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: products
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              e.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              "${e.quantity}x \$${e.price.toStringAsFixed(2)}",
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            )),
      ),
    );
  }
}
