import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/menu_item_model.dart';
import '../../core/services/app_state_provider.dart';
import '../../core/services/local_image_helper.dart';
import '../../core/services/sample_data.dart';
import '../../core/widgets/cart_toast_notification.dart';
import '../cart/cart_screen.dart';
import 'food_detail_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final _searchController = TextEditingController();

  final List<String> _categories = SampleData.categories;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = Provider.of<AppStateProvider>(context);
    final items = appState.filteredMenuItems;
    final cartCount = appState.cart.fold<int>(0, (sum, i) => sum + i.quantity);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Aramielle Menu'),
            Text(
              '${appState.selectedTableNumber ?? "Table 01"} • Dine-in & Take-out',
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary),
            ),
          ],
        ),
        actions: [
          // 1. Cart Button with Badge
          IconButton(
            tooltip: 'View Cart',
            icon: Badge(
              isLabelVisible: cartCount > 0,
              label: Text(
                '$cartCount',
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
              backgroundColor: const Color(0xFFFFC900),
              textColor: const Color(0xFF1A1A1A),
              child: Icon(
                Icons.shopping_cart_outlined,
                color: theme.colorScheme.primary,
              ),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CartScreen()),
              );
            },
          ),

          // 2. Theme Toggle (Sun/Moon)
          IconButton(
            icon: Icon(appState.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            tooltip: appState.isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
            onPressed: () {
              appState.toggleThemeMode();
            },
          ),

          // 3. Scan Table QR Code
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            tooltip: 'Scan Table QR Code',
            onPressed: () {
              _showTableQRDialog(context, appState);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => appState.setSearchQuery(val),
              decoration: InputDecoration(
                hintText: 'Search Steak, Pizza, Pasta, Coffee, Bulalo...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          appState.setSearchQuery('');
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Horizontally Scrollable Category Chips Row
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = appState.selectedCuisine == category;
                return ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  selectedColor: theme.colorScheme.primary,
                  labelStyle: TextStyle(
                    color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      appState.setCuisineFilter(category);
                    }
                  },
                );
              },
            ),
          ),

          // Allergen Filter Toggle Bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: appState.filterOutMyAllergies
                  ? Colors.red.withAlpha(30)
                  : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: appState.filterOutMyAllergies ? Colors.red : theme.colorScheme.primary.withAlpha(60),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.no_food_outlined,
                      color: appState.filterOutMyAllergies ? Colors.red : theme.colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Filter out my allergies (${appState.currentUser.allergies.join(", ")})',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: appState.filterOutMyAllergies ? Colors.red : theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                Switch(
                  value: appState.filterOutMyAllergies,
                  activeThumbColor: Colors.red,
                  onChanged: (val) => appState.toggleAllergenFilter(val),
                ),
              ],
            ),
          ),

          // Menu List
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.restaurant_menu, size: 64, color: theme.colorScheme.onSurface.withAlpha(120)),
                        const SizedBox(height: 16),
                        Text(
                          'No dishes found in this category',
                          style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurface),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try clearing your search or category filter.',
                          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withAlpha(160)),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final userAllergies = appState.currentUser.allergies;
                      final hasAllergyWarning = item.allergens.any((a) => userAllergies.contains(a));

                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => FoodDetailScreen(menuItem: item),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                // Local or Network Food Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: _buildFoodImage(item, theme),
                                ),
                                const SizedBox(width: 14),

                                // Food Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    item.name,
                                                    style: theme.textTheme.titleMedium?.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      color: theme.colorScheme.onSurface,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                if (item.isPopular) ...[
                                                  const SizedBox(width: 4),
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                    decoration: BoxDecoration(
                                                      color: Colors.amber,
                                                      borderRadius: BorderRadius.circular(6),
                                                    ),
                                                    child: const Text(
                                                      'POPULAR',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 8,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                          Text(
                                            '₱${item.price.toStringAsFixed(0)}',
                                            style: theme.textTheme.titleMedium?.copyWith(
                                              color: theme.colorScheme.primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),

                                      Text(
                                        item.description,
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: theme.colorScheme.onSurface.withAlpha(180),
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),

                                      // Badges & Quick Add Button Row
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Wrap(
                                            spacing: 6,
                                            runSpacing: 4,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: theme.colorScheme.primary.withAlpha(30),
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  item.cuisine,
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: theme.colorScheme.primary,
                                                  ),
                                                ),
                                              ),
                                              if (hasAllergyWarning)
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: Colors.red.withAlpha(40),
                                                    borderRadius: BorderRadius.circular(6),
                                                  ),
                                                  child: const Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Icon(Icons.warning, size: 10, color: Colors.red),
                                                      SizedBox(width: 3),
                                                      Text(
                                                        'Allergy Match',
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.red,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ),

                                          // Quick Add Button
                                          ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: theme.colorScheme.primary,
                                              foregroundColor: const Color(0xFF1A1A1A),
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                              minimumSize: Size.zero,
                                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                            ),
                                            icon: const Icon(Icons.add_shopping_cart, size: 14),
                                            label: const Text('Add', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                            onPressed: () {
                                              appState.addToCart(item, quantity: 1);
                                              CartToastNotification.show(
                                                context,
                                                message: 'Added 1x ${item.name} to cart!',
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodImage(MenuItemModel item, ThemeData theme) {
    final localAsset = LocalImageHelper.getLocalAssetPath(item.name, item.id);

    if (localAsset != null) {
      return Image.asset(
        localAsset,
        width: 90,
        height: 90,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _buildNetworkOrPlaceholderImage(item, theme),
      );
    }
    return _buildNetworkOrPlaceholderImage(item, theme);
  }

  Widget _buildNetworkOrPlaceholderImage(MenuItemModel item, ThemeData theme) {
    if (item.imageUrl.isNotEmpty && item.imageUrl.startsWith('http')) {
      return Image.network(
        item.imageUrl,
        width: 90,
        height: 90,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _buildFallbackContainer(theme),
      );
    }
    return _buildFallbackContainer(theme);
  }

  Widget _buildFallbackContainer(ThemeData theme) {
    return Container(
      width: 90,
      height: 90,
      color: theme.colorScheme.primary.withAlpha(30),
      child: Icon(Icons.fastfood, color: theme.colorScheme.primary, size: 36),
    );
  }

  void _showTableQRDialog(BuildContext context, AppStateProvider appState) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Scan or Select Table'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.qr_code_2, size: 80),
              const SizedBox(height: 12),
              const Text('Scanned QR Code Table Selection'),
              const SizedBox(height: 16),
              DropdownButton<String>(
                value: appState.selectedTableNumber,
                isExpanded: true,
                items: List.generate(10, (i) => 'Table ${(i + 1).toString().padLeft(2, '0')}').map((t) {
                  return DropdownMenuItem(value: t, child: Text(t));
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    appState.setTableNumber(val);
                    Navigator.pop(ctx);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
