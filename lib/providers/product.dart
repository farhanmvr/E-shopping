import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.description,
    @required this.imageUrl,
    @required this.price,
    @required this.title,
    this.isFavorite = false,
  });

  void _setFavValure(bool newVal) {
    isFavorite = newVal;
    notifyListeners();
  }

  Future<void> toggleFav(String authToken ,String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = 'https://e-shopping-20728.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken';
    try {
      final response = await http.put(url,
          body: json.encode(
            isFavorite,
          ));
      if (response.statusCode >= 400) {
        _setFavValure(oldStatus);
      }
    } catch (error) {
      _setFavValure(oldStatus);
    }
  }
}
