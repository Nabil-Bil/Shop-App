import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import '../providers/cart.dart';
import '../providers/product.dart';

import '../screens/product_detail_screen.dart';

class ProductOverviewItem extends StatelessWidget {
  const ProductOverviewItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Product product = Provider.of<Product>(context);
    Cart cart = Provider.of<Cart>(context, listen: false);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ProductDetailScreen.routeName,
            arguments: product.id);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: GridTile(
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder:
                  const AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(
                product.imageUrl,
              ),
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black54,
            leading: IconButton(
              onPressed: () {
                final userData = Provider.of<Auth>(context, listen: false);
                String? token = userData.token;
                String? userId = userData.userId;
                if (token != null && userId != null) {
                  product.changeFavoriteStatus(token, userId);
                } else {
                  Fluttertoast.showToast(
                      msg: 'Problem Occured', backgroundColor: Colors.black54);
                }
              },
              icon: product.isFavorite
                  ? Icon(
                      Icons.favorite_sharp,
                      color: Theme.of(context).colorScheme.secondary,
                    )
                  : Icon(
                      Icons.favorite_border,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
            ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              onPressed: () {
                cart.addItem(product.id, product.title, product.price);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 2),
                    content: const Text('Item Added to Cart!'),
                    action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          cart.removeSingleItem(product.id);
                        }),
                  ),
                );
              },
              icon: Icon(
                Icons.shopping_cart,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
