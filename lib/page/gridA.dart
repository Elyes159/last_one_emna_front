import 'package:flutter/material.dart';
import 'package:untitled2/page/page/productpage.dart';

class GridA extends StatefulWidget {
  const GridA({Key? key}) : super(key: key);

  @override
  _GridAState createState() => _GridAState();
}

class _GridAState extends State<GridA> {
  late List<bool> showFullTitles;
  late List<bool> favoriteStates;

  @override
  void initState() {
    super.initState();
    // Initialiser la liste showFullTitles avec des valeurs par défaut à false
    showFullTitles = List.generate(4, (_) => false);
    favoriteStates = List.generate(4, (_) => false);
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
        "price": "TND299",
        "title": "Cecotec blender power",
        "imagePath": "assets/images/select1(1).jpg",
      },
      {
        "title": "Casque celly kidsbeat ",
        "price": "TND42",
        "imagePath": "assets/images/select2.jpg",
      },
      {
        "title": "Smartphone IKU A6",
        "price": "TND191",
        "imagePath": "assets/images/select3.jpg",
      },
      {
        "title": "Carte mere MSI B560M-A",
        "price": "TND299",
        "imagePath": "assets/images/select4.jpg",
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 0.0,
            mainAxisExtent: 235,
          ),
          itemCount: gridMap.length > 4 ? 4 : gridMap.length,
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
                      top:
                          17, // Ajustez la position supérieure de l'icône de cœur
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
        ),
      ],
    );
  }
}
