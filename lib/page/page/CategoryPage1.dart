import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:untitled2/page/home.dart';
import 'package:untitled2/page/page/favoris.dart';
import 'package:untitled2/page/page/productpage.dart';
import 'package:untitled2/page/panier.dart';
import 'package:untitled2/page/parametre.dart';
import 'package:untitled2/page/recheche.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled2/page/sidebar.dart';

class CategoryPage1 extends StatefulWidget {
  final String Categorie;

  const CategoryPage1({Key? key, required this.Categorie}) : super(key: key);

  @override
  _CategoryPage1State createState() => _CategoryPage1State();
}

class _CategoryPage1State extends State<CategoryPage1> {
  List<dynamic> categories = [
    // {'title': 'Eléctromenagers', 'imagePath': 'assets/images/menager1.png'},
    //{'title': 'TV', 'imagePath': 'assets/images/tele.png'},
    //{'title': 'Smartphones', 'imagePath': 'assets/images/smartphones.png'},
    // {'title': 'Bureautiques', 'imagePath': 'assets/images/bureau.png'},
    // {'title': 'Infomatique', 'imagePath': 'assets/images/info.png'},
    // {'title': 'Impression', 'imagePath': 'assets/images/imprimante.png'},
    //{'title': 'Jeux vidéo', 'imagePath': 'assets/images/video.png'},
    //{'title': 'Santé & Beauté', 'imagePath': 'assets/images/beaute.png'},
    //{'title': 'Maison & Brico', 'imagePath': 'assets/images/maisonn.png'},
    //{'title': 'Sport & Loisir', 'imagePath': 'assets/images/sport.png'},
    //{'title': 'Animalerie', 'imagePath': 'assets/images/animalerie.png'}
  ];

  Future<void> fetchFavoriteProducts() async {
    String apiUrl = "http://192.168.1.17:3003/categorie/categorie";
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          categories = jsonDecode(response.body);
        });
      } else {
        print(
            "Erreur lors de la récupération des produits favoris: ${response.statusCode}");
      }
    } catch (e) {
      print("Erreur lors de la récupération des produits favoris: $e");
    }
  }

  @override
  void initState() {
    fetchFavoriteProducts();
    print(" list  : $categories");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF006583),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: ClipRRect(
          child: AppBar(
            backgroundColor: Color(0xFF006583),
            automaticallyImplyLeading: false, // This will remove the back arrow
            title: Container(
              child: Transform.translate(
                offset: Offset(-60.0, 0.0),
                child: Transform.scale(
                  scale: 0.7,
                  child: Image.asset('assets/images/logo.jpg'),
                ),
              ),
            ),
            iconTheme: IconThemeData(
              size: 52, // Adjust the size of the drawer icon here
              color: Colors.white, // Adjust the color of the drawer icon here
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Color(0xFF006583),
          ),
          Positioned.fill(
            child: Transform.translate(
              offset: Offset(0, 3),
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Color(0xFFEFEFEF),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(50.0),
                      // Radius pour les coins supérieurs
                      bottom: Radius.circular(50.0),
                      // Radius pour les coins inférieurs
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: GridB(Categorie: widget.Categorie),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFFEFEFEF),
        selectedItemColor: Color(0xFF006E7F),
        unselectedItemColor: Color(0xFF006E7F),
        selectedLabelStyle: TextStyle(color: Color(0xFF006E7F)),
        type: BottomNavigationBarType.fixed,
        items: [
          bottomNavigationBarItem(
            image: 'assets/images/recherche.png',
            label: 'Recherche',
            page: RecherchePage(),
          ),
          bottomNavigationBarItem(
            image: 'assets/images/maison.png',
            label: 'Accueil',
            page: Home(),
          ),
          bottomNavigationBarItem(
            image: 'assets/images/heart.png',
            label: 'Favoris',
            page: FavorisPage(),
          ),
          bottomNavigationBarItem(
            image: 'assets/images/utilisateur.png',
            label: 'Profil',
            page: ProfilePage(),
          ),
        ],
      ),
      endDrawer: NavBar(),
    );
  }

  BottomNavigationBarItem bottomNavigationBarItem({
    required String image,
    required String label,
    required Widget page,
  }) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(top: 5, right: 2),
        child: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          },
          icon: Image.asset(
            image,
            width: 30,
            height: 30,
          ),
        ),
      ),
      label: label,
    );
  }
}

class GridB extends StatefulWidget {
  final String Categorie;
  const GridB({Key? key, required this.Categorie}) : super(key: key);

  @override
  _GridBState createState() => _GridBState();
}

class _GridBState extends State<GridB> {
  late List<bool> showFullTitles;
  late List<bool> favoriteStates;
  late Future<List<dynamic>> futureProducts;

  @override
  void initState() {
    super.initState();
    // Initialiser la liste showFullTitles avec des valeurs par défaut à false
    showFullTitles = List.generate(4, (_) => false);
    favoriteStates = List.generate(4, (_) => false);
    futureProducts = getProducts();
  }

  Future<List<dynamic>> getProducts() async {
    final response =
        await http.get(Uri.parse("http://192.168.1.17:3003/product/products"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      favoriteStates = List.generate(data.length,
          (_) => false); // Generate favoriteStates based on data length
      return data;
    } else {
      throw Exception('Failed to get data: ${response.statusCode}');
    }
  }

  void toggleFavoriteState(int index) {
    setState(() {
      favoriteStates[index] = !favoriteStates[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Home()),
              (Route<dynamic> route) => false,
            );
            // Retour à la page précédente (page d'accueil)
          },
          icon: Image.asset(
            'assets/images/flech1.png', // Remplacez 'home_icon.png' par le chemin de votre icône de page d'accueil
            width: 30,
            height: 30,
          ),
        ),
        FutureBuilder<List<dynamic>>(
          future: futureProducts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final List<dynamic> gridMap = snapshot.data!;
              final filteredGridMap = gridMap
                  .where((item) => item['Categorie'] == widget.Categorie)
                  .toList();

              if (filteredGridMap.isEmpty) {
                return Container(); // Retourner une vue vide si aucun produit de type "Meilleures Ventes" n'est trouvé
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      mainAxisExtent: 200,
                    ),
                    itemCount: filteredGridMap.length,
                    itemBuilder: (_, index) {
                      final item = filteredGridMap[index];
                      final isFavorite = favoriteStates[index];
                      final String? imageData = item['Image'] as String?;

                      // Convertir la chaîne de caractères en Uint8List
                      // Vous devez importer 'dart:convert' pour utiliser base64Decode

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductPage(
                                  Nom: item['Nom'],
                                  id: item['_id'],
                                  Montant_HT: item['Montant HT'],
                                  Montant_TTC: item['Montant TTC'],
                                  quantite: item['Quantité'],
                                  Etat: item['État'],
                                  categorie: item['categorie'],
                                  Image: item['Image'],
                                  type: item['type'],
                                  reference: item['Référence']),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          margin: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 8.0, top: 8),
                                child: Center(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        toggleFavoriteState(index);
                                      },
                                      child: Image.asset(
                                        isFavorite
                                            ? 'assets/images/cor.png'
                                            : 'assets/images/hear.png',
                                        width: 24,
                                        height: 24,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20.0),
                                  ),
                                  child: imageData != null
                                      ? Image.network(
                                          imageData,
                                          fit: BoxFit.cover,
                                        )
                                      : Placeholder(), // Vous pouvez remplacer Placeholder() par n'importe quel widget ou message que vous souhaitez afficher pour les images nulles
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: item['Nom'] != null
                                    ? Text(
                                        item['Nom']!,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF666666),
                                          fontSize: 14,
                                        ),
                                      )
                                    : Text("Title not available"),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'TND ${item['Montant HT']}',
                                      style: TextStyle(
                                        color: Color(0xFF006583),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
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
          },
        )
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

  static String _truncateTitle(String title, int maxLength) {
    if (title.length > maxLength) {
      int lastIndex = title.lastIndexOf(' ', maxLength);
      return title.substring(0, lastIndex) + '...';
    }
    return title;
  }
}
