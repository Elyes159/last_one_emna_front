import 'package:flutter/material.dart';
import 'package:untitled2/page/sidebar.dart';



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProposPage(),
    );
  }
}

class ProposPage extends StatelessWidget {
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
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
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
              SizedBox(height: 8),
              ListTile(
                title: RichText(
                  text: TextSpan(
                    text: 'À propos',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF006583),
                    ),
                  ),
                ),
                onTap: () {
                  // Action lorsque l'utilisateur appuie sur le bouton À propos
                },
              ),
              SizedBox(height: 8),
              ListTile(
                title: Text('Version   1.0'),
              ),
              SizedBox(height: 8),
              ListTile(
                title: Text(
                  'Tdiscount',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 4),
              ListTile(
                title: Text('une application mobile e-commerce de vente en ligne concue pour permettre aux utilisateurs de decouvrir,parcourir rt acheter une vaste gamme de produits ou services directement depuis leurs appareils mobiles,tels que smartphones et tablettes.\n\n ce type application offre une expérience achat pratique et sécurisé, en permettant aux utilisateurs de  créér des comptes personnalisés, de rechercher des produits par catégorie ou mots-clés,de consulter des descripctions détaillées,des images et des avis clients, et de finaliser leurs achats en quelque clics.\n\n\n\n\n '),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
      endDrawer: NavBar(),
    );
  }
}

