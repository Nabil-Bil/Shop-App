import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../providers/product.dart';

class ProductDetailScreen extends StatefulWidget {
  static const String routeName = "product-detail";

  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  double top = 0;

  @override
  Widget build(BuildContext context) {
    String routeArg = ModalRoute.of(context)!.settings.arguments as String;
    Product product =
        Provider.of<Products>(context, listen: false).findById(routeArg);
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: MediaQuery.of(context).size.height * 0.4,
          pinned: true,
          flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            top = constraints.biggest.height;

            return FlexibleSpaceBar(
              title: Container(
                  padding: top <= 100
                      ? const EdgeInsets.all(0)
                      : const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: top <= 100 ? Colors.transparent : Colors.black54,
                      borderRadius: BorderRadius.circular(8)),
                  child: Text(product.title)),
              background: Hero(
                tag: product.id,
                child: Image.network(
                  product.imageUrl,
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            );
          }),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "\$${product.price}",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    product.description,
                  ),
                ),
                const SizedBox(
                  height: 1000,
                )
              ],
            )
          ]),
        )
      ]),
    );
  }
}
