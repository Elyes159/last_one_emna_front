import 'package:flutter/material.dart';
import 'package:untitled2/page/page/productpage.dart';
import 'package:untitled2/page/sidebar.dart';

class RechercheResult extends StatefulWidget {
  final List result;

  RechercheResult({
    required this.result
  });

  @override
  _RechercheResultState createState() => _RechercheResultState();
}

class _RechercheResultState extends State<RechercheResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
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
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(55),
            topRight: Radius.circular(55),
            bottomLeft: Radius.circular(55), // Ajout du coin inférieur gauche
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Résultats",
                textAlign: TextAlign.center, // Centrage du texte
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.result.length,
                itemBuilder: (BuildContext context, int index) {
                  Map<String, dynamic> produit = widget.result[index];
                  return ListTile(
                    leading: Image.network(
                      widget.result[index]['Image'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(produit['Nom']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Prix HT: ${widget.result[index]['Montant HT']}'),
                        Text('Prix TTC: ${widget.result[index]['Montant TTC']}'),
                        Text('Quantité: ${produit['Quantité']}'),
                        Text('État: ${produit['État']}'),
                        Text('Catégorie: ${produit['Categorie']}'),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => ProductPage(
                            Nom: widget.result[index]['Nom'],
                            Montant_HT: widget.result[index]['Montant HT'],
                            Montant_TTC: widget.result[index]['Montant TTC'],
                            Etat: widget.result[index]['État'],
                            quantite: widget.result[index]['Quantité'],
                            categorie: widget.result[index]['Categorie'],
                            Image: widget.result[index]['Image'],
                            id: widget.result[index]['_id'],
                            type: widget.result[index]['type'],
                            reference: widget.result[index]['Référence']
                          ))
                        )
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      endDrawer: NavBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back),
        backgroundColor: Color(0xFF006583),
      ),
    );
  }
}
