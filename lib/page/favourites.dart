import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<dynamic> favoriteProducts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFavoriteProducts();
  }

  Future<void> fetchFavoriteProducts() async {
    String? token = await getTokenFromSharedPreferences();
    if (token != null) {
      String? userId = await getUserIdFromToken(token);
      if (userId != null) {
        String apiUrl = "http://192.168.1.17:3003/user/favorites/$userId";
        try {
          final response = await http.get(Uri.parse(apiUrl));
          if (response.statusCode == 200) {
            setState(() {
              favoriteProducts = jsonDecode(response.body);
              isLoading = false;
            });
          } else {
            print(
                "Erreur lors de la récupération des produits favoris: ${response.statusCode}");
          }
        } catch (e) {
          print("Erreur lors de la récupération des produits favoris: $e");
        }
      } else {
        print('Impossible de récupérer l\'ID de l\'utilisateur');
      }
    } else {
      print('Token non trouvé localement');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes favoris'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : favoriteProducts.isEmpty
              ? Center(child: Text('Aucun produit favori'))
              : ListView.builder(
                  itemCount: favoriteProducts.length,
                  itemBuilder: (context, index) {
                    final product = favoriteProducts[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(product['Image']),
                      ),
                      title: Text(product['Nom']),
                      subtitle: Text("${product['Product ID']}"),
                      // Ajoutez d'autres informations sur le produit selon votre modèle de données
                    );
                  },
                ),
    );
  }
}

Future<String?> getTokenFromSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

Future<String?> getUserIdFromToken(String token) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  try {
    final resp = await http.get(
      Uri.parse("http://192.168.1.17:3003/user/getuserbytoken/$token"),
      headers: headers,
    );
    if (resp.statusCode == 200) {
      final userData = jsonDecode(resp.body);
      final userId = userData['_id'] as String;
      return userId;
    } else {
      print(
          'Erreur lors de la récupération de l\'ID de l\'utilisateur: ${resp.statusCode}');
      return null;
    }
  } catch (e) {
    print('Erreur lors de la récupération de l\'ID de l\'utilisateur: $e');
    return null;
  }
}
