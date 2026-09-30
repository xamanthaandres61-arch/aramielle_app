import 'package:flutter/material.dart';

class AramielleLogoHeader extends StatelessWidget {
  final double height;
  final bool showSubtitle;

  const AramielleLogoHeader({
    super.key,
    this.height = 70.0,
    this.showSubtitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/aramielle_logo.png',
          height: height,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) {
            // Fallback gracefully if asset is loading or missing
            return Container(
              height: height,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFC900).withAlpha(30),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFFFC900), width: 2),
              ),
              child: const Icon(
                Icons.restaurant_menu,
                size: 40,
                color: Color(0xFFFFC900),
              ),
            );
          },
        ),
        if (showSubtitle) ...[
          const SizedBox(height: 6),
          const Text(
            'Aramielle Restaurant',
            style: TextStyle(
              color: Color(0xFFFFC900),
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Italian • Chinese • Filipino Cuisine',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ],
    );
  }
}
