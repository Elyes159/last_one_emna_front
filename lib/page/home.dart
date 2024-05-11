import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/rendering.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/page/footer.dart';
import 'package:untitled2/page/page/CategoryPage1.dart';
import 'package:untitled2/page/page/productpage.dart';
import 'package:untitled2/page/page/resultrech.dart';
import 'package:untitled2/page/panier.dart';
import 'package:untitled2/page/parametre.dart';
import 'package:untitled2/page/recheche.dart';
import 'package:untitled2/page/sidebar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class NotificationService {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'efieoeznoezze,fponoezn',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override 
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {
   bool isAnimationCompleted = false; 
   bool _isNouveautesVisible = false;
  late final PageController pageController;
  ScrollController _scrollController = ScrollController();
  TextEditingController _rechercheController = TextEditingController();
  List<dynamic> _searchResults = [];




  
 
  
  get item => null;

  void recherche() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    try {
      final resp = await http.post(
        Uri.parse("http://192.168.1.15:3003/product/recherche"),
        headers: headers,
        body: jsonEncode({"terme": _rechercheController.text}),
      );

      if (resp.statusCode == 200) {
        List<dynamic> decodedResponse = jsonDecode(resp.body);
        List<dynamic> searchResults = decodedResponse;
        Navigator.push(
          context,MaterialPageRoute(builder: ((context) => RechercheResult(result: searchResults,))
        )
        );

        setState(() {
          _searchResults = searchResults;
        });
        print(_searchResults);
      } else {
        print('Erreur ${resp.statusCode}');
      }
    } catch (e) {
      print('Erreur: $e');
    }
  }

  int pageNo = 0;
  Timer? carasouelTmer;
  late Future<List<dynamic>> futureProducts;
  late List<bool> favoriteStates;

  Future<List<dynamic>> getProducts() async {
    final response =
        await http.get(Uri.parse("http://192.168.1.15:3003/product/products"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      favoriteStates = List.generate(data.length,
          (_) => false); // Generate favoriteStates based on data length
      return data;
    } else {
      throw Exception('Failed to get data: ${response.statusCode}');
    }
  }

  @override


  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  bool showBtmAppBr = true;

  final List<Map<String, dynamic>> gridMap = [
   
  ];

  final List<Map<String, dynamic>> Brands = [
    
  ];
  Future<String?> getTokenFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
   List<dynamic> categories = [

  ];
    Future<void> fetchFavoriteProducts() async {
        String apiUrl = "http://192.168.1.15:3003/categorie/categorie";
        try {
          final response = await http.get(Uri.parse(apiUrl));
          if (response.statusCode == 200) {
            setState(() {
              categories =jsonDecode(response.body);
            });
            print("list :: $categories");
          } else {
            print(
                "Erreur lors de la récupération des produits favoris: ${response.statusCode}");
          }
        } catch (e) {
          print("Erreur lors de la récupération des produits favoris: $e");
        }
      
   
  }
  

  Future<void> addToFavorites(String userId, String productId) async {
    String? token =
        await getTokenFromSharedPreferences(); // Obtenez le token de l'utilisateur depuis les préférences partagées

    if (token != null) {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Envoyer le token dans les en-têtes
      };

      try {
        final resp = await http.put(
          Uri.parse("http://:3003/user/add-to-favorites/$userId/$productId"),
          headers: headers,
        );
        if (resp.statusCode == 200) {
          print('Produit ajouté aux favoris avec succès');
        } else if (resp.statusCode == 400) {
          print('Le produit existe déjà dans les favoris');
        } else if (resp.statusCode == 404) {
          print('Utilisateur ou produit non trouvé');
        } else {
          print('Erreur: ${resp.statusCode}');
        }
      } catch (e) {
        print('Erreur: $e');
      }
    } else {
      print('Token non trouvé localement');
    }
  }

  Future<String?> getUserIdFromToken(String token) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    try {
      final resp = await http.get(
        Uri.parse("http://192.168.1.15:3003/user/getByToken/$token"),
        headers: headers,
      );
      if (resp.statusCode == 200) {
        // Analyser la réponse JSON pour extraire le userId
        final userData = jsonDecode(resp.body);
        final userId = userData['_id'] as String;
        return userId;
      } else {
        print('Erreur lors de la récupération du userId: ${resp.statusCode}');
        return null;
      }
    } catch (e) {
      print('Erreur lors de la récupération du userId: $e');
      return null;
    }
  }

  Future<void> removeFromFavorites(String userId, String productId) async {
    String? token =
        await getTokenFromSharedPreferences(); // Récupérer le token de l'utilisateur
    if (token != null) {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Envoyer le token dans les en-têtes
      };

      try {
        final resp = await http.delete(
          Uri.parse(
              "http://192.168.1.15:3003/user/remove-from-favorites/$userId/$productId"),
          headers: headers,
        );
        if (resp.statusCode == 200) {
          print('Produit retiré des favoris avec succès');
        } else if (resp.statusCode == 400) {
          print("Le produit n'existe pas dans les favoris");
        } else if (resp.statusCode == 404) {
          print('Utilisateur non trouvé');
        } else {
          print('Erreur: ${resp.statusCode}');
        }
      } catch (e) {
        print('Erreur: $e');
      }
    } else {
      print('Token non trouvé localement');
    }
  }

  void toggleFavoriteState(int index, String userId, String products) {
    setState(() {
      // Vous pouvez maintenant utiliser userId pour ajouter ou supprimer le produit des favoris pour cet utilisateur
      favoriteStates[index] = !favoriteStates[index];

      // Ajouter ou supprimer le produit des favoris dans la base de données en utilisant le userId
      if (favoriteStates[index]) {
        addToFavorites(userId, products); // Ajouter le produit aux favoris
      } else {
        removeFromFavorites(
            userId, products); // Supprimer le produit des favoris
      }
    });
  }
  Future<void> receiveNotif() async {
    final response = await http.post(
      Uri.parse('http://192.168.1.15:3003/admin/send-notification'),
      // headers: <String, String>{
      //   'Content-Type': 'application/json',
      // },
     
     // headers: <String, String>{
       // 'Content-Type': 'application/json; charset=UTF-8',
      //},
    );

   
  }

    void initState() {
    pageController = PageController(initialPage: 0, viewportFraction: 0.85);
    // carasouelTmer = getTimer();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        showBtmAppBr = false;
        setState(() {});
      } else {
        showBtmAppBr = true;
        setState(() {});
      }
      
    });
    fetchFavoriteProducts();

    super.initState();
    NotificationService.init();
    receiveNotif();
    
    futureProducts = getProducts();
    favoriteStates = [];
  }
  int selectedCategoryIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(145),
          child: AppBar(
            backgroundColor: Color(0xFF006583),
            elevation: 0,
            flexibleSpace: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 45),
                Row(
                  children: [
                    Transform.translate(
                      offset: Offset(2, -17),
                      child: Image.asset(
                        'assets/images/logo.png',
                        scale: 4,
                      ),
                    ),
                    Spacer(),
                 
                  ],
                ),
                
                
                SizedBox(height: 25),
                Row(
                  children: [
 Container(
  width: 400, // Vous pouvez ajuster cette valeur selon vos besoins
  padding: EdgeInsets.symmetric(horizontal: 10),
  child: Row(
    children: [
     Expanded(
  child: TextFormField(
    controller: _rechercheController,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 30.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50.0),
        borderSide: BorderSide(color: Color(0xFF006583), width: 1.2),
      ),
      filled: true,
      fillColor: Color.fromARGB(255, 188, 200, 202),
      hintText: 'Chercher un produit',
      hintStyle: TextStyle(color: Color(0xFF506d6e)),
      suffixIcon: IconButton(
        icon: Icon(Icons.search),
        onPressed: () {
         recherche(); // Ajoutez ici la logique pour gérer le clic sur le bouton de recherche
        },
      ),
    ),
  ),
),

    ],
  ),
),




                   
                  ],
                ),
                const SizedBox(height: 5),
                // Display search results here
                Expanded(
                  child: ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      // Render each search result item
                      return ListTile(
                        title: Text(_searchResults[index]['Nom']),
                       
                      );
                    },
                  ),
                ),
              ],
            ),
            iconTheme: IconThemeData(
              size: 56, // Adjust the size of the drawer icon here
              color: Colors.white, // Adjust the color of the drawer icon here
            ),
          ),
        ),
        body: Stack(
          children: [
            Container(
              color: Color(0xFF006583),
              child: ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: 21, vertical: 10),
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => SizedBox(width: 20),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
            selectedCategoryIndex = index;
          });
                     
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CategoryPage1(Categorie:categories[index]["Nomcategorie"] as String ,)),
                          );
                          
                    },
                    child: Column(
                      children: [
                        SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
            color: selectedCategoryIndex == index ? Colors.yellow : Colors.white,
                            border: Border.all(
                              color: Colors.transparent,
                              width: 1.2,
                            ),
                          ),
                          child: Image.asset(
                            categories[index]['imagepath'] as String,
                            width: 40,
                            height: 40,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          categories[index]['Nomcategorie'] as String,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Positioned.fill(
              child: Transform.translate(
                offset: Offset(0, 130),
                child: SingleChildScrollView(
                  child: Container(
                    height: 5000,
                    decoration: BoxDecoration(
                      color: Color(0xFFEFEFEF),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(60.0),
                        // Radius pour les coins supérieurs
                        bottom: Radius.circular(60.0),
                        // Radius pour les coins inférieurs
                      ),
                    ),
                    margin: EdgeInsets.only(bottom: 350),
                    child: SafeArea(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 42.0),
                            SizedBox(
                              height: 160,
                              child: PageView.builder(
                                controller: pageController,
                                onPageChanged: (index) {
                                  pageNo = index;
                                  setState(() {});
                                },
                                itemBuilder: (_, index) {
                                  // Liste des chemins des images
                                  List<String> imagePaths = [
                                    'assets/images/image1.jpg',
                                    'assets/images/image2.jpg',
                                    'assets/images/image3.jpg',
                                  ];

                                  return AnimatedBuilder(
                                    animation: pageController,
                                    builder: (ctx, child) {
                                      return child!;
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      // Espacement horizontal entre les images
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(12.0),
                                          // Rayon pour les coins supérieurs
                                          bottom: Radius.circular(
                                              12.0), // Rayon pour les coins inférieurs
                                        ),
                                        child: Image.asset(
                                          imagePaths[index],
                                          // Utilisation du chemin de l'image pour l'index actuel
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                itemCount: 3,
                              ),
                            ),
                            const SizedBox(height: 12.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                3,
                                (index) => GestureDetector(
                                  child: Container(
                                    margin: const EdgeInsets.all(2.0),
                                    width: 30.0, // Largeur du rectangle
                                    height: 6.0, // Hauteur du rectangle
                                    decoration: BoxDecoration(
                                      color: pageNo == index
                                          ? Color(0xFF006583)
                                          : Colors.grey.shade300,
                                      // Couleur du rectangle en fonction de la page
                                      borderRadius: BorderRadius.circular(2.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(24.0),
                              child: GridB(),
                            ),

                           SizedBox(height: 1.0),
                           
Stack(
  children: [
    Container(
      color: Colors.yellow, // Fond jaune
    ),
    SizedBox(
      height: 430, // Taille fixe pour AnimatedPositioned
      child: AnimatedPositioned(
        duration: Duration(milliseconds: 500), // Durée de l'animation
        curve: Curves.easeInOut, // Courbe d'animation
        left: _isNouveautesVisible ? 0 : -MediaQuery.of(context).size.width, // Position initiale (hors de l'écran à gauche)
        child: Container(
          margin: EdgeInsets.only(right: 14.0),
          decoration: const BoxDecoration(
            color: Color(0xFFFFD902),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(50.0),
              bottomRight: Radius.circular(50.0),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 110.0, vertical: 15.0),
          child: FutureBuilder<List<dynamic>>(
            future: futureProducts,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final List<dynamic> nouveautes = snapshot.data!;
                final List<dynamic> filteredNouveautes = nouveautes
                    .where((item) => item['type'] == 'Nouveauté')
                    .toList();

                if (filteredNouveautes.isEmpty) {
                  return Container(); // Retourner une vue vide si aucune nouveauté n'est trouvée
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Transform.translate(
                      offset: Offset(-90, -5),
                      child: const Text(
                        "Nouveautés",
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                         
                        ),
                      ),
                    ),
                    
                    Transform.translate(
                      offset: Offset(-90, -5),
                      child: const Text(
                        "Découvrez les derniers produits",
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Transform.translate(
                      offset: Offset(-90, -14),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          filteredNouveautes[1]['Image'],
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(-0.5, 10),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    ),
  ],
),
                            SizedBox(
                              height: 10,
                            ),
                            Stack(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 1.0, vertical: 1.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Transform.translate(
                                        offset: Offset(5, 0),
                                        child: Text(
                                          "Top catégories",
                                          style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 1.0, vertical: 1.0),
                                        child: FutureBuilder<List<dynamic>>(
                                          future: futureProducts,
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            } else if (snapshot.hasError) {
                                              return Center(
                                                  child: Text(
                                                      'Error: ${snapshot.error}'));
                                            } else {
                                              final List<dynamic> categorie =
                                                  snapshot.data!;
                                              final filteredCategories =
                                                  categorie
                                                      .where((item) =>
                                                          item['type'] ==
                                                          "top categorie")
                                                      .toList();

                                              if (filteredCategories.isEmpty) {
                                                return Container(); // Retourner une vue vide si aucune catégorie de type "Top Catégories" n'est trouvée
                                              }

                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(height: 10),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 25.0,
                                                            vertical: 15.0),
                                                    child: FutureBuilder<
                                                        List<dynamic>>(
                                                      future: futureProducts,
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return Center(
                                                              child:
                                                                  CircularProgressIndicator());
                                                        } else if (snapshot
                                                            .hasError) {
                                                          return Center(
                                                              child: Text(
                                                                  'Error: ${snapshot.error}'));
                                                        } else {
                                                          final List<dynamic>
                                                              gridMap =
                                                              snapshot.data!;
                                                          final filteredGridMap = gridMap
                                                              .where((item) =>
                                                                  item[
                                                                      'type'] ==
                                                                  "offre")
                                                              .toList();

                                                          if (filteredGridMap
                                                              .isEmpty) {
                                                            return Container(); // Retourner une vue vide si aucun produit de type "Meilleures Ventes" n'est trouvé
                                                          }

                                                          return Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              GridView.builder(
                                                                physics:
                                                                    const NeverScrollableScrollPhysics(),
                                                                shrinkWrap:
                                                                    true,
                                                                gridDelegate:
                                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                                  crossAxisCount:
                                                                      2,
                                                                  crossAxisSpacing:
                                                                      10.0,
                                                                  mainAxisSpacing:
                                                                      10.0,
                                                                  mainAxisExtent:
                                                                      200,
                                                                ),
                                                                itemCount:
                                                                    filteredGridMap
                                                                        .length,
                                                                itemBuilder:
                                                                    (_, index) {
                                                                  final item =
                                                                      filteredGridMap[
                                                                          index];
                                                                  final isFavorite =
                                                                      favoriteStates[
                                                                          index];
                                                                  final String
                                                                      imageData =
                                                                      item[
                                                                          'Image']; // Supposons que les données binaires de l'image sont stockées dans un champ 'imageData' sous forme de chaîne de caractères

                                                                  

                                                                  return GestureDetector(
                                                                    onTap: () {
                                                                       

                                                                    },
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(20.0),
                                                                        color: Colors
                                                                            .white,
                                                                        boxShadow: [
                                                                          BoxShadow(
                                                                            color:
                                                                                Colors.grey.withOpacity(0.5),
                                                                            spreadRadius:
                                                                                2,
                                                                            blurRadius:
                                                                                5,
                                                                            offset:
                                                                                Offset(0, 3), // changes position of shadow
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      margin: EdgeInsets
                                                                          .all(
                                                                              8.0),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(right: 8.0, top: 8),
                                                                            child:
                                                                                Center(
                                                                              child: Align(
                                                                                  alignment: Alignment.centerRight,
                                                                                  child: GestureDetector(
                                                                                    onTap: () async {
                                                                                      String? token = await getTokenFromSharedPreferences(); // Récupérer le token de l'utilisateur
                                                                                      if (token != null) {
                                                                                        String? userId = await getUserIdFromToken(token); // Récupérer le userId à partir du token
                                                                                        if (userId != null) {
                                                                                          // String productId = products[index].id; // Récupérer l'ID du produit à partir de la liste des produits
                                                                                          toggleFavoriteState(index, userId, item['_id']); // Appeler toggleFavoriteState avec index, userId et productId
                                                                                        } else {
                                                                                          print('Impossible de récupérer le userId');
                                                                                        }
                                                                                      } else {
                                                                                        print('Token non trouvé localement');
                                                                                      }
                                                                                    },
                                                                                    child: Image.asset(
                                                                                      isFavorite ? 'assets/images/cor.png' : 'assets/images/hear.png',
                                                                                      width: 24,
                                                                                      height: 24,
                                                                                    ),
                                                                                  )),
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                ClipRRect(
                                                                              borderRadius: BorderRadius.vertical(
                                                                                top: Radius.circular(20.0),
                                                                              ),
                                                                              child: Image.network(
                                                                                imageData, // Utilisez vos données binaires ici
                                                                                fit: BoxFit.cover,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                Text(
                                                                              item['Nom'],
                                                                              maxLines: 2,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                color: Color(0xFF666666),
                                                                                fontSize: 14,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 8.0),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Text(
                                                                                  'TND ${item['Montant HT']}',
                                                                                  style: TextStyle(
                                                                                    color: Color(0xFF006583),
                                                                                    fontSize: 16,
                                                                                    fontWeight: FontWeight.bold,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  )
                                                ],
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                              Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 14.0),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFac9ece),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(50.0),
                                      bottomLeft: Radius.circular(50.0),
                                    ),
                                  ),
                                  height: 430,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 28.0, vertical: 15.0),
                                  child: FutureBuilder<List<dynamic>>(
                                    future: futureProducts,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      } else if (snapshot.hasError) {
                                        return Center(
                                            child: Text(
                                                'Error: ${snapshot.error}'));
                                      } else {
                                        final List<dynamic> nouveautes =
                                            snapshot.data!;
                                        final List<dynamic> filteredNouveautes =
                                            nouveautes
                                                .where((item) =>
                                                    item['type'] == 'gaming')
                                                .toList();

                                        if (filteredNouveautes.isEmpty) {
                                          return Container(); // Retourner une vue vide si aucune nouveauté n'est trouvée
                                        }

                                        // Convertir la chaîne de caractères en Uint8List
                                        
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Gaming",
                                              style: TextStyle(
                                                fontSize: 25.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Transform.translate(
                                              offset: Offset(0, -4),
                                              child: const Text(
                                                "Plongez dans l'univers de gaming",
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF666666),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Transform.translate(
                                              offset: Offset(0, -14),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                child: Image.network(
                                                  filteredNouveautes[0]['Image'],
                                                  width: 100,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Transform.translate(
                                              offset: Offset(-0.5, 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    },
                                  ),
                                )
                              ],
                            ), 
                            Stack(
  children: [
    Container(
      padding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Transform.translate(
            offset: Offset(5, 0),
            child: Text(
              "offre de la semaine",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
            child: FutureBuilder<List<dynamic>>(
              future: futureProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  final List<dynamic> categorie = snapshot.data!;
                  final filteredCategories = categorie
                      .where((item) => item['type'] == "offre")
                      .toList();

                  if (filteredCategories.isEmpty) {
                    return Container();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 25.0, vertical: 15.0),
                        child: FutureBuilder<List<dynamic>>(
                          future: futureProducts,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            } else {
                              final List<dynamic> gridMap = snapshot.data!;
                              final filteredGridMap = gridMap
                                  .where((item) => item['type'] == "offre")
                                  .toList();

                              if (filteredGridMap.isEmpty) {
                                return Container();
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GridView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10.0,
                                      mainAxisSpacing: 10.0,
                                      mainAxisExtent: 200,
                                    ),
                                    itemCount: filteredGridMap.length,
                                    itemBuilder: (_, index) {
                                      final item = filteredGridMap[index];
                                      final isFavorite =
                                          favoriteStates[index];
                                      final String imageData =
                                          item['Image'];

                                      return GestureDetector(
                                        onTap: () {
                                          // Gérer l'action de clic sur un produit
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 2,
                                                blurRadius: 5,
                                                offset: Offset(
                                                    0,
                                                    3), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          margin: EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.only(
                                                        right: 8.0, top: 8),
                                                child: Center(
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: GestureDetector(
                                                      onTap: () async {
                                                        String? token =
                                                            await getTokenFromSharedPreferences();
                                                        if (token != null) {
                                                          String? userId =
                                                              await getUserIdFromToken(
                                                                  token);
                                                          if (userId != null) {
                                                            toggleFavoriteState(
                                                                index,
                                                                userId,
                                                                item['_id']);
                                                          } else {
                                                            print(
                                                                'Impossible de récupérer le userId');
                                                          }
                                                        } else {
                                                          print(
                                                              'Token non trouvé localement');
                                                        }
                                                      },
                                                      child: Image.asset(
                                                        isFavorite
                                                            ? 'assets/images/cor.png'
                                                            : 'assets/images/hear.png',
                                                        width: 24,
                                                        height: 24,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                    top: Radius.circular(20.0),
                                                  ),
                                                  child: Image.network(
                                                    imageData,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  item['Nom'],
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xFF666666),
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'TND ${item['Montant HT']}',
                                                      style: TextStyle(
                                                        color: Color(0xFF006583),
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                      )
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    ),
    Stack(
  children: [
    Container(
      padding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Transform.translate(
            offset: Offset(5, 0),
            child: Text(
              "offre de la semaine",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
            child: FutureBuilder<List<dynamic>>(
              future: futureProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  final List<dynamic> categorie = snapshot.data!;
                  final filteredCategories = categorie
                      .where((item) => item['type'] == "offre")
                      .toList();

                  if (filteredCategories.isEmpty) {
                    return Container();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 25.0, vertical: 15.0),
                        child: FutureBuilder<List<dynamic>>(
                          future: futureProducts,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            } else {
                              final List<dynamic> gridMap = snapshot.data!;
                              final filteredGridMap = gridMap
                                  .where((item) => item['type'] == "offre")
                                  .toList();

                              if (filteredGridMap.isEmpty) {
                                return Container();
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GridView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10.0,
                                      mainAxisSpacing: 10.0,
                                      mainAxisExtent: 200,
                                    ),
                                    itemCount: filteredGridMap.length,
                                    itemBuilder: (_, index) {
                                      final item = filteredGridMap[index];
                                      final isFavorite =
                                          favoriteStates[index];
                                      final String imageData =
                                          item['Image'];

                                      return GestureDetector(
                                        onTap: () {
                                          // Gérer l'action de clic sur un produit
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 2,
                                                blurRadius: 5,
                                                offset: Offset(
                                                    0,
                                                    3), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          margin: EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.only(
                                                        right: 8.0, top: 8),
                                                child: Center(
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: GestureDetector(
                                                      onTap: () async {
                                                        String? token =
                                                            await getTokenFromSharedPreferences();
                                                        if (token != null) {
                                                          String? userId =
                                                              await getUserIdFromToken(
                                                                  token);
                                                          if (userId != null) {
                                                            toggleFavoriteState(
                                                                index,
                                                                userId,
                                                                item['_id']);
                                                          } else {
                                                            print(
                                                                'Impossible de récupérer le userId');
                                                          }
                                                        } else {
                                                          print(
                                                              'Token non trouvé localement');
                                                        }
                                                      },
                                                      child: Image.asset(
                                                        isFavorite
                                                            ? 'assets/images/cor.png'
                                                            : 'assets/images/hear.png',
                                                        width: 24,
                                                        height: 24,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                    top: Radius.circular(20.0),
                                                  ),
                                                  child: Image.network(
                                                    imageData,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  item['Nom'],
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xFF666666),
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'TND ${item['Montant HT']}',
                                                      style: TextStyle(
                                                        color: Color(0xFF006583),
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                      )
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    ),
    Transform.translate(
      offset: Offset(0, -80),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: Brands.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Container(
                                width: Brands[index]['width'],
                                height: Brands[index]['height'],
                                margin: EdgeInsets.only(
                                    bottom: 15.0, left: 5, right: 5),
                                child: Image.asset(
                                  Brands[index]['imagePath'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  ],
),
SizedBox(
  height: 10,
),



    Transform.translate(
      offset: Offset(0, -80),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: Brands.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Container(
                                width: Brands[index]['width'],
                                height: Brands[index]['height'],
                                margin: EdgeInsets.only(
                                    bottom: 15.0, left: 5, right: 5),
                                child: Image.asset(
                                  Brands[index]['imagePath'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  ],
),
SizedBox(
  height: 10,
),


                            SizedBox(height: 1.0),
                           //fin gaming

                      

                            SizedBox(height: 1.0),
                            Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 14.0),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFADC1BC),
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(50.0),
                                      bottomRight: Radius.circular(50.0),
                                    ),
                                  ),
                                  height: 430,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 28.0, vertical: 15.0),
                                  child: FutureBuilder<List<dynamic>>(
                                    future: futureProducts,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      } else if (snapshot.hasError) {
                                        return Center(
                                            child: Text(
                                                'Error: ${snapshot.error}'));
                                      } else {
                                        final List<dynamic> nouveautes =
                                            snapshot.data!;
                                        final List<dynamic> filteredNouveautes =
                                            nouveautes
                                                .where((item) =>
                                                    item['type'] ==
                                                    'notre selection')
                                                .toList();

                                        if (filteredNouveautes.isEmpty) {
                                          return Container(); // Retourner une vue vide si aucune nouveauté n'est trouvée
                                        }

                                        // Convertir la chaîne de caractères en Uint8List
                                        
                                        

                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Notre sélection",
                                              style: TextStyle(
                                                fontSize: 25.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Transform.translate(
                                              offset: Offset(0, -14),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                child: Image.network(
                                                  filteredNouveautes[0]['Image'],
                                                  width: 100,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Transform.translate(
                                              offset: Offset(-0.5, 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  // Afficher d'autres nouveautés ici en utilisant les données filtrées
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    },
                                  ),
                                )
                              ],
                            ),
                              
                            SizedBox(
                              height: 10,
                            ),
                            Stack(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 25.0, vertical: 15.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Transform.translate(
                                        offset: Offset(5, 0),
                                        child: Text(
                                          "Tendances",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 4.0),
                                      // Add some space between row and grid
                                      GriA(),
                                    ],
                                  ),
                                ),
                              ],
                            ), 

                            SizedBox(height: 1.0),
                            Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 14.0),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF00A3FF),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(50.0),
                                      bottomLeft: Radius.circular(50.0),
                                    ),
                                  ),
                                  height: 430,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 28.0, vertical: 15.0),
                                  child: FutureBuilder<List<dynamic>>(
                                    future: futureProducts,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      } else if (snapshot.hasError) {
                                        return Center(
                                            child: Text(
                                                'Error: ${snapshot.error}'));
                                      } else {
                                        final List<dynamic> nouveautes =
                                            snapshot.data!;
                                        final List<dynamic> filteredNouveautes =
                                            nouveautes
                                                .where((item) =>
                                                    item['type'] ==
                                                    'electromenager')
                                                .toList();

                                        if (filteredNouveautes.isEmpty) {
                                          return Container(); 
                                        }
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Électroménager",
                                              style: TextStyle(
                                                fontSize: 25.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Transform.translate(
                                              offset: Offset(0, -4),
                                              child: const Text(
                                                "Découvrez notre gamme d'électroménagers intelligents",
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF666666),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Transform.translate(
                                              offset: Offset(0, -14),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                child: Image.network(
                                                  filteredNouveautes[0]['Image'],
                                                  width: 100,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Transform.translate(
                                              offset: Offset(-0.5, 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                 
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    },
                                  ),
                                )
                              ],
                            ), //fin electro

                               SizedBox(height: 1),
                            Stack(
                              children: [
                                Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 1.0, vertical: 1.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Stack(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 18.0,
                                                  vertical: 15.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Image.asset(
                                                        'assets/images/ramadan.png',
                                                        width: 20,
                                                        height: 20,
                                                      ),
                                                      SizedBox(width: 5.0),
                                                      Text(
                                                        "Offre Ramadhan 2024",
                                                        style: TextStyle(
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 1.0, vertical: 1.0),
                                          child: FutureBuilder<List<dynamic>>(
                                            future: futureProducts,
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              } else if (snapshot.hasError) {
                                                return Center(
                                                    child: Text(
                                                        'Error: ${snapshot.error}'));
                                              } else {
                                                final List<dynamic> categorie =
                                                    snapshot.data!;
                                                final filteredCategories =
                                                    categorie
                                                        .where((item) =>
                                                            item['type'] ==
                                                            "offre")
                                                        .toList();

                                                if (filteredCategories
                                                    .isEmpty) {
                                                  return Container(); // Retourner une vue vide si aucune catégorie de type "Top Catégories" n'est trouvée
                                                }

                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(height: 10),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 15.0,
                                                              vertical: 10.0),
                                                      child: FutureBuilder<
                                                          List<dynamic>>(
                                                        future: futureProducts,
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .waiting) {
                                                            return Center(
                                                                child:
                                                                    CircularProgressIndicator());
                                                          } else if (snapshot
                                                              .hasError) {
                                                            return Center(
                                                                child: Text(
                                                                    'Error: ${snapshot.error}'));
                                                          } else {
                                                            final List<dynamic>
                                                                gridMap =
                                                                snapshot.data!;
                                                            final filteredGridMap = gridMap
                                                                .where((item) =>
                                                                    item[
                                                                        'type'] ==
                                                                    "offre romdhan")
                                                                .toList();

                                                            if (filteredGridMap
                                                                .isEmpty) {
                                                              return Container(); // Retourner une vue vide si aucun produit de type "Meilleures Ventes" n'est trouvé
                                                            }

                                                            return Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                GridView
                                                                    .builder(
                                                                  physics:
                                                                      const NeverScrollableScrollPhysics(),
                                                                  shrinkWrap:
                                                                      true,
                                                                  gridDelegate:
                                                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                                                    crossAxisCount:
                                                                        2,
                                                                    crossAxisSpacing:
                                                                        10.0,
                                                                    mainAxisSpacing:
                                                                        10.0,
                                                                    mainAxisExtent:
                                                                        200,
                                                                  ),
                                                                  itemCount:
                                                                      filteredGridMap
                                                                          .length,
                                                                  itemBuilder:
                                                                      (_, index) {
                                                                    final item =
                                                                        filteredGridMap[
                                                                            index];
                                                                    final isFavorite =
                                                                        favoriteStates[
                                                                            index];
                                                                    final String
                                                                        imageDataString =
                                                                        item[
                                                                            'Image']; // Supposons que les données binaires de l'image sont stockées dans un champ 'imageData' sous forme de chaîne de caractères


                                                                    return GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        // Gérer l'action de clic sur un produit
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(20.0),
                                                                          color:
                                                                              Colors.white,
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                              color: Colors.grey.withOpacity(0.5),
                                                                              spreadRadius: 2,
                                                                              blurRadius: 5,
                                                                              offset: Offset(0, 3), // changes position of shadow
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        margin:
                                                                            EdgeInsets.all(8.0),
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(right: 8.0, top: 8),
                                                                              child: Center(
                                                                                child: Align(
                                                                                    alignment: Alignment.centerRight,
                                                                                    child: GestureDetector(
                                                                                      onTap: () async {
                                                                                        String? token = await getTokenFromSharedPreferences(); // Récupérer le token de l'utilisateur
                                                                                        if (token != null) {
                                                                                          String? userId = await getUserIdFromToken(token); // Récupérer le userId à partir du token
                                                                                          if (userId != null) {
                                                                                            // String productId = products[index].id; // Récupérer l'ID du produit à partir de la liste des produits
                                                                                            toggleFavoriteState(index, userId, item['_id']); // Appeler toggleFavoriteState avec index, userId et productId
                                                                                          } else {
                                                                                            print('Impossible de récupérer le userId');
                                                                                          }
                                                                                        } else {
                                                                                          print('Token non trouvé localement');
                                                                                        }
                                                                                      },
                                                                                      child: Image.asset(
                                                                                        isFavorite ? 'assets/images/cor.png' : 'assets/images/hear.png',
                                                                                        width: 24,
                                                                                        height: 24,
                                                                                      ),
                                                                                    )),
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              child: ClipRRect(
                                                                                borderRadius: BorderRadius.vertical(
                                                                                  top: Radius.circular(20.0),
                                                                                ),
                                                                                child:Image.network(
  item['Image'],
  width: 100,
  height: 100, // Added height to maintain aspect ratio
  fit: BoxFit.cover,
)

                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Text(
                                                                                item['Nom'],
                                                                                maxLines: 2,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  color: Color(0xFF666666),
                                                                                  fontSize: 14,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Text(
                                                                                    'TND ${item['Montant HT']}',
                                                                                    style: TextStyle(
                                                                                      color: Color(0xFF006583),
                                                                                      fontSize: 16,
                                                                                      fontWeight: FontWeight.bold,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              ],
                                                            );
                                                          }
                                                        },
                                                      ),
                                                    )
                                                  ],
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    )),
                              ],
                            ), //fin ramadhan //fin selection


                            Transform.translate(

                              offset: Offset(0, -80),
                              child: Stack(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5.0, vertical: 15.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          height: 100,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: Brands.length,
                                            itemBuilder: (context, index) {
                                              return Stack(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5.0),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                      child: Container(
                                                        width: Brands[index]
                                                            ['width'],
                                                        height: Brands[index]
                                                            ['height'],
                                                        margin: EdgeInsets.only(
                                                            bottom: 15.0,
                                                            left: 5,
                                                            right: 5),
                                                        child: Image.asset(
                                                          Brands[index]
                                                              ['imagePath'],
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),


                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                ),
                
              ),
        
           
            ),
            
            
          ],
           
        ),
        
       
     
        
        
         bottomNavigationBar: Container(
  decoration: BoxDecoration(
    color: Color(0xFFEFEFEF),
    borderRadius: BorderRadius.vertical(
      top: Radius.circular(55.0),
    ),
  ),
  child: BottomNavigationBar(
    currentIndex: 2,
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.search),
        label: 'recherche',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.card_giftcard),
        label: 'panier',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person), 
        label: 'profile',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.account_circle), 
        label: 'favoris',
      ),
    ],
    selectedItemColor: Colors.black,
    unselectedItemColor: Color(0xFF006583),
    showSelectedLabels: true,
    showUnselectedLabels: true,
    onTap: (index) {
      switch (index) {
        case 0:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RecherchePage()),
          );
          break;
        case 1:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PanierPage(id: '',quantite: 0,)),
          );
          break;
        case 2:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>RecherchePage()),
          );
          break;
        case 3:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage()),
          );
          break;
      }
     
    },
   
  ),
),

endDrawer: NavBar(),
      ),
    );
  }

  String _calculateDiscountedPrice(String price, String discount) {
    double originalPrice = double.parse(price.substring(3));
    double discountPercentage = double.parse(discount.replaceAll('%', ''));
    double discountedPrice =
        originalPrice - (originalPrice * discountPercentage / 100);
    return discountedPrice.toStringAsFixed(1);
  }

BottomNavigationBarItem bottomNavigationBarItem({
  required String image,
  required String label,
  required Widget page,
}) {
  return BottomNavigationBarItem(
    icon: Padding(
      padding: EdgeInsets.only(top: 5, right: 2),
      child: Image.asset(
        image,
        width: 30,
        height: 30,
      ),
    ),
    label: label,
  );
}

  _buildListTileWithButton(String s, String t, String u, BuildContext context) {}

}

class FabExt extends StatelessWidget {
  const FabExt({
    Key? key,
    required this.showFabTitle,
  }) : super(key: key);

  final bool showFabTitle;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {},
      label: AnimatedContainer(
        duration: const Duration(seconds: 2),
        padding: const EdgeInsets.all(20.0),
      ),
    );
  }
}

class Product {
  final String id;
  final String title;
  final double price;
  final String imageUrl;

  Product(
      {required this.id,
      required this.title,
      required this.price,
      required this.imageUrl});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      title: json['title'],
      price: json['price'].toDouble(),
      imageUrl: json['Image'] ??
          'assets/images/1.png', // Use a placeholder if no image provided
    );
  }
}

class GridB extends StatefulWidget {
  const GridB({Key? key}) : super(key: key);

  @override
  _GridBState createState() => _GridBState();
}

class _GridBState extends State<GridB> {
  late Future<List<dynamic>> futureProducts;
  late List<bool> favoriteStates;

  @override
  void initState() {
    super.initState();
    futureProducts = getProducts();
    favoriteStates = [];
  }

  Future<List<dynamic>> getProducts() async {
    final response =
        await http.get(Uri.parse("http://192.168.1.15:3003/product/products"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      favoriteStates = List.generate(data.length,
          (_) => false); // Generate favoriteStates based on data length
      return data;
    } else {
      throw Exception('Failed to get data: ${response.statusCode}');
    }
  }

  void toggleFavoriteState(int index) {
    setState(() {
      favoriteStates[index] = !favoriteStates[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: futureProducts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final List<dynamic> gridMap = snapshot.data!;
          final filteredGridMap = gridMap
              .where((item) => item['type'] == "Meilleurs ventes")
              .toList();

          if (filteredGridMap.isEmpty) {
            return Container(); // Retourner une vue vide si aucun produit de type "Meilleures Ventes" n'est trouvé
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Meilleurs ventes",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  mainAxisExtent: 200,
                ),
                itemCount: filteredGridMap.length,
                itemBuilder: (_, index) {
                  final item = filteredGridMap[index];
                  final isFavorite = favoriteStates[index];
                 final String? imageData = item['Image'] as String?;

           

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductPage(
                            Nom: item['Nom'],
                            id: item['_id'],
                            Montant_HT: item['MontantHT'],
                            Montant_TTC: item['Montant_TTC'],
                           quantite: item['Quantité'],
                           Etat: item['État'],
                           categorie: item['categorie'],
                            Image: item['Image'],
                            type: item['type'],
                            reference : item['Référence']
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      margin: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0, top: 8),
                            child: Center(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {
                                    toggleFavoriteState(index);
                                  },
                                  child: Image.asset(
                                    isFavorite
                                        ? 'assets/images/cor.png'
                                        : 'assets/images/hear.png',
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20.0),
                              ),
                            child: imageData != null
    ? Image.network(
        imageData,
        fit: BoxFit.cover,
      )
    : Placeholder(), // Vous pouvez remplacer Placeholder() par n'importe quel widget ou message que vous souhaitez afficher pour les images nulles

                            ),
                          ),
                         Padding(
  padding: const EdgeInsets.all(8.0),
  child: item['Nom'] != null
      ? Text(
          item['Nom']!,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Color(0xFF666666),
            fontSize: 14,
          ),
        )
      : Text("Title not available"),
),

                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'TND ${item['Montant HT']}',
                                  style: TextStyle(
                                    color: Color(0xFF006583),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        }
      },
    );
    
  }
}

class GriA extends StatefulWidget {
  const GriA({Key? key}) : super(key: key);

  @override
  _GriAState createState() => _GriAState();
}

class _GriAState extends State<GriA> {
  late List<bool> showFullTitles;
  late List<bool> favoriteStates;
  @override
  void initState() {
    super.initState();
    // Initialiser la liste showFullTitles avec des valeurs par défaut à false
    showFullTitles = List.generate(6, (_) => false);
    favoriteStates = List.generate(6, (_) => false);
  }

  void toggleFavoriteState(int index) {
    setState(() {
      favoriteStates[index] = !favoriteStates[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> gridMap = [
      
    ];

    late List<bool> favoriteStates;
    Future<List<dynamic>> getProducts() async {
      final response = await http
          .get(Uri.parse("http://192.168.1.15:3003/product/products"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        favoriteStates = List.generate(data.length, (_) => false);
        return data;
      } else {
        throw Exception('Failed to get data: ${response.statusCode}');
      }
    }

    late Future<List<dynamic>> futureProducts =
        getProducts(); // Initialisation directe

    @override
    void initState() {
      super.initState();
      favoriteStates = [];
    }

    void toggleFavoriteState(int index) {
      setState(() {
        favoriteStates[index] = !favoriteStates[index];
      });
    }

    return FutureBuilder<List<dynamic>>(
      future: futureProducts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final List<dynamic> gridMap = snapshot.data!;
          final filteredGridMap =
              gridMap.where((item) => item['type'] == "tendance").toList();

          if (filteredGridMap.isEmpty) {
            return Container(); 
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  mainAxisExtent: 200,
                ),
                itemCount: filteredGridMap.length,
                itemBuilder: (_, index) {
                  final item = filteredGridMap[index];
                  final isFavorite = favoriteStates[index];
                  final String imageDataString = item[
                      'Image']; 
                  

                  return GestureDetector(
                    onTap: () {
                     
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3), 
                          ),
                        ],
                      ),
                      margin: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0, top: 8),
                            child: Center(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {
                                    toggleFavoriteState(index);
                                  },
                                  child: Image.asset(
                                    isFavorite
                                        ? 'assets/images/cor.png'
                                        : 'assets/images/hear.png',
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20.0),
                              ),
                              child: Image.network(
                                imageDataString, // Utilisez vos données binaires ici
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              item['Nom'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF666666),
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'TND ${item['Montant HT']}',
                                  style: TextStyle(
                                    color: Color(0xFF006583),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ), 
                        ],
                      ),
                    ),
                    
                  );
                },
              ),
            ],           
          );                  
        }
      },     
    );  
  }
  String _calculateDiscountedPrice(String price, String discount) {
    double originalPrice = double.parse(price.substring(3));
    double discountPercentage = double.parse(discount.replaceAll('%', ''));
    double discountedPrice =
        originalPrice - (originalPrice * discountPercentage / 100);
    return discountedPrice.toStringAsFixed(1);
  }  
  _buildListTileWithButton(String s, String t, String u, BuildContext context) {}
}
