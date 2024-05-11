import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/page/home.dart';
import 'package:untitled2/page/sidebar.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RecherchePage(),
    );
  }
}

void main() {
  runApp(MyApp());
}

class RecherchePage extends StatefulWidget {
  @override
  State<RecherchePage> createState() => _RecherchePageState();
}

class _RecherchePageState extends State<RecherchePage> {
  int number = 0;
  String? _selectedOption = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF006583),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: ClipRRect(
          child: AppBar(
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
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 780,
          decoration: BoxDecoration(
            color: Color(0xFFEFEFEF),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(60.0),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xFFdcdcdc),
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade400,
                                    blurRadius: 10,
                                    spreadRadius: 3,
                                    offset: const Offset(5, 5))
                              ]),
                          child: TextFormField(
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Chercher un produit',
                                prefixIcon: Icon(Icons.search)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width /
                                              2, // Définir une largeur fixe pour la première colonne
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                         

                                           RadioListTile<String>(
                                            title: Text('prix plus bas '),
                                            value: 'Nouveau',
                                            groupValue: _selectedOption,
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedOption = value;
                                              });
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                           RadioListTile<String>(
                                            title: Text('prix plus bas'),
                                            value: 'Nouveau',
                                            groupValue: _selectedOption,
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedOption = value;
                                              });
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                           RadioListTile<String>(
                                            title: Text('prix'),
                                            value: 'Nouveau',
                                            groupValue: _selectedOption,
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedOption = value;
                                              });
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                   
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFdcdcdc),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade400,
                                blurRadius: 10,
                                spreadRadius: 3,
                                offset: const Offset(5, 5),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Icon(
                              Icons.sort,
                              size: 26,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    children: [
                      Transform.translate(
                        offset: Offset(18, 10),
                        child: Text(
                          "Trier par Marques",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF548a87),
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(174, 10),
                        child: Row(
                          children: [
                            Transform.translate(
                              offset: Offset(-42, 2),
                              child: TextButton(
  onPressed: () {
    Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
  },
  child: Text(
    "Voir plus",
    style: TextStyle(
      fontSize: 13.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
  ),
)

                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Image.asset(
                                'assets/images/blacc.png',
                                width: 20,
                                height: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildCircularImage('assets/images/recherche1.png', width: 20, height: 3),
                          _buildCircularImage('assets/images/recherche22.png', width: 20, height: 3),
                          _buildCircularImage('assets/images/recherche3.png', width: 30, height: 30),
                          _buildCircularImage('assets/images/recherche4.png', width: 5, height: 3),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildCircularImage('assets/images/recherche5.png', width: 30, height: 10),
                          _buildCircularImage('assets/images/recherche10.png', width: 30, height: 10),
                          _buildCircularImage('assets/images/recherche7.png', width: 30, height: 30),
                          _buildCircularImage('assets/images/recherche88.png', width: 40, height: 30),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    children: [
                      Transform.translate(
                        offset: Offset(18, 10),
                        child: Text(
                          "Catégories",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF548a87),
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(174, 10),
                        child: Row(
                          children: [
                            Transform.translate(
                              offset: Offset(12, -1),
                              
                              child: Text(
                                "Voir plus",
                                style: TextStyle(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                 Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
                              },
                              icon: Image.asset(
                                'assets/images/blacc.png',
                                width: 20,
                                height: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Column(
                    children: [
                      Transform.translate(
                        offset: Offset(-47, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset('assets/images/catego11.png', width: 40, height: 40),
                            Transform.translate(
                              offset: Offset(-44, 5),
                              child: Text(
                                'Eléctroménager',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Transform.translate(
                        offset: Offset(-52.5, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset('assets/images/catego2.png', width: 40, height: 40),
                            Transform.translate(
                              offset: Offset(-46, 5),
                              child: Text(
                                'Informatiques',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Transform.translate(
                        offset: Offset(-50, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset('assets/images/catego3.png', width: 40, height: 40),
                            Transform.translate(
                              offset: Offset(-44, 5),
                              child: Text(
                                'Sport & Loisirs',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Transform.translate(
                        offset: Offset(-55, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset('assets/images/catego4.png', width: 40, height: 40),
                            Transform.translate(
                              offset: Offset(-46, 5),
                              child: Text(
                                'Smartphones',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Transform.translate(
                        offset: Offset(-58, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset('assets/images/catego5.png', width: 40, height: 40),
                            Transform.translate(
                              offset: Offset(-52, 5),
                              child: Text(
                                'Impression',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Transform.translate(
                        offset: Offset(-58, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset('assets/images/catego6.png', width: 40, height: 40),
                            Transform.translate(
                              offset: Offset(-56, 5),
                              child: Text(
                                'Jeux vidéo',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Transform.translate(
                        offset: Offset(-49, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset('assets/images/catego7.png', width: 40, height: 40),
                            Transform.translate(
                              offset: Offset(-44, 5),
                              child: Text(
                                'Santé & beauté',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      endDrawer: NavBar(),
    );
  }

  Widget _buildCircularImage(String imagePath,
      {required double width, required double height}) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFdcdcdc),
      ),
      child: ClipOval(
        child: Image.asset(
          imagePath,
          width: width,
          height: height,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
