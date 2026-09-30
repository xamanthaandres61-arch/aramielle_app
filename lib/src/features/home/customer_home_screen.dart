import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/app_state_provider.dart';
import '../cart/cart_screen.dart';

class CustomerHomeScreen extends StatelessWidget {
  final Function(int)? onNavigateToTab;

  const CustomerHomeScreen({super.key, this.onNavigateToTab});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = Provider.of<AppStateProvider>(context);
    final user = appState.currentUser;
    final cartCount = appState.cart.fold<int>(0, (sum, i) => sum + i.quantity);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.restaurant_menu, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Aramielle Restaurant',
                overflow: TextOverflow.ellipsis,
              ),
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
            onPressed: () => appState.toggleThemeMode(),
          ),

          // 3. Table Pager Shortcut
          IconButton(
            icon: const Icon(Icons.notifications_active_outlined),
            tooltip: 'Table Service Pager',
            onPressed: () {
              if (onNavigateToTab != null) {
                onNavigateToTab!(2); // Navigate to Table Service Pager tab
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome Header Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: theme.colorScheme.primary,
                          child: Text(
                            user.name.isNotEmpty ? user.name[0].toUpperCase() : 'A',
                            style: TextStyle(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome, ${user.name}!',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${appState.selectedTableNumber} • Dine-in & Take-out Ready',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Experience fine Italian, Chinese, and Filipino culinary creations. Order digitally right from your table!',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withAlpha(180),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Quick Action Shortcuts Grid
            Text(
              'Quick Actions',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildShortcutCard(
                    context: context,
                    icon: Icons.menu_book_rounded,
                    title: 'Browse Menu',
                    subtitle: 'Italian, Chinese, Filipino',
                    color: Colors.amber,
                    onTap: () {
                      if (onNavigateToTab != null) onNavigateToTab!(1); // Menu tab
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildShortcutCard(
                    context: context,
                    icon: Icons.notifications_active,
                    title: 'Table Pager',
                    subtitle: 'Water, Waiter, Bill',
                    color: Colors.orange,
                    onTap: () {
                      if (onNavigateToTab != null) onNavigateToTab!(2); // Pager tab
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildShortcutCard(
                    context: context,
                    icon: Icons.delivery_dining,
                    title: 'Active Orders',
                    subtitle: 'Live kitchen status',
                    color: Colors.green,
                    onTap: () {
                      if (onNavigateToTab != null) onNavigateToTab!(3); // Orders tab
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildShortcutCard(
                    context: context,
                    icon: Icons.person_outline,
                    title: 'My Profile',
                    subtitle: 'Allergies & Points',
                    color: Colors.purple,
                    onTap: () {
                      if (onNavigateToTab != null) onNavigateToTab!(4); // Profile tab
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Cuisine Categories Section
            Text(
              'Cuisine Categories',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Column(
              children: [
                _buildCuisineCategoryCard(
                  context: context,
                  title: 'Italian Cuisine',
                  description: 'Authentic Fettuccine Pasta, Wood-fired Pizzas & Bolognese',
                  flag: '🇮🇹',
                  cuisineName: 'Italian',
                  onTap: () {
                    appState.setCuisineFilter('Italian');
                    if (onNavigateToTab != null) onNavigateToTab!(1); // Menu
                  },
                ),
                const SizedBox(height: 10),

                _buildCuisineCategoryCard(
                  context: context,
                  title: 'Chinese Cuisine',
                  description: 'Handmade Xiao Long Bao, Kung Pao Chicken & Yangzhou Fried Rice',
                  flag: '🇨🇳',
                  cuisineName: 'Chinese',
                  onTap: () {
                    appState.setCuisineFilter('Chinese');
                    if (onNavigateToTab != null) onNavigateToTab!(1); // Menu
                  },
                ),
                const SizedBox(height: 10),

                _buildCuisineCategoryCard(
                  context: context,
                  title: 'Filipino Cuisine',
                  description: 'Crispy Pork Sisig, Beef Kare-Kare & Signature Crispy Pata',
                  flag: '🇵🇭',
                  cuisineName: 'Filipino',
                  onTap: () {
                    appState.setCuisineFilter('Filipino');
                    if (onNavigateToTab != null) onNavigateToTab!(1); // Menu
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Restaurant Information Card
            Card(
              color: theme.colorScheme.primary.withAlpha(20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.storefront, color: theme.colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Aramielle Restaurant Info',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),

                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 18, color: theme.colorScheme.onSurface),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Don Manuel Subd, Bulilan Sur, Pila Highway',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Icon(Icons.access_time, size: 18, color: theme.colorScheme.onSurface),
                        const SizedBox(width: 8),
                        const Text(
                          'Open Daily: 10:00 AM – 10:00 PM',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildShortcutCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withAlpha(30),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 10, color: Colors.grey),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCuisineCategoryCard({
    required BuildContext context,
    required String title,
    required String description,
    required String flag,
    required String cuisineName,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Text(flag, style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withAlpha(160),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: theme.colorScheme.primary),
            ],
          ),
        ),
      ),
    );
  }
}
