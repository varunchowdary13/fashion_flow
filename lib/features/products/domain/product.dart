import 'package:equatable/equatable.dart';

/// Product entity representing a fashion item.
class Product extends Equatable {
  final int id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final double? rating;
  final int? reviewCount;
  final List<String>? sizes;
  final List<String>? colors;
  final bool inStock;
  final DateTime? createdAt;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.rating,
    this.reviewCount,
    this.sizes,
    this.colors,
    this.inStock = true,
    this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image_url'] as String? ?? '',
      category: json['category'] as String? ?? 'Uncategorized',
      rating: json['rating'] != null
          ? (json['rating'] as num).toDouble()
          : null,
      reviewCount: json['review_count'] as int?,
      sizes: json['sizes'] != null
          ? List<String>.from(json['sizes'] as List)
          : null,
      colors: json['colors'] != null
          ? List<String>.from(json['colors'] as List)
          : null,
      inStock: json['in_stock'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image_url': imageUrl,
      'category': category,
      'rating': rating,
      'review_count': reviewCount,
      'sizes': sizes,
      'colors': colors,
      'in_stock': inStock,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  Product copyWith({
    int? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? category,
    double? rating,
    int? reviewCount,
    List<String>? sizes,
    List<String>? colors,
    bool? inStock,
    DateTime? createdAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      sizes: sizes ?? this.sizes,
      colors: colors ?? this.colors,
      inStock: inStock ?? this.inStock,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    price,
    imageUrl,
    category,
    rating,
    reviewCount,
    sizes,
    colors,
    inStock,
    createdAt,
  ];
}
