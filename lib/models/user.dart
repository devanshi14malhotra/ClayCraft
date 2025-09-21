enum UserRole { artisan, buyer }

class User {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? bio;
  final String? location;
  final String? profileImage;
  final DateTime createdAt;
  
  // Artisan-specific fields
  final String? specialty;
  final int? yearsExperience;
  final List<String>? skills;
  final double? rating;
  
  // Buyer-specific fields
  final List<String>? interests;
  final List<String>? favoriteStyles;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.bio,
    this.location,
    this.profileImage,
    required this.createdAt,
    this.specialty,
    this.yearsExperience,
    this.skills,
    this.rating,
    this.interests,
    this.favoriteStyles,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'role': role.name,
    'bio': bio,
    'location': location,
    'profileImage': profileImage,
    'createdAt': createdAt.toIso8601String(),
    'specialty': specialty,
    'yearsExperience': yearsExperience,
    'skills': skills,
    'rating': rating,
    'interests': interests,
    'favoriteStyles': favoriteStyles,
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    role: UserRole.values.firstWhere((e) => e.name == json['role']),
    bio: json['bio'],
    location: json['location'],
    profileImage: json['profileImage'],
    createdAt: DateTime.parse(json['createdAt']),
    specialty: json['specialty'],
    yearsExperience: json['yearsExperience'],
    skills: json['skills']?.cast<String>(),
    rating: json['rating']?.toDouble(),
    interests: json['interests']?.cast<String>(),
    favoriteStyles: json['favoriteStyles']?.cast<String>(),
  );
}