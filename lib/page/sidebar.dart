import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/page/connecte.dart';
import 'package:untitled2/page/favourites.dart';
import 'package:untitled2/page/home.dart';
import 'package:untitled2/page/notification.dart'; // Import de la page de notification
import 'package:untitled2/page/page/suivrecommande.dart';
import 'package:untitled2/page/parametre.dart';
import 'package:http/http.dart' as http;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mon application',
      home: Scaffold(
        appBar: AppBar(iconTheme: IconThemeData(size: 52)),
        endDrawer: NavBar(), // Utilisez endDrawer au lieu de drawer
      ),
    );
  }
}

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  Future<String?> getTokenFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Map<String, dynamic> user = {};

  Future<Map<String, dynamic>> getUserFromToken() async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      final String? token = await getTokenFromSharedPreferences();
      final resp = await http.get(
        Uri.parse("http://192.168.1.17:3003/user/getuserbytoken/$token"),
        headers: headers,
      );
      if (resp.statusCode == 200) {
        // Analyser la réponse JSON pour extraire les données de l'utilisateur
        final userData = jsonDecode(resp.body);
        setState(() {
          user = userData;
        });

        return userData;
      } else {
        print(
            'Erreur lors de la récupération des données de l\'utilisateur: ${resp.statusCode}');
        return {};
      }
    } catch (e) {
      print('Erreur lors de la récupération des données de l\'utilisateur: $e');
      return {};
    }
  }

  bool isCategoryExpanded = false;
  void removeTokenFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
  }

  Future<void> logoutFromServer(String token) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // Envoyer le token dans les en-têtes
    };

    try {
      final resp = await http.post(
        Uri.parse("http://192.168.1.17:3003/user/logout"),
        headers: headers,
      );
      if (resp.statusCode == 200) {
        // Supprimer le token localement
        removeTokenFromSharedPreferences();
        print('Déconnexion réussie');
      } else {
        print('Erreur lors de la déconnexion: ${resp.statusCode}');
      }
    } catch (e) {
      print('Erreur lors de la déconnexion: $e');
    }
  }

  void performLogout() async {
    String? token = await getTokenFromSharedPreferences();
    if (token != null) {
      await logoutFromServer(token);
    } else {
      print('Token non trouvé localement');
    }
  }

  @override
  void initState() {
    super.initState();
    getUserFromToken();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF006583),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF006583),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/logo.jpg',
                      height: 30,
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${user['firstname']} ${user['lastname']} ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '${user['email']}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            buildListTile(
              icon: Icons.favorite,
              title: 'Favoris',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FavoritesPage()),
                );
              },
            ),
            buildListTile(
              icon: Icons.shopping_cart,
              title: 'suivre commande',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CommandePage()),
                );
              },
            ),
            buildListTile(
              icon: Icons.settings,
              title: 'Paramètres',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            buildListTile(
              icon: Icons.category,
              title: 'Catégorie',
              onTap: () {
                setState(() {
                  isCategoryExpanded = !isCategoryExpanded;
                });
              },
            ),
            if (isCategoryExpanded)
              Column(
                children: [
                  buildListTile(
                    icon: Icons.subdirectory_arrow_right,
                    title: 'Électroménager',
                    onTap: () => null,
                  ),
                  buildListTile(
                    icon: Icons.subdirectory_arrow_right,
                    title: 'Informatique',
                    onTap: () => null,
                  ),
                  buildListTile(
                    icon: Icons.subdirectory_arrow_right,
                    title: 'Sport & Loisirs',
                    onTap: () => null,
                  ),
                  buildListTile(
                    icon: Icons.subdirectory_arrow_right,
                    title: 'Bureautique',
                    onTap: () => null,
                  ),
                  buildListTile(
                    icon: Icons.subdirectory_arrow_right,
                    title: 'Animalerie',
                    onTap: () => null,
                  ),
                  buildListTile(
                    icon: Icons.subdirectory_arrow_right,
                    title: 'Gaming',
                    onTap: () => null,
                  ),
                  buildListTile(
                    icon: Icons.subdirectory_arrow_right,
                    title: 'TV & Son',
                    onTap: () => null,
                  ),
                  buildListTile(
                    icon: Icons.subdirectory_arrow_right,
                    title: 'Santé & Beauté',
                    onTap: () => null,
                  ),
                ],
              ),
            buildListTile(
              icon: Icons.notifications,
              title: 'Notification',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Notificationpage()), // Utilisation de NotificationScreen à la place de NotificationPage
                );
              },
            ),
            buildListTile(
              icon: Icons.exit_to_app,
              title: 'Déconnexion',
              onTap: () async {
                performLogout();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignInScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  ListTile buildListTile({
    required IconData icon,
    required String title,
    required Function()? onTap,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      onTap: onTap,
      trailing: trailing,
    );
  }
}
