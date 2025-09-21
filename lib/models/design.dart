class Design {
  final String id;
  final String name;
  final String userId;
  final String description;
  final String? imageUrl;
  final Map<String, dynamic> specifications;
  final List<String> suggestedArtisans;
  final DateTime createdAt;
  final bool isPublic;
  final String? inspirationSource;

  const Design({
    required this.id,
    required this.name,
    required this.userId,
    required this.description,
    this.imageUrl,
    required this.specifications,
    required this.suggestedArtisans,
    required this.createdAt,
    this.isPublic = false,
    this.inspirationSource,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'userId': userId,
    'description': description,
    'imageUrl': imageUrl,
    'specifications': specifications,
    'suggestedArtisans': suggestedArtisans,
    'createdAt': createdAt.toIso8601String(),
    'isPublic': isPublic,
    'inspirationSource': inspirationSource,
  };

  factory Design.fromJson(Map<String, dynamic> json) => Design(
    id: json['id'],
    name: json['name'],
    userId: json['userId'],
    description: json['description'],
    imageUrl: json['imageUrl'],
    specifications: Map<String, dynamic>.from(json['specifications']),
    suggestedArtisans: json['suggestedArtisans'].cast<String>(),
    createdAt: DateTime.parse(json['createdAt']),
    isPublic: json['isPublic'],
    inspirationSource: json['inspirationSource'],
  );
}