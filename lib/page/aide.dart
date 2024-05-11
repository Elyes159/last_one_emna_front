import 'package:flutter/material.dart';
import 'package:untitled2/page/sidebar.dart';



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AidePage(),
    );
  }
}

class AidePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF006583),
      
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
          child: AppBar(
            backgroundColor: Color.fromARGB(255, 0, 101, 131),
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
            color: Color.fromARGB(255, 240, 240, 242),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Paramètre',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ListTile(
                title: RichText(
                  text: TextSpan(
                    text: 'Aide & F.Q.A', 
                    style: TextStyle(
                      fontSize: 25, 
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF006583),
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Qui Sommes-nous ?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                subtitle: Text(
                  'Créé en 2016, Tdiscount s’est donné la mission de faciliter l’accès aux produits électroménager et high-tech, ainsi que les articles culturels au plus grand nombre de personnes, et ce, en proposant à ses clients un large choix de produits de qualité parmi les plus grandes marques LG, Tornado, Passap, Cecotec, Huawei, Samsung, Xiaomi, Asus, HP, Dell, MSI, Canon, Orient, Whirlpool, Condor, Telefunken, TCL, Kenwood, Braun, Tefal Moulinex, … aux meilleurs prix.',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Comment acheter ?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                subtitle: Text(
                  'Étape 1 : Chercher un produit, une marque ou une catégorie sur la barre de recherche en haut de page.\n Étape 2 : utilisez le panier\nCliquez sur l’icône de votre panier. Pour modifier la quantité \nÉtape 3 : passez la commande\nLorsque vous êtes sûr de votre sélection, vous pouvez passer votre commande en cliquant sur le bouton acheter',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Contactez-nous',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                subtitle: Text(
                  'Address: 78, Rue des minéraux 8603 Z.I de la Charguia 1 2035 Tunis - Tunisie \nTél : (+216) 71 205 105\nSAV : (+216) 29 918 918\nEmail: contact@tdiscount.tn\nLundi - Vendredi : (8:30 - 18:00)\nSamedi (8h:30 - 15:00)',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              
              SizedBox(height: 350), 
            ],
          ),
        ),
      ),
       endDrawer: NavBar(),
    );
  }
}
