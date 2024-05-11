import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CommandePage extends StatefulWidget {
  @override
  _CommandePageState createState() => _CommandePageState();
}

class _CommandePageState extends State<CommandePage> {
  List<dynamic> commandes = []; // Liste des commandes récupérées
  Future<String?> getTokenFromSharedPreferences() async {
    // Récupérer le token de l'utilisateur depuis les préférences partagées
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> getUserIdFromToken() async {
    // Construire les en-têtes de la requête HTTP
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    try {
      final String? token = await getTokenFromSharedPreferences();
      // Effectuer une requête HTTP GET pour récupérer l'ID de l'utilisateur à partir du token
      final resp = await http.get(
        Uri.parse("http://192.168.1.17:3003/user/getuserbytoken/$token"),
        headers: headers,
      );
      if ((resp.statusCode == 200) || (resp.statusCode == 201)) {
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

  // Fonction pour récupérer les commandes de l'utilisateur
  Future<void> fetchCommandes() async {
    try {
      final String? userId = await getUserIdFromToken();
      final response = await http
          .get(Uri.parse('http://192.168.1.17:3003/user/commandes/$userId'));

      if (response.statusCode == 200) {
        // Conversion de la réponse JSON en une liste de commandes
        setState(() {
          commandes = jsonDecode(response.body)['commandes'];
        });
      } else {
        throw Exception(response.body);
      }
    } catch (error) {
      print('Error fetching commandes: $error');
      // Gérer les erreurs de récupération des commandes
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCommandes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF006583),
      appBar: AppBar(
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
              // Affichage des commandes récupérées
              Expanded(
                child: ListView.builder(
                  itemCount: commandes.length,
                  itemBuilder: (context, index) {
                    return _buildCommandeCard(commandes[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      endDrawer: NavBar(),
    );
  }

  // Fonction pour créer un widget de carte pour afficher les détails de la commande
  Widget _buildCommandeCard(dynamic commande) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text(
              'Référence de commande: ${commande['_id']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            SizedBox(height: 10),
            Text(
              'État de la commande: ${commande['Etat']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            SizedBox(height: 10),
            Text(
              'Montant total: ${commande['total']} TND',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
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
