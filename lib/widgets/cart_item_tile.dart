import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItemTile extends StatelessWidget {
  final String productId;
  final String title;
  final double price;
  final int quantity;
  const CartItemTile({
    Key? key,
    required this.productId,
    required this.title,
    required this.price,
    required this.quantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Cart cart = Provider.of<Cart>(context);
    return Container(
      margin: const EdgeInsets.all(8),
      child: Dismissible(
        confirmDismiss: (direction) {
          return showDialog(
              barrierDismissible: false,
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: const Text('Are You Sure ?'),
                  content:
                      const Text('Do you want to remove this item from cart?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        cart.removeItem(productId);
                        Navigator.pop(context, true);
                      },
                      child: const Text('Yes'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: const Text('No'),
                    ),
                  ],
                );
              });
        },
        key: ValueKey(productId),
        background: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: theme.colorScheme.error),
          padding: const EdgeInsets.only(right: 15),
          alignment: Alignment.centerRight,
          child: const Icon(
            Icons.delete,
            color: Colors.white,
            size: 30,
          ),
        ),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          cart.removeItem(productId);
        },
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: theme.colorScheme.primary,
                child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text('\$$price',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 12))),
              ),
              title: Text(title),
              subtitle:
                  Text("Total: \$" + (price * quantity).toStringAsFixed(2)),
              trailing: Text('${quantity}x'),
            ),
          ),
        ),
      ),
    );
  }
}
