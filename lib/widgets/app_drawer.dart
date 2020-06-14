import 'package:flutter/material.dart';

import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text(
              'E-Shopping',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            automaticallyImplyLeading: false,
          ),
          SizedBox(height: 20,),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, OrdersScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.add_to_home_screen),
            title: Text('My Products'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, UserProductsScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
