
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color _textColor = Color(0xFF333333);
const Color _subTextColor = Color(0xFF8A8A8E);

class GeneralProfileScreen extends StatelessWidget {
  const GeneralProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 30),
          _buildProfileCard(context),
          const SizedBox(height: 30),
          _buildPersonalInfoCard(context),
          const SizedBox(height: 30),
          _buildRegionalPrefsCard(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('General Profile', style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.bold, color: _textColor)),
            const SizedBox(height: 5),
            Text('Manage your personal information and account preferences.', style: GoogleFonts.inter(color: _subTextColor, fontSize: 16)),
          ],
        ),
        ElevatedButton(
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Changes saved successfully!'))),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E3A59),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('Save Changes'),
        ),
      ],
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage('https://placehold.co/100x100/FFC107/000000?text=AS'),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Dr. Anya Sharma', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18, color: _textColor)),
              const SizedBox(height: 5),
              Text('Campus Dean - ID: #882190', style: GoogleFonts.inter(color: _subTextColor)),
            ],
          ),
          const Spacer(),
          TextButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Upload new photo...'))),
            child: const Text('Upload New Photo'),
          ),
          const SizedBox(width: 10),
          TextButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Photo removed.'))),
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Personal Information', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: _textColor)),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildTextField('Full Name', 'Anya Sharma')),
              const SizedBox(width: 20),
              Expanded(child: _buildTextField('University Email', 'dean.sharma@uni.edu')),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildTextField('Phone Number', '+1 (555) 019-2834')),
              const SizedBox(width: 20),
              Expanded(child: _buildTextField('Department', 'Science & Technology', isLocked: true)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String value, {bool isLocked = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: _subTextColor, fontSize: 12)),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: value,
          readOnly: isLocked,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            suffixIcon: isLocked ? const Icon(Icons.lock_outline, size: 16) : null,
          ),
        ),
      ],
    );
  }

  Widget _buildRegionalPrefsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Regional Preferences', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: _textColor)),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildDropdownField('Language', ['English (US)', 'English (UK)'], 'English (US)')),
              const SizedBox(width: 20),
              Expanded(child: _buildDropdownField('Timezone', ['(GMT-05:00) Eastern Time', '(GMT-08:00) Pacific Time'], '(GMT-05:00) Eastern Time')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(String label, List<String> items, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: _subTextColor, fontSize: 12)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: items.map((String item) => DropdownMenuItem<String>(value: item, child: Text(item))).toList(),
          onChanged: (_) {},
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}
