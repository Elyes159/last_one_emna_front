import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _displayText = '';
  String _currentContent = '';
  bool _isButtonClicked = false;
  bool _isLogoClicked =
      false; // Ajout d'une variable pour suivre l'état de l'image du logo

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Container(
              height: 50,
              color: Color(0xFF006583),
              child: ListView(
                children: [
                  _buildListTileWithButton(
                      'LIVRASION RAPIDE',
                      'assets/icons/verf.png',
                      'offrez-vous la livraison gratuite pour vos commandes en ligne dès maintenant ne manquez pas cette offre exceptionnelle pour faire des économies sur vos achats'),
                  SizedBox(height: 8),
                  _buildListTileWithButton('GARANTIE', 'assets/icons/verf.png',
                      'Offrez-vous une tranquillité d\'esprit totale avec notre garantie de satisfaction à 100% sur toutes vos commandes en ligne!'),
                  SizedBox(height: 8),
                  _buildListTileWithButton(
                      'SERVICE CLIENT',
                      'assets/icons/verf.png',
                      'Nous sommes fiers de vous offrir un service clientèle exceptionnel pour accompagner notre garantie de satisfaction à 100%.  - service client'),
                  SizedBox(height: 8),
                  _buildListTileWithButton('SAV', 'assets/icons/verf.png',
                      'un service après-vente de qualité supérieure pour accompagner nos produits. '),
                  SizedBox(height: 8),
                  _buildListTileWithButton(
                      'CONTACTEZ-NOUS',
                      'assets/icons/verf.png',
                      ' 78, Rue des minéraux 8603 Z.I de la Charguia 1 2035 Tunis - Tunisie  (+216) 71 205 105'),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            transform: _isLogoClicked
                ? Matrix4.translationValues(20, -50, 0)
                : Matrix4.translationValues(0, -30, 0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isLogoClicked = !_isLogoClicked;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                      height:
                          10), // Ajout d'un SizedBox avec une hauteur spécifiée
                  Image.asset(
                    'assets/images/logo.jpg',
                    width: 130,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTileWithButton(
      String title, String imagePath, String content) {
    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                height: 1.0), // Réduire l'espace entre les lignes
          ),
          trailing: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            transform: _currentContent == content
                ? Matrix4.translationValues(0, -20, 0)
                : Matrix4.translationValues(0, 0, 0),
            child: IconButton(
              icon: Image.asset(imagePath),
              onPressed: () {
                setState(() {
                  if (_currentContent == content) {
                    _displayText = '';
                    _isButtonClicked = false;
                    _currentContent = '';
                  } else {
                    _displayText = content;
                    _isButtonClicked = true;
                    _currentContent = content;
                  }
                });
              },
            ),
          ),
        ),
        Divider(color: Colors.white),
        if (_currentContent == content && content == 'SAV')
          Container(
            margin: EdgeInsets.only(left: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8.0),
                GestureDetector(
                  onTap: () {
                    // Action for "Contactez-nous"
                  },
                ),
              ],
            ),
          ),
        AnimatedOpacity(
          duration: Duration(milliseconds: 300),
          opacity: _currentContent == content ? 1.0 : 0.0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              _displayText,
              style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  height: 1.0), // Réduire l'espace entre les lignes
            ),
          ),
        ),
      ],
    );
  }
}
