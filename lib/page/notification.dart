import 'package:flutter/material.dart';
import 'package:untitled2/page/sidebar.dart';

class Notificationpage extends StatelessWidget {
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
                          'Notifications',
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
                child: SettingsPage(),
              ),
            ],
          ),
        ),
      ),
      endDrawer: NavBar(),
    );
  }
}

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<bool> isDarkThemeEnabledList = [false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        buildListTile('Mise a jour du logiciel', 'Des mises a jour logicielels et sécurité', 0),
        buildListTile('Paramètre de confidentialité', 'Configurer les niveaux de sécurité des données', 1),
        buildListTile('MIse a jour produits', 'Mise ajour réguliere des informations produits', 2),
        buildListTile('Suggére pour vous', 'Des recommandations personnalisées en fonction des préférences et des historique achat', 3),
      ],
    );
  }

  Widget buildListTile(String title, String subtitle, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        trailing: Switch(
          value: isDarkThemeEnabledList[index],
          onChanged: (value) {
            setState(() {
              isDarkThemeEnabledList[index] = value;
            });
          },
        ),
        title: Text(title),
        subtitle: Text(isDarkThemeEnabledList[index] ? subtitle : 'Activer pour $subtitle'),
        onTap: () {
          // Action à effectuer lors du clic sur l'élément de la liste
        },
      ),
    );
  }
}


