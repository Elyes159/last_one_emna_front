import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:untitled2/page/home.dart';

import 'package:untitled2/page/page/productpage.dart';
import 'package:untitled2/page/parametre.dart';
import 'package:untitled2/page/recheche.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FavorisPage(),
    );
  }
}

class FavorisPage extends StatefulWidget {
  const FavorisPage({Key? key}) : super(key: key);

  @override
  State<FavorisPage> createState() => _FavorisPageState();
}

class _FavorisPageState extends State<FavorisPage> {
  int number = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF006E7F),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(130),
        child: ClipRRect(
          child: Container(
            color: Color(0xFF006E7F),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Row(
                  children: [
                    Transform.translate(
                      offset: Offset(32, 23),
                      child: Image.asset(
                        'assets/images/logo.png',
                        scale: 7,
                      ),
                    ),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Transform.translate(
                          offset: Offset(-140, 53),
                          child: Text(
                            'Bonjour Marwa',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Transform.translate(
                      offset: Offset(-10, 25),
                      child: IconButton(
                        icon: Image.asset(
                          'assets/images/menu.png',
                          width: 35,
                          height: 35,
                        ),
                        color: Colors.white,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFEFEFEF),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(55),
              topRight: Radius.circular(55),
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Transform.translate(
                          offset: Offset(112, 17),
                          child: Text(
                            'Liste des favoris',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(
                              -140, 22),
                          child: Image.asset(
                            'assets/images/flech1.png',
                            width: 26,
                            height: 26,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 36.0,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: GridB(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        // Votre RenderCustomMultiChildLayoutBox ici


        decoration: BoxDecoration(
          color: Color(0xFFEFEFEF),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(55.0),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Color(0xFFEFEFEF),
          selectedItemColor: Color(0xFF006E7F),
          unselectedItemColor: Color(0xFF006E7F),
          selectedLabelStyle: TextStyle(color: Color(0xFF006E7F)),
          type: BottomNavigationBarType.fixed,
          items: [
            bottomNavigationBarItem(
              image: 'assets/images/recherche.png',
              label: 'Recherche',
              context: context,
              page: RecherchePage(),
            ),
            bottomNavigationBarItem(
              image: 'assets/images/maison.png',
              label: 'Accueil',
              context: context,
              page: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width, // Limite la largeur au maximum de l'écran
                ),
                child: SingleChildScrollView(
                  child: Home(), 
                ),
              ),
            ),
            bottomNavigationBarItem(
              image: 'assets/images/hearti.png',
              label: 'Favoris',
              context: context,
              page: FavorisPage(),
            ),
            bottomNavigationBarItem(
              image: 'assets/images/utilisateur.png',
              label: 'Profil',
              context: context,
              page: ProfilePage(),
            ),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem bottomNavigationBarItem({
    required String image,
    required String label,
    required BuildContext context,
    required Widget page,
  }) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(right: 2),
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

class FabExt extends StatelessWidget {
  const FabExt({
    Key? key,
    required this.showFabTitle,
  }) : super(key: key);

  final bool showFabTitle;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {},
      label: AnimatedContainer(
        duration: const Duration(seconds: 2),
        padding: const EdgeInsets.all(12.0),
      ),
    );
  }
}

class GridB extends StatefulWidget {
  const GridB({Key? key}) : super(key: key);

  @override
  _GridBState createState() => _GridBState();
}

class _GridBState extends State<GridB> {
  late List<bool> showFullTitles;

  @override
  void initState() {
    super.initState();
    showFullTitles = List.generate(4, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> gridMap = [
      {
        "price": "TND799",
        "title": "TV SAMSUNG 32'' SMART-LED HD-T5300",
        "imagePath": "assets/images/img1.jpg",
        "discount": "11%",
      },
      {
        "title": "WHIRLPOOL PLAQUE CHAUFFANTE 4 Feux 60 CM",
        "price": "TND323.4",
        "imagePath": "assets/images/img4.jpg",
        "discount": "40%",
      },
      {
        "title": "PC Portable LENOVO IdeapPad AMD RYZEN 3 8GO",
        "price": "TND439.6",
        "imagePath": "assets/images/img2.jpg",
        "discount": "60%",
      },
      {
        "title": "CARTE GRAPHIQUE GIGABYTE GEFORCE RTX2060",
        "price": "TND159.3",
        "imagePath": "assets/images/img3.jpg",
        "discount": "30%",
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
            mainAxisExtent: 290,
          ),
          itemCount: gridMap.length > 4 ? 4 : gridMap.length,
          itemBuilder: (_, index) {
            final item = gridMap[index];
            final showFullTitle = showFullTitles[index];
            final title = showFullTitle
                ? item['title']
                : _truncateTitle(item['title'], 30);
            return GestureDetector(
              onTap: () {
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
                          height: 170,
                          width: 300,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Container(
                                margin: EdgeInsets.only(bottom: 8.0),
                                child: Image.asset(
                                  item['imagePath'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                                  title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF666666),
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              Transform.translate(
                                offset: Offset(117, -43),
                                child: IconButton(
                                  onPressed: () {
                                    // Action à effectuer lors du clic sur l'icône du panier
                                  },
                                  icon: Icon(
                                    Icons.shopping_cart,
                                    size: 18,
                                    color: Color(
                                        0xFF006583),
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
                      top: 17,
                      right: 10,
                      child: Image.asset(
                        'assets/images/cor.png',
                        width: 22,
                        height: 22,
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
