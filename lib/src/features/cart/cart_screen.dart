import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/app_state_provider.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = Provider.of<AppStateProvider>(context);
    final cart = appState.cart;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          if (cart.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              tooltip: 'Clear Cart',
              onPressed: () => appState.clearCart(),
            ),
        ],
      ),
      body: cart.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 80, color: theme.colorScheme.secondary.withAlpha(120)),
                  const SizedBox(height: 16),
                  Text(
                    'Your cart is empty',
                    style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.secondary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Browse Italian, Chinese, or Filipino dishes to add to your order.',
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.secondary.withAlpha(160)),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Order Type Selector Bar (Dine-In vs Take-Out)
                Container(
                  color: theme.colorScheme.surface,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: SegmentedButton<String>(
                          segments: const [
                            ButtonSegment(
                              value: 'Dine-in',
                              label: Text('Dine-In'),
                              icon: Icon(Icons.table_restaurant),
                            ),
                            ButtonSegment(
                              value: 'Take-out',
                              label: Text('Take-Out'),
                              icon: Icon(Icons.takeout_dining),
                            ),
                          ],
                          selected: {appState.orderType},
                          onSelectionChanged: (newSelection) {
                            appState.setOrderType(newSelection.first);
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Table selection banner for Dine-in
                if (appState.orderType == 'Dine-in')
                  Container(
                    color: theme.colorScheme.primary.withAlpha(30),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.qr_code, color: theme.colorScheme.primary),
                            const SizedBox(width: 8),
                            Text(
                              'Table: ${appState.selectedTableNumber}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            // Quick change table
                          },
                          child: const Text('Change'),
                        ),
                      ],
                    ),
                  ),

                // Cart Items List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final cartItem = cart[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  cartItem.item.imageUrl,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => Container(
                                    width: 60,
                                    height: 60,
                                    color: Colors.grey[800],
                                    child: Icon(Icons.restaurant, color: theme.colorScheme.primary),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cartItem.item.name,
                                      style: theme.textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.secondary,
                                      ),
                                    ),
                                    Text(
                                      '₱${cartItem.item.price.toStringAsFixed(2)} each',
                                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary),
                                    ),
                                    if (cartItem.specialInstructions.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        'Note: ${cartItem.specialInstructions}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontStyle: FontStyle.italic,
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),

                              // Quantity Controls
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove_circle_outline, size: 22, color: theme.colorScheme.primary),
                                    onPressed: () {
                                      appState.updateCartQuantity(
                                        cartItem.item.id,
                                        cartItem.quantity - 1,
                                      );
                                    },
                                  ),
                                  Text(
                                    '${cartItem.quantity}',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: theme.colorScheme.secondary),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add_circle_outline, size: 22, color: theme.colorScheme.primary),
                                    onPressed: () {
                                      appState.updateCartQuantity(
                                        cartItem.item.id,
                                        cartItem.quantity + 1,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Bottom Checkout Bar
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    border: Border(top: BorderSide(color: theme.colorScheme.primary.withAlpha(40))),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Subtotal',
                            style: TextStyle(fontSize: 16, color: theme.colorScheme.secondary),
                          ),
                          Text(
                            '₱${appState.cartSubtotal.toStringAsFixed(2)}',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                          );
                        },
                        child: const Text('Proceed to Checkout & Payment'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
