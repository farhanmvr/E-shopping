import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exeption.dart';
import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'T Shirt',
    //   description:
    //       '100% Cotton Regular fit, Short sleeve Varsity College printed t-shirt Bio wash for soft handfeel Cleaning instructions ',
    //   price: 29.99,
    //   imageUrl:
    //       'https://lh3.googleusercontent.com/proxy/GacXxfZwFByihWGktzyYdNahtj_liTmJETUFRsBVG2rc0b5s0k-I81LdZXRTn9SOCvbxH7oWY9C9YNGnZoILjhktzEXmZs96-NFpIQGtPMU5kdCJplie2bpXvt9_axOYUWgtqHJ-FCf-npnH4ZrZ3ZjOEAyVwhqT',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description:
    //       'Pal Exim - Offering Perfit 75% Polyester/25% Viscose Semi Formal Trousers at Rs 1000/piece in Mumbai, Maharashtra. Read about company',
    //   price: 59.99,
    //   imageUrl:
    //       'https://stockx.imgix.net/products/streetwear/Nike-x-UN-LeBron-James-More-Than-An-Athlete-Shorts-Racer-Blue-Black.png?fit=fill&bg=FFFFFF&w=700&h=500&auto=format,compress&q=90&dpr=2&trim=color&updated_at=1570479203',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Shirt',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://images-na.ssl-images-amazon.com/images/I/410el0B7L6L.jpg',
    // ),
    // Product(
    //   id: 'p5',
    //   title: 'Shoes',
    //   description:
    //       'ASIN: B01MXNVPUM Date first available at Amazon.in: 21 November 2016 Customer Reviews: 4.1 out of 5 stars12,989 customer ratings Amazon ',
    //   price: 45.8,
    //   imageUrl:
    //       'https://images-na.ssl-images-amazon.com/images/I/61utX8kBDlL._UY500_.jpg',
    // ),
    // Product(
    //   id: 'p6',
    //   title: 'Laptop',
    //   description: 'High display integrated laptop for gaming and personal use',
    //   price: 45.8,
    //   imageUrl: 'https://i.ytimg.com/vi/tIof7h6Pzjs/maxresdefault.jpg',
    // ),
    // Product(
    //   id: 'p7',
    //   title: 'Headset',
    //   description:
    //       'Sony PlayStation Gold Wireless Stereo Headset, Product number: 10029, Compatible with PS4, PS3, PS Vita, Mac, and PC, Can also work with smartphones',
    //   price: 45.8,
    //   imageUrl:
    //       'https://img.grouponcdn.com/deal/qHW1GaifM7TDDPTVtHFG/AC-1800x1091/v1/c700x420.jpg',
    // ),
    // Product(
    //   id: 'p8',
    //   title: 'Fridge',
    //   description: 'Super cooling effect',
    //   price: 45.8,
    //   imageUrl:
    //       'https://images-na.ssl-images-amazon.com/images/I/81SbMeDQ90L._SX466_.jpg',
    // ),
    // Product(
    //   id: 'p9',
    //   title: 'Footware',
    //   description: 'Easy confortable footware',
    //   price: 45.8,
    //   imageUrl:
    //       'https://content3.jdmagicbox.com/comp/chennai/u8/044pxx44.xx44.110121181020.y6u8/catalogue/gms-footwear-selaiyur-chennai-orthopaedic-footwear-dealers-2nbvp8a.jpg',
    // ),
    // Product(
    //   id: 'p10',
    //   title: 'Perfume',
    //   description: 'Nice smell perfume',
    //   price: 45.8,
    //   imageUrl:
    //       'https://previews.123rf.com/images/maramicado/maramicado1602/maramicado160200016/53273007-victoria-s-secret-body-mist-for-women.jpg',
    // ),
    // Product(
    //   id: 'p11',
    //   title: 'Cary Bag',
    //   description: 'Smarter Shopping, Better Living! Aliexpress.com',
    //   price: 45.8,
    //   imageUrl:
    //       'https://ae01.alicdn.com/kf/H9bad6b85b60a403f83ec28ff61bc60f7L/Mixi-Men-One-Shoulder-Backpack-Women-Sling-Bag-USB-Boys-Cycling-Sports-Travel-Versatile-Fashion-Bag.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'Mobile',
    //   description: 'Designed for those who work',
    //   price: 49.99,
    //   imageUrl: 'https://static.toiimg.com/photo/73078527.cms',
    // ),
    // Product(
    //   id: 'p12',
    //   title: 'Watch',
    //   description: 'Light weight high quality watch',
    //   price: 45.8,
    //   imageUrl:
    //       'https://www.toptrendsguide.com/wp-content/uploads/2020/03/Best-Luxury-Watch-Brands-For-Men.jpg',
    // ),
  ];
  final String authToken;
  final String userId;

  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((item) => item.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString = filterByUser ? '&orderBy="creatorId"&equalTo="$userId"' : '';
    final url =
        'https://e-shopping-20728.firebaseio.com/products.json?auth=$authToken$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      if (extractedData == null) {
        return;
      }
      final favoriteResponse = await http.get(
          'https://e-shopping-20728.firebaseio.com/userFavorites/$userId.json?auth=$authToken');
      final favoriteData = json.decode(favoriteResponse.body);
      extractedData.forEach((key, value) {
        loadedProducts.add(Product(
          id: key,
          title: value['title'],
          description: value['description'],
          price: value['price'],
          isFavorite: favoriteData == null ? false : favoriteData[key] ?? false,
          imageUrl: value['imageUrl'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      print('Error is : ' + error.toString());
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://e-shopping-20728.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'creatorId': userId,
          }));

      final newProduct = Product(
        title: product.title,
        imageUrl: product.imageUrl,
        price: product.price,
        description: product.description,
        id: json.decode(response.body)['name'],
      );
      _items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final url =
        'https://e-shopping-20728.firebaseio.com/products/$id.json?auth=$authToken';
    try {
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
      final productIndex = _items.indexWhere((element) => element.id == id);
      if (productIndex >= 0) {
        _items[productIndex] = newProduct;
        notifyListeners();
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://e-shopping-20728.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    existingProduct = null;
  }
}
