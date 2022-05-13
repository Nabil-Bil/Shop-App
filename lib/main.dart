import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import './providers/auth.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/products.dart';
import './screens/auth_screen.dart';
import './screens/cart_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/orders_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/user_product_screen.dart';
import 'screens/splash_screen.dart';

void main(List<String> args) {
  Provider.debugCheckInvalidValueType = null;
  return runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => Auth())),
        ChangeNotifierProxyProvider<Auth, Products>(
            create: ((context) => Products()),
            update: (context, auth, previousProducts) {
              return Products(
                authToken: auth.token,
                userId: auth.userId,
                items: previousProducts!.getItems,
              );
            }),
        ChangeNotifierProvider(create: (context) => Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (context) => Orders(),
          update: (context, auth, previousOrders) {
            return Orders(
                authToken: auth.token,
                orders: previousOrders!.getOrders,
                userId: auth.userId);
          },
        ),
      ],
      child: Consumer<Auth>(
        builder: ((context, auth, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Shop App",
            home: auth.isAuth
                ? const ProductsOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: ((context, snapshot) {
                      return (snapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : const AuthScreen());
                    }),
                  ),
            theme: ThemeData(
              progressIndicatorTheme:
                  const ProgressIndicatorThemeData(color: Colors.deepOrange),
              textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme)
                  .copyWith(
                headlineSmall:
                    const TextStyle(color: Colors.white, letterSpacing: 1),
              ),
              colorScheme: ColorScheme.fromSwatch(
                      primarySwatch: Colors.purple, errorColor: Colors.red)
                  .copyWith(
                secondary: Colors.deepOrange,
              ),
            ),
            routes: {
              ProductsOverviewScreen.routeName: (context) =>
                  const ProductsOverviewScreen(),
              ProductDetailScreen.routeName: (context) =>
                  const ProductDetailScreen(),
              OrdersScreen.routeName: (context) => const OrdersScreen(),
              CartScreen.routeName: (context) => const CartScreen(),
              UserProductScreen.routeName: (context) =>
                  const UserProductScreen(),
              EditProductScreen.routeName: (context) =>
                  const EditProductScreen(),
            },
          );
        }),
      ),
    );
  }
}
