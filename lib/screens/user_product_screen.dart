import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/user_product_item.dart';
import '../providers/products.dart';
import '../screens/edit_product_screen.dart';

class UserProductScreen extends StatefulWidget {
  static String routeName = '/user-product';
  const UserProductScreen({Key? key}) : super(key: key);

  @override
  State<UserProductScreen> createState() => _UserProductScreenState();
}

class _UserProductScreenState extends State<UserProductScreen> {
  @override
  void initState() {
    _refreshProducts(context);
    super.initState();
  }

  Future<void> _refreshProducts(BuildContext context) async {
    try {
      await Provider.of<Products>(context, listen: false)
          .fetchAndGetManagedProducts();
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Something went wrong.',
        backgroundColor: Colors.black54,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Products products = Provider.of<Products>(context);
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, EditProductScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
            itemBuilder: (context, index) => Column(
              children: [
                UserProductItem(
                  productTitle: products.getManagedProducts[index].title,
                  productImageUrl: products.getManagedProducts[index].imageUrl,
                  productId: products.getManagedProducts[index].id,
                ),
                const Divider(
                  thickness: 2,
                ),
              ],
            ),
            itemCount: products.getManagedProducts.length,
          ),
        ),
      ),
    );
  }
}
