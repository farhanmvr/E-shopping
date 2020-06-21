import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/splash_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_sreen.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './providers/products_provider.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            update: (ctx, authData, previousProducts) => Products(
                authData.token,
                authData.userId,
                (previousProducts == null ? [] : previousProducts.items)),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            update: (ctx, authData, previousOrder) => Orders(
                authData.token,
                authData.userId,
                previousOrder == null ? [] : previousOrder.orders),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, authData, child) => MaterialApp(
            title: 'E-Shopping',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                primarySwatch: Colors.purple,
                accentColor: Colors.redAccent,
                fontFamily: 'Lato'),
            home: authData.isAuth
                ? ProductsOverviewScreen()
                : FutureBuilder(
                    future: authData.tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) => authResultSnapshot.connectionState == ConnectionState.waiting ? SplashScreen() : AuthScreen(),
                  ),
            routes: {
              ProductDetailScreen.routName: (ctx) => ProductDetailScreen(),
              CartScreen.rountName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
            },
          ),
        ));
  }
}
