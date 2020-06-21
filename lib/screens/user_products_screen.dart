import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../widgets/user_product_item.dart';
import './edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user_products';

  Future<void> _refreshProducts(BuildContext context) async {
    try {
      await Provider.of<Products>(context, listen: false)
          .fetchAndSetProducts(true);
    } catch (error) {
      print('Error is ' + error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Products>(
                      builder: (ctx, productData, _) => Padding(
                        padding: const EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: productData.items.length,
                          itemBuilder: (_, i) {
                            return Column(
                              children: <Widget>[
                                UserProductItem(
                                  title: productData.items[i].title,
                                  imageUrl: productData.items[i].imageUrl,
                                  id: productData.items[i].id,
                                ),
                                Divider(),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
