import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:untitled2/page/page/productpage.dart';

class GriA extends StatefulWidget {
  const GriA({Key? key}) : super(key: key);

  @override
  _GriAState createState() => _GriAState();
}

class _GriAState extends State<GriA> {
  late List<bool> showFullTitles;
  late List<bool> favoriteStates;
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
        "price": "TND799",
        "title": "TV SAMSUNG 32'' SMART-LED HD-T5300",
        "imagePath": "assets/images/img1.jpg",
        "discount": "-11%",
      },
      {
        "title": "WHIRLPOOL PLAQUE CHAUFFANTE 4 Feux 60 CM",
        "price": "TND323.4",
        "imagePath": "assets/images/img4.jpg",
        "discount": "-40%",
      },
      {
        "title": "PC Portable LENOVO IdeapPad AMD RYZEN 3 8GO",
        "price": "TND439.6",
        "imagePath": "assets/images/img2.jpg",
        "discount": "-60%",
      },
      {
        "title": "CARTE GRAPHIQUE GIGABYTE GEFORCE",
        "price": "TND159.3",
        "imagePath": "assets/images/img3.jpg",
        "discount": "-30%",
      },
      {
        "title": "CARTE GRAPHIQUE GIGABYTE GEFORCE",
        "price": "TND159.3",
        "imagePath": "assets/images/img3.jpg",
        "discount": "-30%",
      },
      {
        "title": "WHIRLPOOL PLAQUE CHAUFFANTE 4 Feux 60 CM",
        "price": "TND323.4",
        "imagePath": "assets/images/img4.jpg",
        "discount": "-40%",
      },
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 0.0,
        mainAxisExtent: 250,
      ),
      itemCount: gridMap.length,
      itemBuilder: (_, index) {
        final item = gridMap[index];

        final isFavorite = favoriteStates[index];
        return GestureDetector(
          onTap: () {
            // Utilisez Navigator.push pour naviguer vers la page produit
            Navigator.push(
              context,
               MaterialPageRoute(
                    builder: (context) => ProductPage(
                      Nom: item['Nom'],
                      id: item['_id'],
                      Montant_HT: item['Montant_HT'],
                      Montant_TTC: item['Montant_TTC'],
                      Image: item['Image'],
                      quantite: item['quantite'],
            Etat: item['Etat'],
                       type: item[' type'],
                      categorie: item['categorie'],
                      reference: item["Référence"],
                
                     
                    ),
                  ),
            );
          },
          child: Container(
            margin: EdgeInsets.only(top: 1.0),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 180,
                      width: 300,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20.0),
                            bottom: Radius.circular(30.0),
                          ),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10.0),
                            child: Image.asset(
                              item['imagePath'],
                              fit: BoxFit.cover,
                            ),
                          ),
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
                                offset: Offset(-7, -2),
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
                                offset: Offset(-9, -2),
                                child: Text(
                                  item['price'].substring(3),
                                  style: TextStyle(
                                    color: Color(0xFF006583),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Transform.translate(
                                offset: Offset(-2, -1),
                                child: Text(
                                  'TND ${_calculateDiscountedPrice(item['price'], item['discount'])}',
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
                            offset: Offset(-6, -1),
                            child: Text(
                              item['title'],
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF666666),
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 17,
                  left: 6,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Color(0xFFF6D776),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item['discount'],
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 17, // Ajustez la position supérieure de l'icône de cœur
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
              ],
            ),
          ),
        );
      },
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
