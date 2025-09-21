import 'package:flutter/material.dart';
import 'package:claycraft_google_gen_ai/services/local_storage.dart';
import 'package:claycraft_google_gen_ai/models/design.dart';

class StudioScreen extends StatefulWidget {
  const StudioScreen({super.key});

  @override
  State<StudioScreen> createState() => _StudioScreenState();
}

class _StudioScreenState extends State<StudioScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final LocalStorageService _storage = LocalStorageService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Virtual Studio'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Create', icon: Icon(Icons.palette)),
            Tab(text: 'My Designs', icon: Icon(Icons.folder)),
            Tab(text: 'Gallery', icon: Icon(Icons.photo_library)),
          ],
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const CreateDesignTab(),
          MyDesignsTab(storage: _storage),
          const PublicGalleryTab(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class CreateDesignTab extends StatefulWidget {
  const CreateDesignTab({super.key});

  @override
  State<CreateDesignTab> createState() => _CreateDesignTabState();
}

class _CreateDesignTabState extends State<CreateDesignTab> {
  String _selectedShape = 'bowl';
  String _selectedSize = 'medium';
  String _selectedStyle = 'modern';
  Color _selectedColor = Colors.brown;
  String _selectedFinish = 'matte';
  
  final List<String> _shapes = ['bowl', 'vase', 'plate', 'mug', 'sculpture'];
  final List<String> _sizes = ['small', 'medium', 'large', 'extra_large'];
  final List<String> _styles = ['traditional', 'modern', 'minimalist', 'rustic'];
  final List<String> _finishes = ['matte', 'glossy', 'textured', 'metallic'];
  final List<Color> _colors = [
    Colors.brown, Colors.grey, Colors.blue, Colors.green,
    Colors.red, Colors.orange, Colors.purple, Colors.black,
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome message
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context).colorScheme.secondaryContainer,
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to Your Virtual Studio!',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Create your custom pottery design and connect with skilled artisans who can bring it to life.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Design Preview
          Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getShapeIcon(),
                    size: 80,
                    color: _selectedColor,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_selectedSize.toUpperCase()} ${_selectedShape.toUpperCase()}',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                    '$_selectedStyle • $_selectedFinish',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Shape Selection
          _buildSectionHeader('Shape'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _shapes.map((shape) => 
              ChoiceChip(
                label: Text(_capitalize(shape)),
                selected: _selectedShape == shape,
                onSelected: (selected) => setState(() => _selectedShape = shape),
              ),
            ).toList(),
          ),
          const SizedBox(height: 20),

          // Size Selection
          _buildSectionHeader('Size'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _sizes.map((size) => 
              ChoiceChip(
                label: Text(_capitalize(size.replaceAll('_', ' '))),
                selected: _selectedSize == size,
                onSelected: (selected) => setState(() => _selectedSize = size),
              ),
            ).toList(),
          ),
          const SizedBox(height: 20),

          // Style Selection
          _buildSectionHeader('Style'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _styles.map((style) => 
              ChoiceChip(
                label: Text(_capitalize(style)),
                selected: _selectedStyle == style,
                onSelected: (selected) => setState(() => _selectedStyle = style),
              ),
            ).toList(),
          ),
          const SizedBox(height: 20),

          // Color Selection
          _buildSectionHeader('Color'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _colors.map((color) => 
              GestureDetector(
                onTap: () => setState(() => _selectedColor = color),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _selectedColor == color 
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                      width: 3,
                    ),
                  ),
                ),
              ),
            ).toList(),
          ),
          const SizedBox(height: 20),

          // Finish Selection
          _buildSectionHeader('Finish'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _finishes.map((finish) => 
              ChoiceChip(
                label: Text(_capitalize(finish)),
                selected: _selectedFinish == finish,
                onSelected: (selected) => setState(() => _selectedFinish = finish),
              ),
            ).toList(),
          ),
          const SizedBox(height: 32),

          // Save Design Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveDesign,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Save My Design'),
            ),
          ),
          const SizedBox(height: 12),
          
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _findArtisans,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Find Matching Artisans'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }

  IconData _getShapeIcon() {
    switch (_selectedShape) {
      case 'bowl': return Icons.soup_kitchen;
      case 'vase': return Icons.local_florist;
      case 'plate': return Icons.dinner_dining;
      case 'mug': return Icons.coffee;
      case 'sculpture': return Icons.architecture;
      default: return Icons.circle;
    }
  }

  String _capitalize(String text) {
    return text[0].toUpperCase() + text.substring(1);
  }

  void _saveDesign() {
    final design = Design(
      id: 'design_${DateTime.now().millisecondsSinceEpoch}',
      name: '${_capitalize(_selectedStyle)} ${_capitalize(_selectedShape)}',
      userId: LocalStorageService().currentUser?.id ?? '',
      description: 'A $_selectedSize $_selectedShape with $_selectedStyle style in $_selectedFinish finish',
      specifications: {
        'shape': _selectedShape,
        'size': _selectedSize,
        'style': _selectedStyle,
        'color': _selectedColor.value.toString(),
        'finish': _selectedFinish,
      },
      suggestedArtisans: [], // Would be populated by matching algorithm
      createdAt: DateTime.now(),
    );

    LocalStorageService().saveDesign(design);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Design saved successfully!')),
    );
  }

  void _findArtisans() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ArtisanMatchingSheet(
        designSpecs: {
          'shape': _selectedShape,
          'size': _selectedSize,
          'style': _selectedStyle,
          'finish': _selectedFinish,
        },
      ),
    );
  }
}

class MyDesignsTab extends StatelessWidget {
  final LocalStorageService storage;
  
  const MyDesignsTab({super.key, required this.storage});

  @override
  Widget build(BuildContext context) {
    final designs = storage.getUserDesigns();
    
    if (designs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.palette_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No designs yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first pottery design!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: designs.length,
      itemBuilder: (context, index) => DesignCard(design: designs[index]),
    );
  }
}

class PublicGalleryTab extends StatelessWidget {
  const PublicGalleryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final publicDesigns = LocalStorageService().getPublicDesigns();
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: publicDesigns.length,
      itemBuilder: (context, index) => DesignCard(
        design: publicDesigns[index],
        showAuthor: true,
      ),
    );
  }
}

class DesignCard extends StatelessWidget {
  final Design design;
  final bool showAuthor;
  
  const DesignCard({super.key, required this.design, this.showAuthor = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getShapeIcon(design.specifications['shape']),
                  size: 40,
                  color: Color(int.parse(design.specifications['color'] ?? '0xFF8B4513')),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        design.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (showAuthor) ...[
                        const SizedBox(height: 4),
                        Text(
                          'by User ${design.userId.hashCode % 1000}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Text(
                  _formatDate(design.createdAt),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              design.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _buildSpecChip(context, design.specifications['style'] ?? ''),
                _buildSpecChip(context, design.specifications['size'] ?? ''),
                _buildSpecChip(context, design.specifications['finish'] ?? ''),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _shareDesign(context),
                    child: const Text('Share'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _findArtisans(context),
                    child: const Text('Find Artisans'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecChip(BuildContext context, String spec) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        spec,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.onSecondaryContainer,
        ),
      ),
    );
  }

  IconData _getShapeIcon(String? shape) {
    switch (shape) {
      case 'bowl': return Icons.soup_kitchen;
      case 'vase': return Icons.local_florist;
      case 'plate': return Icons.dinner_dining;
      case 'mug': return Icons.coffee;
      case 'sculpture': return Icons.architecture;
      default: return Icons.circle;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date).inDays;
    
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (diff < 7) return '${diff}d ago';
    if (diff < 30) return '${diff ~/ 7}w ago';
    return '${diff ~/ 30}m ago';
  }

  void _shareDesign(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share feature coming soon!')),
    );
  }

  void _findArtisans(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ArtisanMatchingSheet(
        designSpecs: design.specifications,
      ),
    );
  }
}

class ArtisanMatchingSheet extends StatelessWidget {
  final Map<String, dynamic> designSpecs;
  
  const ArtisanMatchingSheet({super.key, required this.designSpecs});

  @override
  Widget build(BuildContext context) {
    final artisans = LocalStorageService().getArtisans();
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Text(
                  'Matching Artisans',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: artisans.length,
              itemBuilder: (context, index) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      artisans[index].name.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  title: Text(artisans[index].name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(artisans[index].specialty ?? 'Pottery Specialist'),
                      Row(
                        children: [
                          Icon(Icons.star, size: 16, color: Colors.amber[700]),
                          const SizedBox(width: 4),
                          Text('${artisans[index].rating ?? 4.5}'),
                          const SizedBox(width: 8),
                          Text('${artisans[index].yearsExperience ?? 5}+ years'),
                        ],
                      ),
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () => _contactArtisan(context, artisans[index].name),
                    child: const Text('Contact'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _contactArtisan(BuildContext context, String artisanName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Contacting $artisanName...')),
    );
    Navigator.pop(context);
  }
}