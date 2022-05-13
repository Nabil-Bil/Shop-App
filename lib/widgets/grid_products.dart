import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import './product_overview_item.dart';
import '../providers/product.dart';

class GridProducts extends StatelessWidget {
  final bool showFavs;
  const GridProducts({Key? key, required this.showFavs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<Products>(context);
    List<Product> products =
        showFavs ? productsProvider.favItems : productsProvider.items;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 1.4,
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: const ProductOverviewItem(),
      ),
      itemCount: products.length,
    );
  }
}
