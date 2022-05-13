import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';

import '../providers/cart.dart';
import '../screens/cart_screen.dart';
import '../widgets/badge.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/grid_products.dart';

enum FilterOptions {
  favorite,
  all,
}

class ProductsOverviewScreen extends StatefulWidget {
  static const String routeName="/products-overview";
  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showFavoriteOnly = false;
  bool _isLoad = false;

  @override
  void initState() {
    super.initState();

    Provider.of<Products>(context, listen: false)
        .fetchAndGetData()
        .then((value) {
      setState(() {
        _isLoad = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions value) {
              setState(() {
                if (value == FilterOptions.favorite) {
                  _showFavoriteOnly = true;
                } else {
                  _showFavoriteOnly = false;
                }
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.favorite,
              ),
              const PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.all,
              ),
            ],
            icon: const Icon(Icons.more_vert),
          ),
          Consumer<Cart>(
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: const Icon(Icons.shopping_cart),
            ),
            builder: (context, value, child) => Badge(
              child: child!,
              value: value.itemsCount.toString(),
              color: Theme.of(context).colorScheme.secondary,
              key: UniqueKey(),
            ),
          ),
        ],
      ),
      body: _isLoad
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridProducts(showFavs: _showFavoriteOnly),
            ),
    );
  }
}
