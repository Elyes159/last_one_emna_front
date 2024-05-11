import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AdressePage extends StatefulWidget {
  @override
  _AdressePageState createState() => _AdressePageState();
}

class _AdressePageState extends State<AdressePage> {
  TextEditingController _adresseController = TextEditingController();
  TextEditingController _villeController = TextEditingController();
  TextEditingController _postalController = TextEditingController();

  Future<String?> getIdUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print("houni : $token");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    try {
      final response = await http.get(
        Uri.parse("http://192.168.1.18:3003/user/getuserbytoken/$token"),
        headers: headers,
      );
      if (response.statusCode == 200) {
        print('donnée récupérée avec succès');
        final decodedResponse = json.decode(response.body);
        return decodedResponse['_id'];
      } else {
        print('erreur ${response.body}');
        return null;
      }
    } catch (e) {
      print('erreur: $e');
      return null;
    }
  }

  Future<void> sendAddress() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final userid = await getIdUser();
    print("houni : $userid");
    try {
      final resp = await http.put(
        Uri.parse("http://192.168.1.18:3003/user/updateadresse/$userid"),
        headers: headers,
        body: jsonEncode({
          "adresse": _adresseController.text,
          "ville": _villeController.text,
          "postal": _postalController.text,
        }),
      );
      if (resp.statusCode == 200) {
        print('donnée mise à jour avec succès');
      } else {
        print('erreur ${resp.body}');
      }
    } catch (e) {
      print('erreur: $e');
    }
  }

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
                        offset: Offset(-23, 0.0),
                        child: Text(
                          'paramétre',
                          style: TextStyle(
                            fontSize: 30, // Increase the title size
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20), // Add space between elements
              Text(
                'changer votre adresse',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF006583),
                ),
              ),
              SizedBox(height: 20),
              // Form
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildFormFieldWithTitle(
                      title: 'Adresse',
                      hintText: 'Entrez votre adresse',
                      icon: Icons.location_on,
                      controller: _adresseController,
                    ),
                    SizedBox(height: 10),
                    _buildFormFieldWithTitle(
                      title: 'Ville',
                      hintText: 'Entrez votre ville',
                      icon: Icons.location_city,
                      controller: _villeController,
                    ),
                    SizedBox(height: 10),
                    _buildFormFieldWithTitle(
                      title: 'Code Postal',
                      hintText: 'Entrez votre code postal',
                      icon: Icons.location_searching,
                      controller: _postalController,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        sendAddress();
                      },
                      child: Container(
                        width: 90, // Extend the button to full width
                        padding: EdgeInsets.symmetric(
                            vertical: 8), // Adjust padding
                        child: Text(
                          'Confirmer',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white, // Increase button text size
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Color(0xFF006583), // Button background color
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // endDrawer: NavBar(), // Use endDrawer to display drawer on the right
    );
  }

  // Function to build a form field with title, text, and icon
  Widget _buildFormFieldWithTitle(
      {required String title,
      required String hintText,
      required IconData icon,
      required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextFormField(
            controller: controller, // Assign the controller
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 12,
              ),
              border: InputBorder.none,
              prefixIcon: Icon(icon),
              hintText: hintText,
            ),
          ),
        ),
      ],
    );
  }
}
