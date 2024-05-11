// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:untitled2/page/home.dart';
import 'package:untitled2/page/page/OrderDetails.dart';
import 'package:untitled2/page/page/favoris.dart';
import 'package:untitled2/page/paiment.dart';
import 'package:untitled2/page/parametre.dart';
import 'package:untitled2/page/recheche.dart';
import 'package:untitled2/page/sidebar.dart';
import 'package:url_launcher/url_launcher.dart';

class PanierPage extends StatefulWidget {
  final String id;
  final int quantite;

  const PanierPage({Key? key, required this.id, required this.quantite}) : super(key: key);

  @override
  State<PanierPage> createState() => _PanierPageState();
  
}

class _PanierPageState extends State<PanierPage> {
  
  List<dynamic> cartProducts = []; // Liste pour stocker les produits du panie

  Future<void> fetchCartProducts() async {
    // Récupérer le token de l'utilisateur depuis les préférences partagées
    String? token = await getTokenFromSharedPreferences();
    if (token != null) {
      // Récupérer l'ID de l'utilisateur à partir du token
      String? userId = await getUserIdFromToken(token);
      if (userId != null) {
        // Construire l'URL de l'API pour récupérer les produits du panier de l'utilisateur
        String apiUrl = "http://192.168.1.15:3003/user/get-cart/$userId";
        try {
          // Effectuer une requête HTTP GET pour récupérer les produits du panier
          final response = await http.get(Uri.parse(apiUrl));
          if (response.statusCode == 200) {
            // Mettre à jour la liste des produits du panier avec les données récupérées
            setState(() {
              cartProducts = jsonDecode(response.body);
              print("ici : $cartProducts");
            });
          } else {
            print(
                "Erreur lors de la récupération des produits du panier: ${response.statusCode}");
          }
        } catch (e) {
          print("Erreur lors de la récupération des produits du panier: $e");
        }
      } else {
        print('Impossible de récupérer l\'ID de l\'utilisateur');
      }
    } else {
      print('Token non trouvé localement');
    }
  }

  Future<String?> getTokenFromSharedPreferences() async {
    // Récupérer le token de l'utilisateur depuis les préférences partagées
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> getUserIdFromToken(String token) async {
    // Construire les en-têtes de la requête HTTP
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    try {
      // Effectuer une requête HTTP GET pour récupérer l'ID de l'utilisateur à partir du token
      final resp = await http.get(
        Uri.parse("http://192.168.1.15:3003/user/getuserbytoken/$token"),
        headers: headers,
      );
      if ((resp.statusCode == 200) ||(resp.statusCode==201)) {
        // Analyser la réponse JSON pour extraire l'ID de l'utilisateur
        final userData = jsonDecode(resp.body);
        final userId = userData['_id'] as String;
        return userId;
      } else {
        print("hedha token : $token");
        print(
            'Erreur lors de la récupération de l\'ID de l\'utilisateur: ${resp.body}');
        return null;
      }
    } catch (e) {
      print('Erreur lors de la récupération de l\'ID de l\'utilisateur: $e');
      return null;
    }
  }
    void initState() {
    super.initState();
fetchCartProducts();
  }


  

  @override
  Widget build(BuildContext context) {
    double totalMontantHT = 0.0;
    if(cartProducts.isNotEmpty) {
      for (int i = 0; i < cartProducts.length; i++) {
        totalMontantHT += (cartProducts[i]["productDetails"]['Montant HT'] ?? 0) * (cartProducts[i]["quantity"] ?? 0);
      }
    }
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
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFEFEFEF), // Couleur de fond du corps
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(55), // Coin supérieur gauche arrondi
              topRight: Radius.circular(55), // Coin supérieur droit arrondi
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Transform.translate(
                  offset: Offset(-15, 12),
                  child: Text(
                    'Votre panier',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Transform.translate(
                  offset: Offset(-150, -25), // Ajuster la marge en haut et à gauche de l'icône
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black), // Utilisation de l'IconButton avec l'icône de retour
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                
                  Container(
                    height: MediaQuery.of(context).size.height * 0.6, // Hauteur définie à 60% de la hauteur de l'écran
                    child: ListView.builder(
                      itemCount: cartProducts.length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(color: Color(0xFF9F9F9F)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Transform.translate(
                                offset: Offset(1, -4),
                                child: Image.network(
                                  cartProducts[index]["productDetails"]['Image'] ?? "",
                                  width: 110,
                                  height: 900,
                                ),
                              ),
                              SizedBox(width: 1),
                              Expanded(
                                child: Transform.translate(
                                  offset: Offset(2, 7),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        cartProducts[index]["productDetails"]['Nom'] ?? "", // Nom du produit
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text("${cartProducts[index]["quantity"]}"),
                                      SizedBox(height: 5),
                                      Transform.translate(
                                        offset: Offset(195, -25),
                                        child: InkWell(
                                          onTap: () async {
                                            String? token = await getTokenFromSharedPreferences();
                                            print(token);
                                            if (token != null) {
                                              String? userId = await getUserIdFromToken(token);
                                              if (userId != null) {
                                                print("user wsell : $userId");
                                                String productId = cartProducts[index]["productDetails"]["_id"] ?? "";
                                                print("product wsel : $productId");
                                                await deleteCartProduct(userId, productId);
                                              }
                                            }
                                          },
                                          child: Image.asset(
                                            'assets/images/corbeille.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        ),
                                      ),
                                      Transform.translate(
                                        offset: Offset(150, -5),
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'TND ',
                                                style: TextStyle(
                                                  fontSize: 13.0,
                                                  color: Color(0xFF006E7F),
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              TextSpan(
                                                text: ((cartProducts[index]["productDetails"]['Montant HT'] ?? 0) * (cartProducts[index]["quantity"] ?? 0)).toString(), // Convertir en chaîne
                                                style: TextStyle(
                                                  fontSize: 29.0,
                                                  color: Color(0xFF006E7F),
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                SizedBox(height: 450),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Transform.translate(
                        offset: Offset(10, -95),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Total',
                                style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF006E7F),
                                ),
                              ),
                              Transform.translate(
                                offset: Offset(242, -35),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'TND ',
                                        style: TextStyle(
                                          color: Color(0xFF006E7F),
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '$totalMontantHT', // Prix actuel du produit
                                        style: TextStyle(
                                          color: Color(0xFF006E7F),
                                          fontSize: 29,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF006E7F), // Couleur de fond du bouton
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8), // Ajustez le rembourrage selon vos besoins
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // Ajustez le rayon de la bordure selon vos besoins
                    ),
                  ),
                  onPressed: ()  {
                    Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaymentPage(cartProduct: cartProducts,prixtotal :totalMontantHT )),
                );
                    
                  },
                  child: SizedBox(
                    width: 120,
                    child: Center(
                      child: Text(
                        'Valider',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
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
      endDrawer: NavBar(),
    );
  }
}

Future<void> deleteCartProduct(String userId, String itemId) async {
  try {
    final response = await http.delete(
      Uri.parse("http://192.168.1.15:3003/user/delete-cart-item/$userId/$itemId"),
    );
    if (response.statusCode == 200) {
      print("Effacé avec succès");
    } else {
      print('Erreur lors de la suppression de l\'article du panier: ${response.body}');
    }
  } catch (e) {
    print('Erreur lors de la suppression de l\'article du panier: $e');
  }
}

