// ============================================================
// home_screen.dart — Main Dashboard / Home Screen
// AI-Based Virtual Try-On Application
// ============================================================
// PURPOSE:
//   The main landing screen after authentication. Shows search,
//   categories (Men, Women, Kids, Accessories), featured products
//   with responsive cards, and a Material 3 bottom navigation bar.
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/product_provider.dart';
import '../themes/app_theme.dart';
import 'profile_screen.dart';
import '../models/product_model.dart';
import '../screens/tryon_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  // ── State Variables ───────────────────────────────────────
  int _currentIndex = 0;
  String _selectedCategory = 'Men';
  final _searchController = TextEditingController();

  final List<String> _categories = ['Men', 'Women', 'Kids', 'Accessories'];

  // Local mock products fallback to guarantee a beautiful UI
  final List<Map<String, dynamic>> _mockProducts = [
    {
      'name': 'Futuristic Cyber Jacket',
      'price': 129.99,
      'category': 'Men',
    },
    {
      'name': 'Holographic Silk Dress',
      'price': 159.50,
      'category': 'Women',
    },
    {
      'name': 'Neon Street Hoodie',
      'price': 79.99,
      'category': 'Kids',
    },
    {
      'name': 'Chrono Smart Eyewear',
      'price': 249.00,
      'category': 'Accessories',
    },
    {
      'name': 'Vaporwave Sneakers',
      'price': 110.00,
      'category': 'Men',
    },
    {
      'name': 'Cyberpunk Cargo Pants',
      'price': 89.99,
      'category': 'Women',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Load products via provider on start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ── Navigation Handler ────────────────────────────────────
  void _onBottomNavTapped(int index) {
    if (index == _currentIndex) return;

    if (index == 2) {
      // Navigate to Try-On screen
      Navigator.pushNamed(context, TryOnScreen.routeName);
    } else if (index == 3) {
      // Navigate to Profile screen
      Navigator.pushNamed(context, ProfileScreen.routeName);
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  // ── Build ─────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      // ── Custom M3 AppBar ──────────────────────────────────
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [AppTheme.primaryPurple, AppTheme.accentCyan],
          ).createShader(bounds),
          child: const Text(
            'AI Virtual Try-On',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, ProfileScreen.routeName),
              child: Consumer<AuthProvider>(
                builder: (context, auth, _) {
                  final initial = auth.user?.name.isNotEmpty == true
                      ? auth.user!.name[0].toUpperCase()
                      : 'U';
                  return CircleAvatar(
                    radius: 18,
                    backgroundColor: AppTheme.primaryPurple.withValues(alpha: 0.8),
                    child: Text(
                      initial,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // ── Background Ambient Glow ────────────────────────
          Positioned(
            top: -150,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryPurple.withValues(alpha: 0.15),
              ),
            ),
          ),
          Positioned(
            bottom: -150,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.accentCyan.withValues(alpha: 0.1),
              ),
            ),
          ),

          // ── Scrollable Body ────────────────────────────────
          SafeArea(
            child: RefreshIndicator(
              onRefresh: () => context.read<ProductProvider>().fetchProducts(),
              color: AppTheme.primaryPurple,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),

                    // ── 1. Search Bar ────────────────────────────────
                    _buildSearchBar(),

                    const SizedBox(height: 24),

                    // ── 2. Categories Section ────────────────────────
                    const Text(
                      'Categories',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildCategoriesList(),

                    const SizedBox(height: 24),

                    // ── 3. Featured Products Section ─────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Featured Products',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'See All',
                            style: TextStyle(
                              color: AppTheme.accentCyan,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Responsive GridView for Products
                    _buildProductsGrid(isLandscape),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // ── 4. Bottom Navigation Bar ──────────────────────────
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.white.withValues(alpha: 0.08),
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onBottomNavTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppTheme.surfaceDark,
          selectedItemColor: AppTheme.primaryPurple,
          unselectedItemColor: Colors.white38,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline),
              activeIcon: Icon(Icons.favorite_rounded),
              label: 'Wishlist',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt_outlined),
              activeIcon: Icon(Icons.camera_alt_rounded),
              label: 'Try-On',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  // ── Search Bar Builder ────────────────────────────────────
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white, fontSize: 15),
        decoration: InputDecoration(
          hintText: 'Search style, brands, clothing...',
          hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: Colors.white38),
          suffixIcon: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryPurple.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.tune, color: AppTheme.accentCyan, size: 18),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onChanged: (val) {
          context.read<ProductProvider>().search(val);
        },
      ),
    );
  }

  // ── Categories List Builder ───────────────────────────────
  Widget _buildCategoriesList() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category;
              });
              context.read<ProductProvider>().filterByCategory(category);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: isSelected
                    ? const LinearGradient(
                        colors: [AppTheme.primaryPurple, AppTheme.accentCyan],
                      )
                    : null,
                color: isSelected ? null : Colors.white.withValues(alpha: 0.05),
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : Colors.white.withValues(alpha: 0.1),
                ),
              ),
              child: Center(
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Products Grid Builder ─────────────────────────────────
  Widget _buildProductsGrid(bool isLandscape) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, _) {
        // Filter the items based on selected category and search queries
        final filteredItems = productProvider.items.isNotEmpty
            ? productProvider.items
            : _mockProducts
                .where((mock) =>
                    mock['category'] == _selectedCategory &&
                    (productProvider.error != null ||
                        mock['name']
                            .toString()
                            .toLowerCase()
                            .contains(_searchController.text.toLowerCase())))
                .toList();

        if (productProvider.isLoading) {
          return const SizedBox(
            height: 200,
            child: Center(
              child: CircularProgressIndicator(color: AppTheme.primaryPurple),
            ),
          );
        }

        if (filteredItems.isEmpty) {
          return SizedBox(
            height: 200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.style_outlined, color: Colors.white24, size: 48),
                  SizedBox(height: 12),
                  Text(
                    'No items found in this category',
                    style: TextStyle(color: Colors.white38),
                  ),
                ],
              ),
            ),
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isLandscape ? 4 : 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 0.72,
          ),
          itemCount: filteredItems.length,
          itemBuilder: (context, index) {
            // Build each product card handling both ProductModel and mock Map entries
            final item = filteredItems[index];
            String name;
            double price;
            if (item is ProductModel) {
              name = item.name;
              price = item.price;
            } else if (item is Map<String, dynamic>) {
              name = item['name'] ?? '';
              price = (item['price'] ?? 0).toDouble();
            } else {
              name = '';
              price = 0.0;
            }
            return _buildProductCard(name, price);


          },
        );
      },
    );
  }

  // ── Responsive Product Card Builder ────────────────────────
  Widget _buildProductCard(String name, double price) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image Placeholder ──────────────────────────────
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primaryPurple.withValues(alpha: 0.1),
                    AppTheme.accentCyan.withValues(alpha: 0.1),
                  ],
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.checkroom_rounded,
                  color: Colors.white.withValues(alpha: 0.15),
                  size: 40,
                ),
              ),
            ),
          ),

          // ── Content ────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: AppTheme.accentCyan,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryPurple.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.add_shopping_cart,
                        color: AppTheme.primaryPurple,
                        size: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
