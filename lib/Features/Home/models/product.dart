class Product {
  final int id;
  final String title;
  final String description;
  final String thumbnailImage;
  final double price;
  final double rating;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.thumbnailImage,
      required this.price,
      required this.rating});

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        thumbnailImage: json['thumbnail'] ?? '',
        price: double.tryParse(json['price']?.toString() ?? '') ?? 0.0,
        rating: double.tryParse(json['rating']?.toString() ?? '') ?? 0.0,
      );
}
