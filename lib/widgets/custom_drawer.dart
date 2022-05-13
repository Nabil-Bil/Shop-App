import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../screens/orders_screen.dart';
import '../screens/user_product_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  void navigateBetweenRoutes(String routeName, BuildContext context) {
    if (ModalRoute.of(context)!.settings.name != routeName) {
      Navigator.pushReplacementNamed(context, routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: AppBar().preferredSize.height * 1.1 +
                MediaQuery.of(context).padding.top,
            child: DrawerHeader(
              child: SizedBox(
                child: Text(
                  'Hello Freind!',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              decoration:
                  BoxDecoration(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text("Shop"),
            onTap: () => navigateBetweenRoutes('/', context),
          ),
          const Divider(thickness: 1),
          ListTile(
            leading: const Icon(Icons.credit_card),
            title: const Text("Orders"),
            onTap: () => navigateBetweenRoutes(OrdersScreen.routeName, context),
          ),
          const Divider(thickness: 1),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text("Manage products"),
            onTap: () =>
                navigateBetweenRoutes(UserProductScreen.routeName, context),
          ),
          const Divider(thickness: 1),
          ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                final auth = Provider.of<Auth>(context, listen: false);
                auth.logout();
                navigateBetweenRoutes('/', context);
              }),
          const Divider(thickness: 1),
        ],
      ),
    );
  }
}
