
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safe_labs/core/styles.dart';

// --- DATA MODEL ---
class LabData {
  final String labName;
  final String labStatus;
  final int temperature;
  final String gasLevelValue;
  final String ambientLightValue;
  final String motionValue;
  final String doorLockValue;
  bool isACMasterOn;

  LabData({
    required this.labName,
    required this.labStatus,
    required this.temperature,
    required this.gasLevelValue,
    required this.ambientLightValue,
    required this.motionValue,
    required this.doorLockValue,
    required this.isACMasterOn,
  });
}

// --- UI CONSTANTS ---
const Color offWhite = Color(0xFFF5F5F7);
const Color lavender = Color(0xFFE6E6FA);
const Color lightBlue = Color(0xFFADD8E6);
const Color cyanMint = Color(0xFFE0F7FA);
const Color softPink = Color(0xFFFADADD);
const Color softGreen = Color(0xFFD4F1F4);
const Color blackText = Color(0xFF1A1A1A);
const Color greyText = Color(0xFF8A8A8E);

class MobileDashboardScreen extends StatefulWidget {
  const MobileDashboardScreen({super.key});

  @override
  State<MobileDashboardScreen> createState() => _MobileDashboardScreenState();
}

class _MobileDashboardScreenState extends State<MobileDashboardScreen> {
  LabData? _labData;

  @override
  void initState() {
    super.initState();
    _fetchLabData();
  }

  void _fetchLabData() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() {
        _labData = LabData(
          labName: "Lab 01",
          labStatus: "Status: Online & Secure",
          temperature: 24,
          isACMasterOn: true,
          gasLevelValue: "Normal (12ppm)",
          ambientLightValue: "85% (On)",
          motionValue: "None",
          doorLockValue: "Engaged",
        );
      });
    });
  }

  void _updateACState(bool newState) {
    if (!mounted) return;
    setState(() {
      _labData?.isACMasterOn = newState;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_labData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      children: [
        const SizedBox(height: 20),
        _buildHeader(_labData!.labName, _labData!.labStatus),
        const SizedBox(height: 30),
        _buildHeroSection(_labData!.temperature, _labData!.isACMasterOn),
        const SizedBox(height: 20),
        _buildSensorGrid(
          _labData!.gasLevelValue,
          _labData!.ambientLightValue,
          _labData!.motionValue,
          _labData!.doorLockValue,
        ),
      ],
    );
  }

  Widget _buildHeader(String name, String status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.bold, color: blackText), overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Text(status, style: GoogleFonts.inter(fontSize: 16, color: greyText, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            boxShadow: const [AppleShadows.button],
          ),
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, size: 16),
            label: const Text("Add Sensor"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: blackText,
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroSection(int temp, bool isAcOn) {
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
            padding: const EdgeInsets.all(24.0),
            color: lavender.withOpacity(0.8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(temp.toString(), style: GoogleFonts.inter(fontSize: 60, fontWeight: FontWeight.bold, color: blackText, height: 1)),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text("°C", style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: blackText)),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("AC MASTER POWER", style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: blackText.withOpacity(0.7))),
                    const SizedBox(height: 4),
                    Text(isAcOn ? "On" : "Off", style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: blackText)),
                    const SizedBox(height: 8),
                    Switch(value: isAcOn, onChanged: _updateACState, activeColor: Colors.greenAccent.shade400, activeTrackColor: Colors.green.shade100),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSensorGrid(String gas, String light, String motion, String door) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildSensorCard(icon: Icons.gas_meter_outlined, title: "Gas Level", value: gas, color: lightBlue),
        _buildSensorCard(icon: Icons.lightbulb_outline, title: "Ambient Light", value: light, color: cyanMint),
        _buildSensorCard(icon: Icons.directions_run, title: "Motion", value: motion, color: softPink),
        _buildSensorCard(icon: Icons.lock_outline, title: "Door Lock", value: door, color: softGreen),
      ],
    );
  }

  Widget _buildSensorCard({required IconData icon, required String title, required String value, required Color color}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: const [AppleShadows.card],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            color: color.withOpacity(0.85),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, size: 32, color: blackText),
                const Spacer(),
                Text(title, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: blackText)),
                const SizedBox(height: 4),
                Text(value, style: GoogleFonts.inter(fontSize: 14, color: greyText, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
