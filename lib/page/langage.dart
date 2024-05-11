import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LangagePage(),
    );
  }
}

class LangagePage extends StatefulWidget {
  @override
  _LangagePageState createState() => _LangagePageState();
}

class _LangagePageState extends State<LangagePage> {
  String _selectedLanguage = 'Français';

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
          padding: EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20),
              Text(
                'Langues suggérées',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  decoration: TextDecoration
                      .underline, // Ajout de la décoration soulignée
                ),
              ),
              SizedBox(height: 5),
              _buildLanguageOption('Français', 'Langues courantes'),
              _buildLanguageOption('English', 'Langues courantes'),
              SizedBox(height: 10),
              Text(
                'Autres langues',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  decoration: TextDecoration
                      .underline, // Ajout de la décoration soulignée
                ),
              ),
              SizedBox(height: 10),
              _buildLanguageOption('Allemand', 'Autres langues'),
              _buildLanguageOption('Espagnol', 'Autres langues'),
              _buildLanguageOption('Arabe', 'Autres langues'),
              _buildLanguageOption('Chinois', 'Autres langues'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String language, String category) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedLanguage = language;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Text(
              language,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black, // Couleur du texte
              ),
            ),
            Spacer(),
            if (_selectedLanguage == language) Icon(Icons.check),
          ],
        ),
      ),
    );
  }
}
