import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/page/favourites.dart';
import 'package:untitled2/page/home.dart';
import 'package:http/http.dart' as http;
import 'package:untitled2/page/panier.dart';
import 'package:untitled2/page/parametre.dart';
import 'package:untitled2/page/recheche.dart';
import 'package:untitled2/page/sidebar.dart';

class ProductPage extends StatefulWidget {
  final String Nom;
  final String id;
  final Null Montant_HT;
  final Null Montant_TTC;
  final String  Image;
  final int quantite;
  final int Etat;
  final String  type;
  final List<dynamic> categorie;
  final String reference;
  

  ProductPage({
    required this.Nom,
    required this.id,
    required this.Montant_HT,
    required this.Montant_TTC,
    required this.Image,
    required this.quantite,
    required this.Etat,
    required this.type,
    required this.categorie,
    required this.reference
   
  });

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  String selectedImage = 'assets/images/TV1.jpg';

  int number = 1;
  bool isFavorited = false;
  double prixActuel = 799; // Prix actuel du produit
  double pourcentageRemise = 11; // Pourcentage de remise sur le produit
  double calculerPrixAvantRemise() {
    return prixActuel / (1 - (pourcentageRemise / 100));
  }

  void changeSelectedImage(String newImage) {
    setState(() {
      selectedImage = newImage;
    });
  }

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
        String apiUrl = "http:// 192.168.1.15:3003/user/favorites/$userId";
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
      Uri.parse("http://192.168.1.15:3003/user/getuserbytoken/$token"),
      headers: headers,
    );
    print("tokennnnnn : $token");
    if (resp.statusCode == 200) {
      print("houni : 200");
      print(token);
      // Vérifier si le corps de la réponse n'est pas vide
      if (resp.body.isNotEmpty) {
        final userData = jsonDecode(resp.body);
        final userId = userData['_id'] ;
        print("useeeeeeeeeeeeeer   $userId");
        return userId;
      } else {
        print('Le corps de la réponse est vide');
        return null;
      }
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

 Future<void> addToCart(String userId, String productId, int quantite) async {
  String? token = await getTokenFromSharedPreferences();
  if (token != null) {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', 
    };

    try {
      final url = Uri.parse(
        "http://192.168.1.15:3003/user/add-to-cart/$userId/$productId",
      );
      final resp = await http.put(
        url,
        headers: headers,
        body: jsonEncode({
          "quantite" : quantite
        }), // Empty body since you're sending quantite as a query parameter
      );
      if (resp.statusCode == 200) {
        print('Produit ajouté au panier avec succès');
      } else {
        print('Erreur: ${resp.statusCode} - ${resp.body}'); // Provide more context
      }
    } catch (e) {
      print('Erreur: $e');
    }
  } else {
    print('Token non trouvé localement');
  }
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
            automaticallyImplyLeading: false, 
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
              size: 52, 
              color: Colors.white, 
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
                          offset: Offset(142, 17),
                          child: Text(
                            'Produit',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(-45, 22),
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
                  SizedBox(height: 25),
                  Stack(
                    children: [
                      Container(
                        height: 250,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(2, 3),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: IconButton(
                          icon: Icon(
                            isFavorited
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isFavorited ? Colors.red : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              // Toggle the isFavorited state
                              isFavorited = !isFavorited;
                            });
                          },
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 7,
                        bottom: 10,
                        child: Center(
                          child: Image.network(
                            widget.Image,
                            width: 300,
                            height: 300,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.network(
                            widget.Image,
                            width: 50,
                            height: 50,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Image.network(
                            widget.Image,
                            width: 50,
                            height: 50,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Image.network(
                            widget.Image,
                            width: 50,
                            height: 50,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  // Affichage du prix
                  Row(
                    children: [
                      Transform.translate(
                        offset: Offset(33, 18),
                        child: Text(
                          'TND ',
                          style: TextStyle(
                            color: Color(0xFF006583),
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(width: 2),
                      Transform.translate(
                        offset: Offset(28, 14),
                        child: Text(
                          "${widget.Montant_HT}",
                          style: TextStyle(
                            color: Color(0xFF006583),
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(33, 18),
                        child: Text(
                          'TND ${widget.Montant_TTC}',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: Colors.red,
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(40, 14),
                        child: Positioned(
                          top: 10,
                          left: 12,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Color(0xFFF6D776),
                              borderRadius: BorderRadius.circular(10),
                            ),
                           
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Transform.translate(
                        offset: Offset(33, 18),
                        child: Text(
                          widget.Nom,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Transform.translate(
                        offset: Offset(33, 18),
                        child: Text(
                          'SKU: ${widget.reference}',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  // Affichage du prix
                  Row(
                    children: [
                      Transform.translate(
                        offset: Offset(33, 18),
                        child: Text(
                          'Stock:  ',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      widget.Etat == 1
                          ? Transform.translate(
                              offset: Offset(33, 18),
                              child: Text(
                                'Disponible',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ))
                          : Transform.translate(
                              offset: Offset(33, 18),
                              child: Text(
                                'Stockout',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 235, 3, 3),
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                      Transform.translate(
                        offset: Offset(43, 18),
                        child: Row(
                          // Pour minimiser l'espace
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              // Utilisation d'ElevatedButton pour le bouton de soustraction
                              onPressed: () {
                                if (number > 1) {
                                  setState(() {
                                    number--;
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color(0xFFF6D776), // Couleur de fond
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      6), // Bordure arrondie
                                ),
                                padding: EdgeInsets.all(
                                    6), // Ajustement de l'espacement interne
                                minimumSize:
                                    Size(15, 15), // Taille minimale du bouton
                              ),
                              child: Icon(
                                Icons.remove,
                                size: 20,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: 5),
                            Text(
                              number.toString(),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: 5),
                            ElevatedButton(
                              // Utilisation d'ElevatedButton pour le bouton d'addition
                              onPressed: () {
                                setState(() {
                                  number++;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color(0xFFF6D776), // Couleur de fond
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      6), // Bordure arrondie
                                ),
                                padding: EdgeInsets.all(
                                    5), // Ajustement de l'espacement interne
                                minimumSize:
                                    Size(10, 10), // Taille minimale du bouton
                              ),
                              child: Icon(
                                Icons.add,
                                size: 20,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 12),
                  Column(
                    children: [
                      Transform.translate(
                        offset: Offset(33, 18),
                      
                      ),
                      SizedBox(height: 50),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PanierPage(
                                      id: widget.id,

                                      quantite:number,
                                    )),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30.0),
                          child: Container(
                            height: 45,
                            width: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  25), // BorderRadius pour le coin arrondi
                              color: Color(0xFF006E7F), // Couleur de fond
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey
                                      .withOpacity(0.7), // Couleur de l'ombre
                                  spreadRadius: 2, // Rayon de propagation
                                  blurRadius: 5, // Rayon de flou
                                  offset: Offset(0, 2), // Décalage de l'ombre
                                ),
                              ],
                            ),
                            child: MaterialButton(
                              onPressed: () async {
                                String? token =
                                    await getTokenFromSharedPreferences();
                                print(token);
                                if (token != null) {
                                  String? userId =
                                      await getUserIdFromToken(token);
                                      
                                  if (userId != null) {
                                    print("user wsell : $userId");
                                    // Ici, vous pouvez remplacer "productId" par l'ID réel du produit que vous souhaitez ajouter au panier
                                    String productId = widget.id;
                                    print("product wsel : $productId");
                                    await addToCart(userId, productId,number);
                                    Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PanierPage(
                                            id: widget.id,
                                            quantite : number,
                                          )),
                                );
                                  } else {
                                    print(
                                        'Impossible de récupérer l\'ID de l\'utilisateur');
                                  }
                                } else {
                                  print('Token non trouvé localement');
                                }
                                
                              },
                              child: Text('Ajouter au panier',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                
                 
                 
                  SizedBox(height: 35),
                 
                  SizedBox(height: 36.0),
                  Padding(
                    padding: EdgeInsets.all(1.0),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
  decoration: BoxDecoration(
    color: Color(0xFFEFEFEF),
    borderRadius: BorderRadius.vertical(
      top: Radius.circular(55.0),
    ),
  ),
  child: BottomNavigationBar(
    currentIndex: 4,
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.search),
        label: 'recherche',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.card_giftcard),
        label: 'panier',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person), 
        label: 'profile',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.account_circle), 
        label: 'favoris',
      ),
    ],
    selectedItemColor: Colors.black,
    unselectedItemColor: Color(0xFF006583),
    showSelectedLabels: true,
    showUnselectedLabels: true,
    onTap: (index) {
      switch (index) {
        case 0:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RecherchePage()),
          );
          break;
        case 1:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PanierPage(id: '',quantite: 0,)),
          );
          break;
        case 2:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Home()),
          );
          break;
        case 3:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage()),
          );
          break;
      }
    },
  ),
),

      endDrawer: NavBar(),
    );
  }
}

Widget buildImageSelector(
    String imagePath, Function(String) changeSelectedImage) {
  return GestureDetector(
    onTap: () {
      changeSelectedImage(imagePath);
    },
    child: Positioned(
      top: 0,
      left: 0,
      right: 7,
      bottom: 10,
      child: Container(
        margin: EdgeInsets.only(right: 10),
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Color(0xFF9F9F9F),
            width: 1,
          ),
        ),
        child: Image.asset(
          imagePath,
          width: 20,
          height: 20,
          fit: BoxFit.cover,
        ),
      ),
    ),
  );
}

class ReadMoreText extends StatefulWidget {
  final String text;
  final int trimLines;
  final String trimCollapsedText;
  final String trimExpandedText;
  final TextStyle style;
  final TextStyle lessStyle;
  final TextStyle moreStyle;
  final TextAlign textAlign;
  final TrimMode trimMode;

  ReadMoreText(
    this.text, {
    Key? key,
    required this.trimLines,
    this.trimCollapsedText = 'Show More',
    this.trimExpandedText = 'Show Less',
    required this.style,
    required this.lessStyle,
    required this.moreStyle,
    this.textAlign = TextAlign.left,
    this.trimMode = TrimMode.Line,
  }) : super(key: key);

  @override
  _ReadMoreTextState createState() => _ReadMoreTextState();
}

enum TrimMode { Line, Length }

class _ReadMoreTextState extends State<ReadMoreText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final defaultTextStyle = DefaultTextStyle.of(context).style;

    Widget textWidget = Text(
      widget.text,
      style: widget.style ?? defaultTextStyle,
      maxLines: (!_isExpanded && widget.trimMode == TrimMode.Length)
          ? widget.trimLines
          : null,
      textAlign: widget.textAlign,
    );

    return LayoutBuilder(
      builder: (context, size) {
        final span = TextSpan(text: widget.text, style: widget.style);
        final tp = TextPainter(
            text: span,
            maxLines: widget.trimLines,
            textDirection: TextDirection.ltr);
        tp.layout(maxWidth: size.maxWidth);

        if (!tp.didExceedMaxLines && widget.trimMode == TrimMode.Line) {
          return textWidget;
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textWidget,
            InkWell(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 40.0),
                  child: Text(
                    _isExpanded
                        ? widget.trimExpandedText
                        : widget.trimCollapsedText,
                    style: _isExpanded
                        ? widget.lessStyle
                            .copyWith(decoration: TextDecoration.underline)
                        : widget.moreStyle
                            .copyWith(decoration: TextDecoration.underline),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
