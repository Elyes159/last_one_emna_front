import 'package:flutter/material.dart';

class OrderDetailsPage extends StatelessWidget {
  final List<dynamic> orderedProducts;

  const OrderDetailsPage({Key? key, required this.orderedProducts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de la commande'),
      ),
      body: ListView.builder(
        itemCount: orderedProducts.length,
        itemBuilder: (context, index) {
          final product = orderedProducts[index];
          return ListTile(
           
           
            title: Text('${product['Nom']}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Référence: ${product['Référence']}'),
                Text('Quantité: ${product['quantity'] ?? ''}'),
                Text('Prix unitaire: ${product['price'] ?? ''}'), // Ajoutez d'autres détails si nécessaire
              ],
            ),
          );
        },
      ),
    );
  }
}
