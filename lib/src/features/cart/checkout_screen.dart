import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/app_state_provider.dart';
import '../../core/widgets/shiny_gold_button.dart';
import '../orders/order_tracking_screen.dart';
import '../pager/table_pager_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _isUploadingReceipt = false;
  bool _isUploadingId = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = Provider.of<AppStateProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout & Payment'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Order Type Selector Card (Dine-In vs Take-Out)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Type & Table Assignment',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('Dine-In', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            subtitle: Text(
                              appState.hasSelectedTable ? (appState.selectedTableNumber ?? 'No Table') : 'Table Required',
                              style: TextStyle(
                                fontSize: 11,
                                color: appState.hasSelectedTable ? theme.colorScheme.primary : Colors.red,
                              ),
                            ),
                            value: 'Dine-in',
                            groupValue: appState.orderType,
                            onChanged: (val) => appState.setOrderType(val!),
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('Take-Out', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            subtitle: const Text('Table N/A', style: TextStyle(fontSize: 11, color: Colors.grey)),
                            value: 'Take-out',
                            groupValue: appState.orderType,
                            onChanged: (val) => appState.setOrderType(val!),
                          ),
                        ),
                      ],
                    ),

                    if (appState.orderType == 'Dine-in') ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                appState.hasSelectedTable ? Icons.check_circle : Icons.warning_amber_rounded,
                                color: appState.hasSelectedTable ? Colors.green : Colors.red,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                appState.hasSelectedTable
                                    ? 'Assigned: ${appState.selectedTableNumber}'
                                    : 'No Table Selected for Dine-In!',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: appState.hasSelectedTable ? Colors.green : Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          TextButton.icon(
                            icon: const Icon(Icons.table_restaurant, size: 16),
                            label: Text(appState.hasSelectedTable ? 'Change Table' : 'Select Table'),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const TablePagerScreen()),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Order Summary Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order Items Summary',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withAlpha(30),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            appState.orderType == 'Dine-in'
                                ? 'Dine-in (${appState.selectedTableNumber ?? "No Table"})'
                                : 'Take-out (Table N/A)',
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),

                    ...appState.cart.map((cartItem) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${cartItem.quantity}x ${cartItem.item.name}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              '₱${cartItem.totalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Statutory Discount Card (Senior Citizen / PWD 20% Discount)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.card_membership, color: theme.colorScheme.primary),
                        const SizedBox(width: 8),
                        const Text(
                          'Senior Citizen / PWD Discount',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Select discount type and upload valid ID for verification by cashier.',
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.secondary.withAlpha(180)),
                    ),
                    const SizedBox(height: 12),

                    Column(
                      children: [
                        RadioListTile<String>(
                          title: const Text('Regular (No Discount)'),
                          value: 'None',
                          groupValue: appState.discountType,
                          onChanged: (val) => appState.setDiscountType(val!),
                        ),
                        RadioListTile<String>(
                          title: const Text('Senior Citizen (20% Discount)'),
                          value: 'Senior Citizen',
                          groupValue: appState.discountType,
                          onChanged: (val) => appState.setDiscountType(val!),
                        ),
                        RadioListTile<String>(
                          title: const Text('PWD (20% Discount)'),
                          value: 'PWD',
                          groupValue: appState.discountType,
                          onChanged: (val) => appState.setDiscountType(val!),
                        ),
                      ],
                    ),

                    if (appState.discountType != 'None') ...[
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        icon: _isUploadingId
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Icon(
                                appState.seniorPwdIdPath != null
                                    ? Icons.check_circle
                                    : Icons.upload_file,
                                color: appState.seniorPwdIdPath != null ? Colors.green : null,
                              ),
                        label: Text(
                          appState.seniorPwdIdPath != null
                              ? 'Senior/PWD ID Uploaded ✓'
                              : 'Upload Senior/PWD ID Screenshot',
                        ),
                        onPressed: () async {
                          setState(() => _isUploadingId = true);
                          await Future.delayed(const Duration(seconds: 1));
                          setState(() => _isUploadingId = false);
                          appState.setSeniorPwdIdPath('simulated_id_path.jpg');

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Senior/PWD ID uploaded successfully!')),
                            );
                          }
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // GCash / QR Code Payment Upload Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.qr_code_2, color: theme.colorScheme.primary),
                        const SizedBox(width: 8),
                        const Text(
                          'GCash / QR Payment',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Scan the Aramielle GCash QR code below and upload your payment receipt screenshot.',
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.secondary.withAlpha(180)),
                    ),
                    const SizedBox(height: 16),

                    // GCash QR Code Display
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withAlpha(20),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: theme.colorScheme.primary),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.qr_code, size: 140, color: theme.colorScheme.primary),
                            const SizedBox(height: 6),
                            Text(
                              'Aramielle Restaurant GCash',
                              style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                            ),
                            Text(
                              'Account: 0917-123-4567',
                              style: TextStyle(fontSize: 12, color: theme.colorScheme.secondary),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    OutlinedButton.icon(
                      icon: _isUploadingReceipt
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(
                              appState.paymentReceiptPath != null
                                  ? Icons.check_circle
                                  : Icons.file_upload,
                              color: appState.paymentReceiptPath != null ? Colors.green : null,
                            ),
                      label: Text(
                        appState.paymentReceiptPath != null
                            ? 'GCash Receipt Uploaded ✓'
                            : 'Upload GCash Payment Receipt',
                      ),
                      onPressed: () async {
                        setState(() => _isUploadingReceipt = true);
                        await Future.delayed(const Duration(seconds: 1));
                        setState(() => _isUploadingReceipt = false);
                        appState.setPaymentReceiptPath('simulated_receipt_path.jpg');

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Payment receipt attached!')),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Final Bill Summary Calculation Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Subtotal:', style: TextStyle(color: theme.colorScheme.secondary)),
                        Text(
                          '₱${appState.cartSubtotal.toStringAsFixed(2)}',
                          style: TextStyle(color: theme.colorScheme.secondary, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    if (appState.cartDiscountAmount > 0) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${appState.discountType} Discount (20%):',
                            style: const TextStyle(color: Colors.greenAccent),
                          ),
                          Text(
                            '-₱${appState.cartDiscountAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.greenAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'TOTAL PAYABLE:',
                          style: TextStyle(
                            color: theme.colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          '₱${appState.cartFinalTotal.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Shiny Gold Place Order Button
            ShinyGoldButton(
              label: 'Place Order & Send to Kitchen',
              icon: Icons.soup_kitchen,
              onPressed: () {
                // Table Guard for Dine-In Orders
                if (appState.orderType == 'Dine-in' && !appState.hasSelectedTable) {
                  _showTableRequiredDialog(context);
                  return;
                }

                final order = appState.submitOrder();

                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => OrderTrackingScreen(orderId: order.id),
                  ),
                  (route) => route.isFirst,
                );
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void _showTableRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red),
              SizedBox(width: 8),
              Text('Table Required'),
            ],
          ),
          content: const Text(
            'Please select an available table before placing a dine-in order.',
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('CANCEL'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFC900),
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const TablePagerScreen()),
                );
              },
              child: const Text('SELECT TABLE'),
            ),
          ],
        );
      },
    );
  }
}
