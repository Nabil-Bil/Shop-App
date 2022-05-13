import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String productId;
  final String productTitle;
  final String productImageUrl;
  const UserProductItem({
    Key? key,
    required this.productTitle,
    required this.productImageUrl,
    required this.productId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Products products = Provider.of<Products>(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(productImageUrl),
      ),
      title: Text(productTitle),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        IconButton(
          onPressed: () {
            Navigator.of(context)
                .pushNamed(EditProductScreen.routeName, arguments: productId);
          },
          icon: Icon(
            Icons.edit,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        IconButton(
          onPressed: () {
            products.removeProduct(productId);
          },
          icon: Icon(
            Icons.delete,
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      ]),
    );
  }
}
