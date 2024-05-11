class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String title;
  final String brands;
  final String quantite;
  final String cupons;
  final bool disponibilite;
  final String caracteristique;
  final String image;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.title,
    required this.brands,
    required this.quantite,
    required this.cupons,
    required this.disponibilite,
    required this.caracteristique,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      title: json['title'],
      brands: json['brands'],
      quantite: json['quantite'],
      cupons: json['cupons'],
      disponibilite: json['disponibilite'],
      caracteristique: json['caracteristique'],
      image: json['image'],
    );
  }
}
