enum ProductCategory { bowl, vase, plate, mug, sculpture, decorative }
enum ProductStyle { traditional, modern, minimalist, rustic, contemporary }

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final ProductCategory category;
  final ProductStyle style;
  final List<String> images;
  final String artisanId;
  final String artisanName;
  final bool isAvailable;
  final int estimatedDays;
  final List<String> materials;
  final Map<String, String> dimensions;
  final DateTime createdAt;
  final double? rating;
  final int? reviewCount;
  final bool isCustomizable;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.style,
    required this.images,
    required this.artisanId,
    required this.artisanName,
    this.isAvailable = true,
    required this.estimatedDays,
    required this.materials,
    required this.dimensions,
    required this.createdAt,
    this.rating,
    this.reviewCount,
    this.isCustomizable = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'price': price,
    'category': category.name,
    'style': style.name,
    'images': images,
    'artisanId': artisanId,
    'artisanName': artisanName,
    'isAvailable': isAvailable,
    'estimatedDays': estimatedDays,
    'materials': materials,
    'dimensions': dimensions,
    'createdAt': createdAt.toIso8601String(),
    'rating': rating,
    'reviewCount': reviewCount,
    'isCustomizable': isCustomizable,
  };

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    price: json['price'].toDouble(),
    category: ProductCategory.values.firstWhere((e) => e.name == json['category']),
    style: ProductStyle.values.firstWhere((e) => e.name == json['style']),
    images: json['images'].cast<String>(),
    artisanId: json['artisanId'],
    artisanName: json['artisanName'],
    isAvailable: json['isAvailable'],
    estimatedDays: json['estimatedDays'],
    materials: json['materials'].cast<String>(),
    dimensions: Map<String, String>.from(json['dimensions']),
    createdAt: DateTime.parse(json['createdAt']),
    rating: json['rating']?.toDouble(),
    reviewCount: json['reviewCount'],
    isCustomizable: json['isCustomizable'],
  );
}