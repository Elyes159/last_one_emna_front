import 'package:flutter/material.dart';

class CommandePage extends StatelessWidget {
  // Exemple de données de commande
  final String firstName = "Emna";
  final String lastName = "Bouachiri";
  final String adresse = "123 Rue de la République";
  final String commande = "12345";
  final String etatCommande = "En cours";
  final int total = 10000;
  final String produitCommande = 'Machine';

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
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Text(
                    'Suivre votre commande',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(width: 52), // Espacement pour aligner le titre au centre
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Informations de commande:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              ListTile(
                title: Text('Nom: $firstName $lastName',style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),),
                subtitle: Text('Adresse: $adresse',style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),),
                
              ),
              SizedBox(height: 20),
              ListTile(
                title: Text('Numéro de commande: $commande',style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),),
                subtitle: Text('État de la commande: $etatCommande',style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),),
              ),
              SizedBox(height: 20),
              ListTile(
                title: Text('Produit commandé: $produitCommande',style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),),
                subtitle: Text('Montant total: $total',style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),),
              ),
            ],
          ),
        ),
      ),
      endDrawer: NavBar(),
    );
  }
}

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CommandePage(),
  ));
}
