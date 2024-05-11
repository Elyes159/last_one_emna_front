import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart' as Material;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/page/home.dart';
import 'package:untitled2/page/page/suivrecommande.dart';
import 'package:untitled2/page/panier.dart';
import 'package:untitled2/page/parametre.dart';
import 'package:untitled2/page/recheche.dart';
import 'package:untitled2/page/sidebar.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentPage extends StatefulWidget {
  final List<dynamic> cartProduct;
  final double prixtotal;

  const PaymentPage({Material.Key? key, required this.cartProduct, required this.prixtotal}) : super(key: key);
  @override
  _PaymentPageState createState() => _PaymentPageState();
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
Future<void> clearCart(String userId) async {
  final url = Uri.parse('https://192.168.1.15:3003/clear-cart/$userId');

  try {
    final response = await http.delete(url);
    if (response.statusCode == 200) {
      print('Cart cleared successfully');
    } else {
      print('Failed to clear cart: ${response.reasonPhrase}');
    }
  } catch (error) {
    print('Error clearing cart: $error');
  }
}


Future<void> passerCommande(BuildContext context ,String id,String etat,String paiment,String Reference,String quantite) async {
  try {
    // Récupérer le token de l'utilisateur depuis les préférences partagées
    String? token = await getTokenFromSharedPreferences();
    if (token != null) {
      // Construire l'URL de l'API pour créer une commande
      String apiUrl = "http://192.168.1.15:3003/commande/createCommande";

      Map<String, dynamic> commandeData = {
        "idproduct":id ,
        "Etat" : etat,
        "quantité" : quantite,
        "paiment" :paiment,
        "Référence": Reference,

      };

      // Effectuer une requête HTTP POST pour créer la commande
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
        body: jsonEncode(commandeData),
      );
      
      if (response.statusCode == 200) {
        print("La commande a été créée avec succès");
        
      Future<String?> userId = getUserIdFromToken(token);
        
        
        // Mettre à jour l'état pour déclencher la réévaluation de l'interface utilisateur
       
        
        // Naviguer vers la page des détails de la commande
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>  CommandePage(),
          ),
        );
      } else {
        print("Erreur lors de la création de la commande : ${response.statusCode}");
        // Gérer l'erreur en conséquence
      }
    }
  } catch (e) {
    print("Erreur lors de la création de la commande : $e");
  }
}

class _PaymentPageState extends State<PaymentPage> {
  String _selectedPaymentMethod = 'Espèces';


  @override
  Widget build(BuildContext context) {
    return Material.Scaffold(
      backgroundColor: const Color(0xFF006583),
      appBar: _buildAppBar(),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5.0, top: 16.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Expanded(
                        child: Transform.translate(
                          offset: const Offset(-25.0, 0.0),
                          child: Transform.scale(
                            scale: 0.9,
                            child: Text(
                              'Votre Panier',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(8, 0, 0, 1),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                _buildProductList(),
                SizedBox(height: 20),
                _buildPriceDetails(),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Material.TextButton(
                        onPressed: () {
                          if( _selectedPaymentMethod == "En ligne"){
                            _launchURL();
                          }
                          else {
                          _showConfirmationDialog();
                          }
                        },
                        child: Text(
                          'Valider',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: Material.ButtonStyle(
                          backgroundColor: Material.MaterialStateProperty.all<Color>(Color(0xFF006583)),
                          padding: Material.MaterialStateProperty.all<EdgeInsetsGeometry>(
                              EdgeInsets.symmetric(horizontal: 160, vertical: 10)),
                          shape: Material.MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ],
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
                  Material.MaterialPageRoute(builder: (context) => RecherchePage()),
                );
                break;
              case 1:
                Navigator.push(
                  context,
                  Material.MaterialPageRoute(builder: (context) => PanierPage(id: '',quantite: 0,)),
                );
                break;
              case 2:
                Navigator.push(
                  context,
                  Material.MaterialPageRoute(builder: (context) => Home()),
                );
                break;
              case 3:
                Navigator.push(
                  context,
                  Material.MaterialPageRoute(builder: (context) => ProfilePage()),
                );
                break;
            }
          },
        ),
      ),
      
    );
  }

  Material.AppBar _buildAppBar() {
    return Material.AppBar(
      backgroundColor: const Color(0xFF006583),
      automaticallyImplyLeading: false,
      title: Container(
        child: Transform.translate(
          offset: const Offset(-60.0, 0.0),
          child: Transform.scale(
            scale: 0.7,
            child: Image.asset('assets/images/logo.jpg'),
          ),
        ),
      ),
      iconTheme: const Material.IconThemeData(
        size: 52,
        color: Colors.white,
      ),
    );
  }

Widget _buildProductList() {
  return Material.Container(
    height: 500,
    child: ListView.builder(
      itemCount: widget.cartProduct.length,
      itemBuilder: (context, index) {
        var product = widget.cartProduct[index];
        return Column(
          children: [
            _buildImageItem(product["productDetails"]['Image'], product["productDetails"]['Référence'], product["productDetails"]['Nom'], product['quantity']),
            SizedBox(height: 5),
          ],
        );
      },
    ),
  );
}



  Widget _buildImageItem(String imagePath, String Reference ,String Nom,int quantity){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    imagePath,
                    height: 100,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Material.Column(
                  children: [
                    Text(
                     Reference ,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                     Nom ,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                     Text(
                     " $quantity ",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  ],
                ),
              ),
            ),
            
          ],
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _buildPriceDetails() {
    String selectedPaymentMethod = 'Espèces';
    String deliveryAddress = '';

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20), // Changement pour un contour de coin circulaire
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Alignement modifié
        children: [
          Text(
            'Méthode de paiement:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Color(0xFF006583)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Sélectionnez:'),
              SizedBox(width: 10),
             Row(
  children: [
    Radio(
      value: 'Espèces',
      groupValue: _selectedPaymentMethod,
      onChanged: (value) {
        setState(() {
          _selectedPaymentMethod = value as String; // Affecter la valeur sélectionnée à selectedPaymentMethod
        });
      },
    ),
    Text('Espèces'),
  ],
),
SizedBox(width: 10),
Row(
  children: [
    Radio(
      value: 'En ligne',
      groupValue: _selectedPaymentMethod,
      onChanged: (value) {
        setState(() {
          _selectedPaymentMethod = value as String; // Affecter la valeur sélectionnée à selectedPaymentMethod
        });
      },
    ),
    Text('En ligne'),
  ],
),

            ],
          ),
          SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.local_activity_outlined),
              Text(
                'Adresse:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                'Charguia 1',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.phone),
                  SizedBox(width: 5),
                  Text(
                    '+216 71 234 567',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          _buildPriceDetailRow('Prix total', '${widget.prixtotal}TND',
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
        ],
      ),
    );
  }

  Widget _buildPriceDetailRow(String label, String amount,
      {FontWeight fontWeight = FontWeight.normal,
      Color color = const Color.fromARGB(255, 212, 210, 210),
      double fontSize = 16}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: fontSize,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontWeight: fontWeight,
            color: color,
            fontSize: fontSize,
          ),
        ),
      ],
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Material.AlertDialog(
          title: Icon(Icons.shopping_cart, size: 70, color: Color(0xFF006583)),
          content: Text(
            "Votre commande a été effectuée avec succès. \nVos articles seront bientôt expédiés.",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            Material.TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.push(
                  context,
                  Material.MaterialPageRoute(builder: (context) => Home()),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
void _launchURL() async {
  var url = Uri.parse('https://test.clictopay.com/payment/merchants/CLICTOPAY/payment_fr.html');
  try {
    await launch(url.toString());
  } catch (e) {
    print('Error launching URL: $e');
  }
}


