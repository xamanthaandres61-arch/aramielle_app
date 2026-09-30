import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/app_state_provider.dart';

class OrderTrackingScreen extends StatelessWidget {
  final String? orderId;

  const OrderTrackingScreen({super.key, this.orderId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = Provider.of<AppStateProvider>(context);

    final activeOrder = orderId != null
        ? appState.orders.firstWhere((o) => o.id == orderId, orElse: () => appState.activeOrder!)
        : appState.activeOrder;

    if (activeOrder == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Live Order Status')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.fastfood_outlined, size: 80, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'No active orders right now',
                style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    // Determine progress index
    int stepIndex = 0;
    switch (activeOrder.orderStatus) {
      case 'Pending Verification':
        stepIndex = 0;
        break;
      case 'Preparing':
        stepIndex = 1;
        break;
      case 'Ready':
        stepIndex = 2;
        break;
      case 'Served':
        stepIndex = 3;
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Order Status'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Order ID & Table Badge
            Card(
              color: theme.colorScheme.primary,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      'Order #${activeOrder.id}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${activeOrder.orderType} • ${activeOrder.tableNumber}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Status: ${activeOrder.orderStatus.toUpperCase()}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Live Order Timeline Tracker
            Text(
              'Kitchen & Delivery Pipeline',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            _buildTimelineStep(
              title: 'Order Submitted & Payment Verification',
              subtitle: 'Cashier POS verifying GCash receipt & Senior/PWD ID',
              icon: Icons.receipt,
              isActive: stepIndex >= 0,
              isCurrent: stepIndex == 0,
            ),
            _buildTimelineStep(
              title: 'ESP32 Kitchen Alert Sounded & Preparing',
              subtitle: 'Kitchen buzzer triggered; cooks preparing your Italian/Chinese/Filipino dishes',
              icon: Icons.soup_kitchen,
              isActive: stepIndex >= 1,
              isCurrent: stepIndex == 1,
            ),
            _buildTimelineStep(
              title: 'Order Ready',
              subtitle: 'Food is prepared and plated ready for serving',
              icon: Icons.dinner_dining,
              isActive: stepIndex >= 2,
              isCurrent: stepIndex == 2,
            ),
            _buildTimelineStep(
              title: 'Served to Table',
              subtitle: 'Dishes served! Table status updated on POS dashboard',
              icon: Icons.check_circle,
              isActive: stepIndex >= 3,
              isCurrent: stepIndex == 3,
              isLast: true,
            ),
            const SizedBox(height: 24),

            // Ordered Items Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Breakdown',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(height: 20),

                    ...activeOrder.items.map((cartItem) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${cartItem.quantity}x ${cartItem.item.name}'),
                            Text('₱${cartItem.totalPrice.toStringAsFixed(2)}'),
                          ],
                        ),
                      );
                    }),
                    const Divider(height: 20),

                    if (activeOrder.discountAmount > 0) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${activeOrder.discountType} Discount:'),
                          Text(
                            '-₱${activeOrder.discountAmount.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                    ],

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Paid:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          '₱${activeOrder.totalAmount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: theme.colorScheme.primary,
                          ),
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

  Widget _buildTimelineStep({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isActive,
    required bool isCurrent,
    bool isLast = false,
  }) {
    final color = isActive ? (isCurrent ? Colors.amber[800] : Colors.green) : Colors.grey[400];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color?.withAlpha(40),
                shape: BoxShape.circle,
                border: Border.all(color: color!, width: 2),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isActive ? Colors.green : Colors.grey[300],
              ),
          ],
        ),
        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isActive ? Colors.black : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}
