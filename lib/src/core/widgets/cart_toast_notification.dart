import 'dart:async';
import 'package:flutter/material.dart';
import '../../features/cart/cart_screen.dart';

class CartToastNotification {
  static OverlayEntry? _overlayEntry;
  static Timer? _dismissTimer;
  static ValueNotifier<String>? _messageNotifier;

  static void show(BuildContext context, {required String message}) {
    // If a toast is already visible, update the message and reset the 5-second timer
    if (_overlayEntry != null && _messageNotifier != null) {
      _messageNotifier!.value = message;
      _resetTimer();
      return;
    }

    _messageNotifier = ValueNotifier<String>(message);

    final overlay = Overlay.of(context, rootOverlay: true);

    _overlayEntry = OverlayEntry(
      builder: (ctx) {
        return Positioned(
          top: MediaQuery.of(ctx).padding.top + 12,
          left: 16,
          right: 16,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Material(
                color: Colors.transparent,
                child: ValueListenableBuilder<String>(
                  valueListenable: _messageNotifier!,
                  builder: (context, msg, _) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1F1F1F),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFFC900), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(140),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Cart Icon
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFC900).withAlpha(30),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.shopping_cart_outlined,
                              color: Color(0xFFFFC900),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Notification Message
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Added to Cart',
                                  style: TextStyle(
                                    color: Color(0xFFFFC900),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  msg,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),

                          // VIEW CART Action Button
                          InkWell(
                            borderRadius: BorderRadius.circular(6),
                            onTap: () {
                              dismiss();
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const CartScreen()),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFC900),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'VIEW CART',
                                style: TextStyle(
                                  color: Color(0xFF1A1A1A),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(_overlayEntry!);
    _resetTimer();
  }

  static void _resetTimer() {
    _dismissTimer?.cancel();
    _dismissTimer = Timer(const Duration(seconds: 5), () {
      dismiss();
    });
  }

  static void dismiss() {
    _dismissTimer?.cancel();
    _dismissTimer = null;

    _overlayEntry?.remove();
    _overlayEntry = null;

    _messageNotifier?.dispose();
    _messageNotifier = null;
  }
}
