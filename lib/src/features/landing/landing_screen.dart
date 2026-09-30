import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/widgets/aramielle_logo_header.dart';
import '../auth/compact_auth_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. FULL-SCREEN FOOD COLLAGE BACKGROUND
          Image.asset(
            'assets/images/food_collage.jpg',
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Image.asset(
              'Externalasset/background for landingpage.jpg',
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                color: const Color(0xFF1A1A1A),
              ),
            ),
          ),

          // 2. HEAVY BLUR (SIGMA 10) & SEMI-TRANSPARENT DARK OVERLAY
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.black.withAlpha(165),
              ),
            ),
          ),

          // 3. CENTERED FOREGROUND CONTENT (SHARP & ELEGANT)
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // [ARAMIELLE RESTAURANT LOGO]
                      const AramielleLogoHeader(
                        height: 110,
                        showSubtitle: false,
                      ),
                      const SizedBox(height: 16),

                      // ARAMIELLE RESTAURANT (Large, Elegant Gold Title)
                      const Text(
                        'ARAMIELLE RESTAURANT',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFFFC900),
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          shadows: [
                            Shadow(color: Colors.black, blurRadius: 10, offset: Offset(0, 2)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Italian • Chinese • Filipino Cuisine (Clean, Light Subtitle)
                      const Text(
                        'Italian • Chinese • Filipino Cuisine',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.8,
                          shadows: [
                            Shadow(color: Colors.black, blurRadius: 8, offset: Offset(0, 1)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      // INFORMATION CARD (Charcoal/black transparent card with thin gold border & subtle shadow)
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E1E).withAlpha(220),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFFFC900).withAlpha(200), width: 1.2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(130),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Column(
                          children: [
                            Text(
                              '"A Taste of Italy, China, and the Philippines in One Place"',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFFFFEB87),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                height: 1.4,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Discover authentic flavors, digital table ordering, and instant table service.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // GET STARTED BUTTON ("GET STARTED  →")
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFC900),
                            foregroundColor: const Color(0xFF1A1A1A),
                            elevation: 6,
                            shadowColor: Colors.black54,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const CompactAuthScreen()),
                            );
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'GET STARTED',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward_rounded, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
