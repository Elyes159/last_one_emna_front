import 'package:flutter/material.dart';
import 'package:untitled2/page/favoris.dart';
import 'package:untitled2/page/mdp.dart';
import 'package:untitled2/page/page/adesse.dart';
import 'package:untitled2/page/sidebar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Profile(),
    );
  }
}

class Profile extends StatelessWidget {
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
          color: Color.fromARGB(255, 251, 251, 252),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        height: 900, // Fixed height of the body
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTileWithEditButton(
                  title: 'Mon adresse',
                  subtitle: 'Définir l\'adresse de livraison d\'achat',
                  leadingIcon: 'assets/icons/local.png',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdressePage()),
                    );
                  },
                ),
                ListTileWithEditButton(
                  title: 'Mes commandes',
                  subtitle: 'Commandes en cours et terminées',
                  leadingIcon: 'assets/icons/panier.png',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NavBar()),
                    );
                  },
                ),
                ListTileWithEditButton(
                  title: 'Favoris',
                  subtitle: 'voir liste de favoris',
                  leadingIcon: 'assets/icons/favoris.png',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FavorisPage()),
                    );
                  },
                ),
               
                ListTileWithEditButton(
                  title: 'Changer le mot de passe',
                  subtitle: 'Changer le mot de passe pour sécuriser votre compte',
                  leadingIcon: 'assets/icons/confidentialite.png',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MotDePassePage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      endDrawer: NavBar(),
    );
  }
}

class ListTileWithEditButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final String leadingIcon;
  final VoidCallback? onTap;

  const ListTileWithEditButton({
    required this.title,
    required this.subtitle,
    required this.leadingIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Image.asset(
            leadingIcon,
            width: 32,
            height: 32,
          ),
          title: Text(title),
          subtitle: Text(subtitle),
          trailing: InkWell(
            child: Image.asset(
              'assets/icons/fat7.png',
              width: 24,
              height: 24,
              color: Colors.black,
            ),
            onTap: onTap,
          ),
        ),
        Divider(),
      ],
    );
  }
}
