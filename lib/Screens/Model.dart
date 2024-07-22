class Product {
  int? id;
  String name;
  String description;
  String imagePath;

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.imagePath,
  });

  // Convert a Product into a Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imagePath': imagePath,
    };
  }

  // Extract a Product object from a Map.
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      imagePath: map['imagePath'],
    );
  }
}
