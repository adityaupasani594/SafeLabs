
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safe_labs/core/styles.dart';

// --- UI CONSTANTS ---
const Color offWhite = Color(0xFFF5F5F7);
const Color lavender = Color(0xFFE6E6FA);
const Color blackText = Color(0xFF1A1A1A);
const Color greyText = Color(0xFF8A8A8E);
const Color redBorder = Color(0xFFFF3B30);

class MobileProfileScreen extends StatefulWidget {
  const MobileProfileScreen({super.key});

  @override
  State<MobileProfileScreen> createState() => _MobileProfileScreenState();
}

class _MobileProfileScreenState extends State<MobileProfileScreen> {
  // --- Backend-Ready Data & Functions ---
  String userName = "Anya Sharma";
  String userRole = "Lab Assistant";
  String tierBadge = "Tier 2";
  String labName = "Quantum Innovations Lab";
  String buildingInfo = "Building C, Floor 3";

  void _handleLogout() { print("Logout requested..."); }
  void _handleExportReport() { print("Export Report requested..."); }
  void _handleViewLogs() { print("View Logs requested..."); }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      children: [
        const SizedBox(height: 20),
        _buildAppBar(),
        const SizedBox(height: 20),
        _buildUserCard(userName, userRole, tierBadge),
        const SizedBox(height: 24),
        _buildInfoSection(labName, buildingInfo),
        const SizedBox(height: 24),
        _buildActionList(),
        const SizedBox(height: 40),
        _buildLogoutButton(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildAppBar() {
    return Text(
      'Profile',
      textAlign: TextAlign.center,
      style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: blackText),
    );
  }

  // Structure: Container for Shadow -> ClipRRect -> BackdropFilter -> Container for Content
  Widget _buildUserCard(String name, String role, String badge) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        boxShadow: const [AppleShadows.card],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            color: Colors.white.withOpacity(0.85),
            child: Row(
              children: [
                const CircleAvatar(radius: 30, backgroundColor: lavender, child: Icon(Icons.person_outline, size: 30, color: blackText)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: blackText)),
                      const SizedBox(height: 4),
                      Text(role, style: GoogleFonts.inter(fontSize: 14, color: greyText, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                _buildTierBadge(badge),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTierBadge(String badge) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: lavender.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(badge, style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: blackText.withOpacity(0.8))),
    );
  }

  Widget _buildInfoSection(String lab, String floor) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32.0),
        boxShadow: const [AppleShadows.card],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            color: Colors.white.withOpacity(0.85),
            child: Column(
              children: [
                _buildInfoRow(Icons.business, "Lab Name", lab),
                const Divider(indent: 20, endIndent: 20, height: 1),
                _buildInfoRow(Icons.layers, "Floor", floor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Icon(icon, color: greyText, size: 28),
          const SizedBox(width: 22),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.inter(fontSize: 12, color: greyText, fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(subtitle, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: blackText)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionList() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32.0),
        boxShadow: const [AppleShadows.card],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            color: Colors.white.withOpacity(0.85),
            child: Column(
              children: [
                _buildListTile("Export Energy Report (PDF)", Icons.description, _handleExportReport),
                const Divider(indent: 20, endIndent: 20, height: 1),
                _buildListTile("View System Audit Logs", Icons.history, _handleViewLogs),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListTile(String title, IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Icon(icon, color: blackText),
              const SizedBox(width: 16),
              Expanded(child: Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: blackText))),
              const Icon(Icons.arrow_forward_ios, size: 16, color: greyText),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        boxShadow: const [AppleShadows.button], // Using button shadow
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              border: Border.all(color: redBorder.withOpacity(0.5), width: 1.5),
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _handleLogout,
                borderRadius: BorderRadius.circular(50.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Center(
                    child: Text('Log Out', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: redBorder)),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
