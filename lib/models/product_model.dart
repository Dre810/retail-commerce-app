class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double originalPrice; // For showing discounts
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final String category;
  final List<String> tags;
  final bool isFeatured;
  final bool isPopular;
  final int stock;
  final List<String> colors; // Available colors
  final List<String> sizes; // Available sizes

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice = 0,
    required this.imageUrl,
    required this.rating,
    this.reviewCount = 0,
    required this.category,
    this.tags = const [],
    this.isFeatured = false,
    this.isPopular = false,
    required this.stock,
    this.colors = const [],
    this.sizes = const [],
  });

  // Calculate discount percentage
  double get discountPercentage {
    if (originalPrice > 0) {
      return ((originalPrice - price) / originalPrice * 100).roundToDouble();
    }
    return 0;
  }

  // Check if product is on sale
  bool get isOnSale => originalPrice > price;

  // Format price nicely
  String get formattedPrice => '\$${price.toStringAsFixed(2)}';
  String get formattedOriginalPrice => '\$${originalPrice.toStringAsFixed(2)}';

  // Create from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      originalPrice: (json['originalPrice'] ?? 0).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      category: json['category'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      isFeatured: json['isFeatured'] ?? false,
      isPopular: json['isPopular'] ?? false,
      stock: json['stock'] ?? 0,
      colors: List<String>.from(json['colors'] ?? []),
      sizes: List<String>.from(json['sizes'] ?? []),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'originalPrice': originalPrice,
      'imageUrl': imageUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'category': category,
      'tags': tags,
      'isFeatured': isFeatured,
      'isPopular': isPopular,
      'stock': stock,
      'colors': colors,
      'sizes': sizes,
    };
  }
}