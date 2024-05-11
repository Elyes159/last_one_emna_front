import 'package:flutter/material.dart';
import 'package:untitled2/page/sidebar.dart';



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ConfidentialitePage(),
    );
  }
}

class ConfidentialitePage extends StatelessWidget {
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
              SizedBox(height: 8),
              ListTile(
                title: RichText(
                  text: TextSpan(
                    text: 'Confidentialité & Sécurité',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF006583),
                    ),
                  ),
                ),
                onTap: () {},
              ),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '1. À propos de cette notification :',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                subtitle: Text(
                  'Cette notification de confidentialité et utilisations des cookies, fournit des informations sur la façon dont Tdiscount collecte et traite vos données personnelles lorsque vous visitez notre site Web ou notre application mobile.',
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
                      '2. Les cookies  :',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                subtitle: Text(
                  '•  Lors de votre visite sur notre site, des informations relatives à votre navigation sont susceptibles être enregistrées dans des fichiers appelés "Cookies" installés sur votre ordinateur, Smartphone, tablette etc…',
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
                      '3. Comment nous utilisons vos données personnelles :',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                subtitle: Text(
                  '•  Les données personnelles et confidentielles que vous nous indiquez lorsque vous passez une commande sont destinées au traitement de votre achat.',
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
                      '4. Comment nous partageons données personnelles :',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                subtitle: Text(
                  'Nous travaillons avec des prestataires de services et nous les engageons pour exécuter certaines fonctions en notre nom. Lorsque nous partageons vos données personnelles avec ces prestataires, nous leur demandons accepter utiliser vos données conformément aux termes de la présente notification de confidentialité et de cookies, à la loi en vigueur et à notre politique de confidentialité et de protection des données.',
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
                      '5. Sécurité des données :',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight : FontWeight.bold,
                      ),
                    )
                  ],
                ),
                subtitle: Text(
                  'Nous avons mis en place des mesures de sécurité appropriées pour éviter que vos données ne soient utilisées ou consultées de manière non autorisée.',
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
                      '6. Vos droits légaux :',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                subtitle: Text(
                  'Vous avez des droits en vertu des lois sur la protection des données en ce qui concerne vos données personnelles, y compris le droit accéder, de corriger ou bien de supprimer et le droit de vous opposer ou de restreindre le traitement de vos données personnelles',
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
