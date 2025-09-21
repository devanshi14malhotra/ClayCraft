import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:claycraft_google_gen_ai/models/user.dart';
import 'package:claycraft_google_gen_ai/models/product.dart';
import 'package:claycraft_google_gen_ai/models/order.dart';
import 'package:claycraft_google_gen_ai/models/design.dart';
import 'package:claycraft_google_gen_ai/services/sample_data.dart';

class LocalStorageService extends ChangeNotifier {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  // Current user session
  User? _currentUser;
  User? get currentUser => _currentUser;

  // In-memory storage (simulating local database)
  List<User> _users = [];
  List<Product> _products = [];
  List<Order> _orders = [];
  List<Design> _designs = [];
  List<String> _favorites = [];

  // Getters
  List<User> get users => _users;
  List<Product> get products => _products;
  List<Order> get orders => _orders;
  List<Design> get designs => _designs;
  List<String> get favorites => _favorites;

  // Initialize with sample data
  void initialize() {
    _users = [...SampleData.getSampleArtisans(), ...SampleData.getSampleBuyers()];
    _products = SampleData.getSampleProducts();
    _orders = SampleData.getSampleOrders();
    _designs = SampleData.getSampleDesigns();
    _favorites = [];
    notifyListeners();
  }

  // User authentication
  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final user = _users.firstWhere(
      (u) => u.email == email,
      orElse: () => _users.first, // For demo, login with any email
    );
    _currentUser = user;
    notifyListeners();
    return true;
  }

  Future<bool> register(User user) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _users.add(user);
    _currentUser = user;
    notifyListeners();
    return true;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  // Product management
  List<Product> searchProducts(String query) {
    if (query.isEmpty) return _products;
    return _products.where((p) =>
      p.name.toLowerCase().contains(query.toLowerCase()) ||
      p.description.toLowerCase().contains(query.toLowerCase()) ||
      p.artisanName.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  List<Product> getProductsByCategory(ProductCategory category) =>
      _products.where((p) => p.category == category).toList();

  List<Product> getProductsByStyle(ProductStyle style) =>
      _products.where((p) => p.style == style).toList();

  List<Product> getProductsByArtisan(String artisanId) =>
      _products.where((p) => p.artisanId == artisanId).toList();

  Product? getProductById(String id) =>
      _products.firstWhere((p) => p.id == id, orElse: () => _products.first);

  // Favorites management
  void toggleFavorite(String productId) {
    if (_favorites.contains(productId)) {
      _favorites.remove(productId);
    } else {
      _favorites.add(productId);
    }
    notifyListeners();
  }

  bool isFavorite(String productId) => _favorites.contains(productId);

  List<Product> getFavoriteProducts() =>
      _products.where((p) => _favorites.contains(p.id)).toList();

  // Order management
  Future<String> createOrder({
    required String productId,
    required String customRequirements,
    required String shippingAddress,
  }) async {
    if (_currentUser == null) throw Exception('User not logged in');
    
    final product = getProductById(productId);
    if (product == null) throw Exception('Product not found');

    final order = Order(
      id: 'order_${DateTime.now().millisecondsSinceEpoch}',
      productId: productId,
      productName: product.name,
      buyerId: _currentUser!.id,
      artisanId: product.artisanId,
      totalPrice: product.price,
      status: OrderStatus.pending,
      orderDate: DateTime.now(),
      estimatedCompletion: DateTime.now().add(Duration(days: product.estimatedDays)),
      customRequirements: customRequirements.isNotEmpty ? customRequirements : null,
      shippingAddress: shippingAddress,
    );

    _orders.add(order);
    notifyListeners();
    return order.id;
  }

  List<Order> getUserOrders() {
    if (_currentUser == null) return [];
    return _orders.where((o) => 
      o.buyerId == _currentUser!.id || o.artisanId == _currentUser!.id
    ).toList();
  }

  // Design management
  Future<String> saveDesign(Design design) async {
    _designs.add(design);
    notifyListeners();
    return design.id;
  }

  List<Design> getUserDesigns() {
    if (_currentUser == null) return [];
    return _designs.where((d) => d.userId == _currentUser!.id).toList();
  }

  List<Design> getPublicDesigns() =>
      _designs.where((d) => d.isPublic).toList();

  // Artisan management
  List<User> getArtisans() =>
      _users.where((u) => u.role == UserRole.artisan).toList();

  User? getArtisanById(String id) =>
      _users.firstWhere((u) => u.id == id, orElse: () => _users.first);

  List<User> searchArtisans(String query) {
    if (query.isEmpty) return getArtisans();
    return getArtisans().where((a) =>
      a.name.toLowerCase().contains(query.toLowerCase()) ||
      (a.specialty?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
      (a.location?.toLowerCase().contains(query.toLowerCase()) ?? false)
    ).toList();
  }
}