import 'package:flutter/material.dart';
import 'package:untitled2/page/sidebar.dart';

class AdressePage extends StatefulWidget {
  @override
  _AdressePageState createState() => _AdressePageState();
}

class _AdressePageState extends State<AdressePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF006583),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: ClipRRect(
          child: AppBar(
            backgroundColor: Color(0xFF006583),
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
                      title: 'Rue',
                      hintText: 'Entrez votre rue',
                      icon: Icons.location_on,
                    ),
                    SizedBox(height: 10),
                    _buildFormFieldWithTitle(
                      title: 'Ville',
                      hintText: 'Entrez votre ville',
                      icon: Icons.location_city,
                    ),
                    SizedBox(height: 10),
                    _buildFormFieldWithTitle(
                      title: 'Code Postal',
                      hintText: 'Entrez votre code postal',
                      icon: Icons.location_searching,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Action to perform on button press
                      },
                      child: Container(
                        width: 90, // Extend the button to full width
                        padding: EdgeInsets.symmetric(vertical: 8), // Adjust padding
                        child: Text(
                          'Confirmer',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white, // Increase button text size
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF006583), // Button background color
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      endDrawer: NavBar(), // Use endDrawer to display drawer on the right
    );
  }

  // Function to build a form field with title, text, and icon
  Widget _buildFormFieldWithTitle(
      {required String title, required String hintText, required IconData icon}) {
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


