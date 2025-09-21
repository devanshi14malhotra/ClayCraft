import 'package:flutter/material.dart';
import 'package:claycraft_google_gen_ai/services/local_storage.dart';
import 'package:claycraft_google_gen_ai/models/product.dart';
import 'package:claycraft_google_gen_ai/widgets/product_card.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  final LocalStorageService _storage = LocalStorageService();
  final TextEditingController _searchController = TextEditingController();
  
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  ProductCategory? _selectedCategory;
  ProductStyle? _selectedStyle;
  
  @override
  void initState() {
    super.initState();
    _loadProducts();
    _searchController.addListener(_onSearchChanged);
  }

  void _loadProducts() {
    setState(() {
      _products = _storage.products;
      _filteredProducts = _products;
    });
  }

  void _onSearchChanged() {
    _applyFilters();
  }

  void _applyFilters() {
    setState(() {
      _filteredProducts = _storage.searchProducts(_searchController.text);
      
      if (_selectedCategory != null) {
        _filteredProducts = _filteredProducts
            .where((p) => p.category == _selectedCategory)
            .toList();
      }
      
      if (_selectedStyle != null) {
        _filteredProducts = _filteredProducts
            .where((p) => p.style == _selectedStyle)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketplace'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      body: Column(
        children: [
          // Search and Filters
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.surface,
            child: Column(
              children: [
                // Search bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search pottery, artisans...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Filter chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Category filters
                      ...ProductCategory.values.map((category) => 
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(_formatCategoryName(category)),
                            selected: _selectedCategory == category,
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategory = selected ? category : null;
                                _applyFilters();
                              });
                            },
                          ),
                        ),
                      ),
                      
                      // Style filters
                      ...ProductStyle.values.map((style) => 
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(_formatStyleName(style)),
                            selected: _selectedStyle == style,
                            onSelected: (selected) {
                              setState(() {
                                _selectedStyle = selected ? style : null;
                                _applyFilters();
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Products Grid
          Expanded(
            child: _filteredProducts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No products found',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your search or filters',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) => ProductCard(
                      product: _filteredProducts[index],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  String _formatCategoryName(ProductCategory category) {
    switch (category) {
      case ProductCategory.bowl:
        return 'Bowls';
      case ProductCategory.vase:
        return 'Vases';
      case ProductCategory.plate:
        return 'Plates';
      case ProductCategory.mug:
        return 'Mugs';
      case ProductCategory.sculpture:
        return 'Sculptures';
      case ProductCategory.decorative:
        return 'Decorative';
    }
  }

  String _formatStyleName(ProductStyle style) {
    switch (style) {
      case ProductStyle.traditional:
        return 'Traditional';
      case ProductStyle.modern:
        return 'Modern';
      case ProductStyle.minimalist:
        return 'Minimalist';
      case ProductStyle.rustic:
        return 'Rustic';
      case ProductStyle.contemporary:
        return 'Contemporary';
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}