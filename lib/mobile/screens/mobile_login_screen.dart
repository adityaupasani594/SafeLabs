
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safe_labs/mobile/screens/mobile_main_screen.dart'; // Updated import

// Hex color codes from the design
const Color offWhite = Color(0xFFF5F5F7);
const Color lavenderAccent = Color(0xFFE6E6FA);
const Color blackButton = Color(0xFF1A1A1A);
const Color greyText = Color(0xFF8A8A8E);

class MobileLoginScreen extends StatefulWidget {
  const MobileLoginScreen({super.key});

  @override
  State<MobileLoginScreen> createState() => _MobileLoginScreenState();
}

class _MobileLoginScreenState extends State<MobileLoginScreen> {
  bool isRegistering = true;
  String selectedRole = 'Lab Admin';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: offWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 50),
              _buildHeader(),
              const SizedBox(height: 40),
              _buildAuthToggle(),
              const SizedBox(height: 30),
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                firstChild: _buildSignInForm(),
                secondChild: _buildRegisterForm(),
                crossFadeState: isRegistering
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
              ),
              const SizedBox(height: 20),
              _buildActionButton(),
              const SizedBox(height: 24),
              _buildFooter(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    return ElevatedButton(
      onPressed: () {
        // Navigate to the new main screen with persistent navigation
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MobileMainScreen()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: blackButton,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isRegistering ? 'Create Account' : 'Sign In',
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          if (isRegistering) const Icon(Icons.arrow_forward, size: 20),
        ],
      ),
    );
  }

  // ... (All other _build methods remain the same) ...

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: lavenderAccent,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.shield_outlined, size: 40, color: blackButton),
        ),
        const SizedBox(height: 20),
        Text(
          'SafeLabs',
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: blackButton,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Secure Campus IoT Monitor',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: greyText,
          ),
        ),
      ],
    );
  }

  Widget _buildAuthToggle() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            alignment: isRegistering ? Alignment.centerRight : Alignment.centerLeft,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeIn,
            child: Container(
              width: MediaQuery.of(context).size.width / 2 - 24,
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: blackButton,
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => isRegistering = false),
                  child: Center(
                    child: Text(
                      'Sign In',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        color: isRegistering ? blackButton : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => isRegistering = true),
                  child: Center(
                    child: Text(
                      'Register',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        color: isRegistering ? Colors.white : blackButton,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildSignInForm() {
    return Column(
      children: [
        _buildTextField(icon: Icons.email_outlined, hint: 'University Email'),
        const SizedBox(height: 16),
        _buildTextField(icon: Icons.lock_outline, hint: 'Password', obscureText: true),
      ],
    );
  }
  
  Widget _buildRegisterForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(icon: Icons.person_outline, hint: 'Full Name'),
        const SizedBox(height: 16),
        _buildTextField(icon: Icons.email_outlined, hint: 'University Email'),
        const SizedBox(height: 16),
        _buildTextField(icon: Icons.lock_outline, hint: 'Password', obscureText: true),
        const SizedBox(height: 24),
        Text(
          'Select Your Role:',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: blackButton,
          ),
        ),
        const SizedBox(height: 12),
        _buildRoleSelector(),
      ],
    );
  }

  Widget _buildTextField({required IconData icon, required String hint, bool obscureText = false}) {
    return TextFormField(
      obscureText: obscureText,
      style: GoogleFonts.inter(fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        hintStyle: GoogleFonts.inter(color: greyText.withOpacity(0.8)),
        prefixIcon: Icon(icon, color: greyText),
        suffixIcon: obscureText
            ? const Icon(Icons.visibility_outlined, color: greyText)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      ),
    );
  }

  Widget _buildRoleSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildChoiceChip('Lab Admin'),
        const SizedBox(width: 12),
        _buildChoiceChip('Campus Dean'),
      ],
    );
  }

  Widget _buildChoiceChip(String role) {
    final isSelected = selectedRole == role;
    return ChoiceChip(
      label: Text(role),
      selected: isSelected,
      onSelected: (bool selected) {
        if (selected) {
          setState(() {
            selectedRole = role;
          });
        }
      },
      labelStyle: GoogleFonts.inter(
        fontWeight: FontWeight.w600,
        color: isSelected ? blackButton : greyText,
      ),
      backgroundColor: Colors.white,
      selectedColor: lavenderAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
        side: BorderSide(
          color: isSelected ? lavenderAccent : Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
    );
  }

  Widget _buildFooter() {
    return Center(
      child: Text.rich(
        TextSpan(
          text: 'Forgot Password? ',
          style: GoogleFonts.inter(color: greyText, fontWeight: FontWeight.w500),
          children: [
            TextSpan(
              text: 'Get Help',
              style: GoogleFonts.inter(
                color: blackButton,
                fontWeight: FontWeight.bold,
              ),
              // Add onTap handler later
            ),
          ],
        ),
      ),
    );
  }
}
