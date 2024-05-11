import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/page/confidentalite.dart';
import 'package:untitled2/page/connecte.dart';
import 'package:untitled2/page/home.dart';
import 'package:untitled2/page/page/aide.dart';
import 'package:untitled2/page/page/langage.dart';
import 'package:untitled2/page/profile.dart';
import 'package:untitled2/page/propos.dart';
import 'sidebar.dart';
import 'package:untitled2/page/notification.dart';
import 'package:http/http.dart' as http;

bool isCategoryExpanded = false;
void removeTokenFromSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('token');
}

Future<String?> getTokenFromSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
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

class ProfilePage extends StatelessWidget {
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
          color: Color.fromARGB(255, 255, 255, 255),
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
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Expanded(
                    child: Center(
                      child: Transform.translate(
                        offset: Offset(-23, 0.0), // Translation horizontale
                        child: Text(
                          'Paramètre',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Expanded(
                child:
                    SettingsPage(), // Intégration de la page de paramètres ici
              ),
            ],
          ),
        ),
      ),
      endDrawer:
          NavBar(), // Utiliser endDrawer pour afficher le drawer à droite
    );
  }
}

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkThemeEnabled = false; // État initial du thème

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        // Catégorie "Compte"
        Container(
          child: ListTile(
            title: Text(
              'Compte',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 29, 29, 29),
              ),
            ),
          ),
        ),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            leading: Icon(Icons.account_circle, color: Colors.black),
            title: Text('Information personnelle'),
            subtitle: Text('Modifier votre compte'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile()),
              );
            },
          ),
        ),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            leading: Icon(Icons.notifications, color: Colors.black),
            title: Text('Notifications'),
            subtitle: Text(''),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Notificationpage()),
              );
            },
          ),
        ),

        Container(
          child: ListTile(
            title: Text(
              'Service',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ),
        ),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            leading: Icon(Icons.help, color: Colors.black),
            title: Text('Aide'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AidePage()),
              );
            },
          ),
        ),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            leading: Icon(Icons.verified_user_rounded, color: Colors.black),
            title: Text('Sécurité et confidentialité'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ConfidentialitePage()),
              );
            },
          ),
        ),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            leading: Icon(Icons.info, color: Colors.black),
            title: Text('À propos'),
            subtitle: Text("À propos de l'application"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProposPage()),
              );
            },
          ),
        ),

        // Option de déconnexion
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.black),
            title: Text('Déconnexion'),
            onTap: () async {
              performLogout();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Home()),
              );
            },
          ),
        ),
      ],
    );
  }
}
