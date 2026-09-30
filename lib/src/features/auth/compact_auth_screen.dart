import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/app_state_provider.dart';
import '../../core/widgets/aramielle_logo_header.dart';
import '../navigation/main_navigation_screen.dart';

// --- COLOR PALETTE (60-30-10 Rule) ---
const Color kBgDark = Color(0xFF1A1A1A); // 60% Dominant Dark Background
const Color kCardBg = Color(0xFF1A1A1A); // Card Surface
const Color kTextYellow = Color(0xFFFFEB87); // 30% Secondary Soft Yellow Text
const Color kAccentYellow = Color(0xFFFFC900); // 10% Accent Yellow Highlight

class CompactAuthScreen extends StatefulWidget {
  const CompactAuthScreen({super.key});

  @override
  State<CompactAuthScreen> createState() => _CompactAuthScreenState();
}

class _CompactAuthScreenState extends State<CompactAuthScreen> {
  // Tab Mode: false = Sign In, true = Register
  bool _isRegister = false;

  // Form Keys
  final _signinFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();

  // Sign In Controllers
  final _signinAccountController = TextEditingController(text: 'xamantha@example.com');
  final _signinPasswordController = TextEditingController(text: 'Password123!');

  // Register Controllers
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _registerPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Obscure States for Password Toggles
  bool _obscureSigninPassword = true;
  bool _obscureRegisterPassword = true;
  bool _obscureConfirmPassword = true;

  // Regex Patterns
  final RegExp _emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  final RegExp _passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');

  Future<void> _handleSigninSubmit() async {
    if (_signinFormKey.currentState?.validate() ?? false) {
      final account = _signinAccountController.text.trim();
      final name = account.contains('@') ? account.split('@')[0] : account;
      final email = account.contains('@') ? account : '$account@aramielle.com';

      final appState = Provider.of<AppStateProvider>(context, listen: false);
      await appState.saveUserSession(name: name, email: email);

      if (mounted) {
        // Instantly transition to Customer Home without requiring page refresh!
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
          (route) => false,
        );
      }
    }
  }

  Future<void> _handleRegisterSubmit() async {
    if (_registerFormKey.currentState?.validate() ?? false) {
      final name = _fullNameController.text.trim();
      final email = _emailController.text.trim();

      final appState = Provider.of<AppStateProvider>(context, listen: false);
      await appState.saveUserSession(
        name: name.isNotEmpty ? name : email.split('@')[0],
        email: email,
      );

      if (mounted) {
        // Instantly transition to Customer Home without requiring page refresh!
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
          (route) => false,
        );
      }
    }
  }

  @override
  void dispose() {
    _signinAccountController.dispose();
    _signinPasswordController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _registerPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgDark,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 380),
              child: Container(
                decoration: BoxDecoration(
                  color: kCardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: kAccentYellow, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(120),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24.0),
                child: _buildAuthCardContent(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAuthCardContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. OFFICIAL BRANDING HEADER WITH LOGO
        const AramielleLogoHeader(height: 70),
        const SizedBox(height: 20),

        // 2. TAB SWITCHER TOGGLE BAR
        Container(
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFF111318),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: kAccentYellow.withAlpha(80)),
          ),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: () {
                    setState(() {
                      _isRegister = false;
                      _signinFormKey.currentState?.reset();
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: !_isRegister ? kAccentYellow : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        color: !_isRegister ? kBgDark : kTextYellow,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: () {
                    setState(() {
                      _isRegister = true;
                      _registerFormKey.currentState?.reset();
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: _isRegister ? kAccentYellow : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Register',
                      style: TextStyle(
                        color: _isRegister ? kBgDark : kTextYellow,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // 3. FORM BODY (SIGN IN OR REGISTER)
        _isRegister ? _buildRegisterForm() : _buildSigninForm(),
      ],
    );
  }

  // --- SIGN IN FORM ---
  Widget _buildSigninForm() {
    return Form(
      key: _signinFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Username or Email
          TextFormField(
            controller: _signinAccountController,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: _buildInputDecoration(
              label: 'Username or Email',
              icon: Icons.person_outline,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your username or email';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),

          // Password
          TextFormField(
            controller: _signinPasswordController,
            obscureText: _obscureSigninPassword,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: _buildInputDecoration(
              label: 'Password',
              icon: Icons.lock_outline,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureSigninPassword ? Icons.visibility_off : Icons.visibility,
                  color: kAccentYellow,
                  size: 20,
                ),
                onPressed: () {
                  setState(() => _obscureSigninPassword = !_obscureSigninPassword);
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter password';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Sign In Submit Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kAccentYellow,
                foregroundColor: kBgDark,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: _handleSigninSubmit,
              child: const Text('Sign In', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }

  // --- REGISTER FORM ---
  Widget _buildRegisterForm() {
    return Form(
      key: _registerFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Full Name
          TextFormField(
            controller: _fullNameController,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: _buildInputDecoration(
              label: 'Full Name',
              icon: Icons.badge_outlined,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your full name';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),

          // 2. Email Address
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: _buildInputDecoration(
              label: 'Email Address',
              icon: Icons.email_outlined,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Email address is required';
              }
              if (!_emailRegex.hasMatch(value.trim())) {
                return 'Enter a valid email address (e.g. user@domain.com)';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),

          // 3. Username
          TextFormField(
            controller: _usernameController,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: _buildInputDecoration(
              label: 'Username',
              icon: Icons.alternate_email,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Username is required';
              }
              if (value.trim().length < 3) {
                return 'Username must be at least 3 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),

          // 4. Password
          TextFormField(
            controller: _registerPasswordController,
            obscureText: _obscureRegisterPassword,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: _buildInputDecoration(
              label: 'Password',
              icon: Icons.lock_outline,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureRegisterPassword ? Icons.visibility_off : Icons.visibility,
                  color: kAccentYellow,
                  size: 20,
                ),
                onPressed: () {
                  setState(() => _obscureRegisterPassword = !_obscureRegisterPassword);
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              }
              if (!_passwordRegex.hasMatch(value)) {
                return 'Min 8 chars, 1 upper, 1 lower, 1 digit, 1 special (@\$!%*?&)';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),

          // 5. Confirm Password
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: _buildInputDecoration(
              label: 'Confirm Password',
              icon: Icons.lock_clock_outlined,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                  color: kAccentYellow,
                  size: 20,
                ),
                onPressed: () {
                  setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != _registerPasswordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kAccentYellow,
                foregroundColor: kBgDark,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: _handleRegisterSubmit,
              child: const Text('Complete Registration', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String label,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: kTextYellow, fontSize: 12),
      prefixIcon: Icon(icon, color: kAccentYellow, size: 18),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: const Color(0xFF111318),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: kAccentYellow),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: kAccentYellow.withAlpha(100)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: kAccentYellow, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
      errorMaxLines: 2,
      errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 10),
    );
  }
}
