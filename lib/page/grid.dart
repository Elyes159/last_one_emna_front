import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Grid extends StatefulWidget {
  const Grid({Key? key}) : super(key: key);

  @override
  _GridState createState() => _GridState();
}

class _GridState extends State<Grid> {
  late List<bool> showFullTitles;
  late List<bool> favoriteStates;

  Future<List<dynamic>> getFunction(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body) as List<dynamic>;
      return decodedData;
    } else {
      throw Exception('Failed to get data: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialiser la liste showFullTitles avec des valeurs par défaut à false
    showFullTitles = List.generate(6, (_) => false);
    favoriteStates = List.generate(6, (_) => false);
  }

  void toggleFavoriteState(int index) {
    setState(() {
      favoriteStates[index] = !favoriteStates[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> gridMap = [
      {
        "price": "TND219",
        "title": "Hachoir à Viande Touch",
        "imagePath": "assets/images/ramadhan1.jpg",
        "discount": "-24%",
      },
      {
        "title": "KONIX DRAKKAR pack sorcerer",
        "price": "TND68",
        "imagePath": "assets/images/manette.jpg",
        "discount": "-34%",
      },
      {
        "title": "Montre connecté LINWEAR  ",
        "price": "TND149",
        "imagePath": "assets/images/montre.png",
        "discount": "-54%",
      },
      {
        "title": "Whirpool hotte murale",
        "price": "TND499",
        "imagePath": "assets/images/hotte.jpg",
        "discount": "-30%",
      },
      {
        "price": "TND799",
        "title": "TV SAMSUNG 32'' SMART-LED ",
        "imagePath": "assets/images/img1.jpg",
        "discount": "-11%",
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 270,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: gridMap.length,
            itemBuilder: (_, index) {
              final isFavorite = favoriteStates[index];
              return Stack(
                children: [
                  Container(
                    width: 160,
                    height: 160,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Container(
                          margin:
                              EdgeInsets.only(bottom: 15.0, left: 5, right: 5),
                          child: Image.asset(
                            gridMap[index]['imagePath'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Color(0xFFF6D776),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        gridMap[index]['discount'],
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top:
                        10, // Ajustez la position supérieure de l'icône de cœur
                    right: 10,
                    child: GestureDetector(
                      onTap: () {
                        // Appel de la méthode pour basculer l'état du produit favori
                        toggleFavoriteState(index);
                      },
                      child: Image.asset(
                        isFavorite
                            ? 'assets/images/cor.png'
                            : 'assets/images/hear.png', // Changez le chemin de l'image en fonction de l'état du produit favori
                        width: 22,
                        height: 22,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Transform.translate(
                              offset: Offset(-3, 164),
                              child: Text(
                                'TND ',
                                style: TextStyle(
                                  color: Color(0xFF006583),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(width: 2),
                            Transform.translate(
                              offset: Offset(-4, 162),
                              child: Text(
                                gridMap[index]['price'].substring(3),
                                style: TextStyle(
                                  color: Color(0xFF006583),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Transform.translate(
                              offset: Offset(1, 164),
                              child: Text(
                                'TND ${_calculateDiscountedPrice(gridMap[index]['price'], gridMap[index]['discount'])}',
                                style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: Colors.red,
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Transform.translate(
                          offset: Offset(-2, 160),
                          child: Text(
                            gridMap[index]['title'],
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF666666),
                              fontSize: 10,
                            ),
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(117, 110),
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              CupertinoIcons.cart,
                              size: 18,
                              color: Color(
                                  0xFF006583), // Couleur de l'icône du panier
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  String _calculateDiscountedPrice(String price, String discount) {
    double originalPrice = double.parse(price.substring(3));
    double discountPercentage = double.parse(discount.replaceAll('%', ''));
    double discountedPrice =
        originalPrice - (originalPrice * discountPercentage / 100);
    return discountedPrice.toStringAsFixed(1);
  }
}
