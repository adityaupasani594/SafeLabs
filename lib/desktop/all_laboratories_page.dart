import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- COLORS & STYLES ---
const Color _textColor = Color(0xFF333333);
const Color _subTextColor = Color(0xFF8A8A8E);
const Color _safeColor = Color(0xFF6FCF97);
const Color _alertColor = Color(0xFFEB5757);

// --- DATA MODEL ---
enum LabStatus { safe, overheating, offline, leak_detected }

class LabInfo {
  final String department;
  final String name;
  final LabStatus status;
  final String? temperature;
  final String? occupancy;
  final String? load;
  final String? airQuality;
  final String? lockStatus;
  final String? lastSeen;
  final String? maintenanceNote;
  final String imagePath;

  LabInfo({
    required this.department,
    required this.name,
    required this.status,
    required this.imagePath,
    this.temperature,
    this.occupancy,
    this.load,
    this.airQuality,
    this.lockStatus,
    this.lastSeen,
    this.maintenanceNote,
  });
}

// --- PAGE WIDGET ---
class AllLaboratoriesPage extends StatefulWidget {
  const AllLaboratoriesPage({super.key});

  @override
  _AllLaboratoriesPageState createState() => _AllLaboratoriesPageState();
}

class _AllLaboratoriesPageState extends State<AllLaboratoriesPage> {
  final _searchController = TextEditingController();
  String _selectedFilter = 'All';
  int _currentPage = 1;

  // Mock data - This can be replaced with a real data fetching implementation.
  final List<LabInfo> _labs = [
    LabInfo(department: 'CHEMISTRY DEPT', name: 'Chemistry Lab A', status: LabStatus.safe, imagePath: 'https://placehold.co/400x300/E0E0E0/000000?text=Lab+A', temperature: '22°C', occupancy: 'Occupied'),
    LabInfo(department: 'IT INFRA', name: 'Server Room B', status: LabStatus.overheating, imagePath: 'https://placehold.co/400x300/333333/FFFFFF?text=Server+Room', temperature: '35°C', load: 'High Usage'),
    LabInfo(department: 'BIOLOGY DEPT', name: 'Bio Lab 04', status: LabStatus.offline, imagePath: '', lastSeen: '4h ago', maintenanceNote: 'System disconnected unexpectedly.'),
    LabInfo(department: 'PHYSICS DEPT', name: 'Physics Lab C', status: LabStatus.safe, imagePath: 'https://placehold.co/400x300/BDBDBD/000000?text=Lab+C', temperature: '21°C', occupancy: 'Empty'),
    LabInfo(department: 'CHEMISTRY DEPT', name: 'Organic Lab 2', status: LabStatus.safe, imagePath: 'https://placehold.co/400x300/F5F5F5/000000?text=Lab+2', temperature: '23°C', occupancy: 'Occupied'),
    LabInfo(department: 'STORAGE', name: 'Chemical Vault', status: LabStatus.leak_detected, imagePath: 'https://placehold.co/400x300/757575/FFFFFF?text=Vault', airQuality: 'CRITICAL', lockStatus: 'Engaged'),
    LabInfo(department: 'ROBOTICS', name: 'Assembly Area 1', status: LabStatus.safe, imagePath: 'https://placehold.co/400x300/9E9E9E/FFFFFF?text=Robotics', temperature: '20°C', occupancy: 'Empty'),
    LabInfo(department: 'GENERAL SCI', name: 'Lab Annex 3', status: LabStatus.offline, imagePath: '', lastSeen: '2d ago', maintenanceNote: 'Maintenance scheduled.'),
  ];

  List<LabInfo> _filteredLabs = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_applyFiltersAndSearch);
    _filteredLabs = List.from(_labs);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFiltersAndSearch() {
    final searchText = _searchController.text.toLowerCase();
    setState(() {
      _filteredLabs = _labs.where((lab) {
        // Search filter
        final matchesSearch = searchText.isEmpty ||
            lab.name.toLowerCase().contains(searchText) ||
            lab.department.toLowerCase().contains(searchText);

        if (!matchesSearch) return false;

        // Chip filter
        switch (_selectedFilter) {
          case 'Alerts':
            return lab.status == LabStatus.overheating || lab.status == LabStatus.leak_detected;
          case 'Online':
            return lab.status == LabStatus.safe;
          case 'Offline':
            return lab.status == LabStatus.offline;
          case 'All':
          default:
            return true;
        }
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 30),
        _buildFilters(),
        const SizedBox(height: 30),
        _buildLabGrid(),
        const SizedBox(height: 30),
        _buildPagination(),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Text('All Laboratories', style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.bold, color: _textColor)),
        const SizedBox(width: 20),
        Text('${_labs.length} Total', style: GoogleFonts.inter(color: _subTextColor, fontSize: 16)),
        const SizedBox(width: 5),
        const Text('•', style: TextStyle(color: _alertColor)),
        const SizedBox(width: 5),
        Text('${_labs.where((l) => l.status != LabStatus.safe && l.status != LabStatus.offline).length} Alerts', style: GoogleFonts.inter(color: _alertColor, fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search by Lab ID or Dept...',
              prefixIcon: const Icon(Icons.search, color: _subTextColor),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            ),
          ),
        ),
        const SizedBox(width: 20),
        _buildFilterChip('All', false, false),
        _buildFilterChip('Alerts', true, false),
        _buildFilterChip('Online', false, true),
        _buildFilterChip('Offline', false, false),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isAlert, bool isOnline) {
    final bool isSelected = _selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) {
            setState(() => _selectedFilter = label);
            _applyFiltersAndSearch();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Filtering by: $label')));
          }
        },
        backgroundColor: Colors.white,
        selectedColor: isAlert ? _alertColor.withOpacity(0.1) : (isOnline ? _safeColor.withOpacity(0.1) : Colors.black),
        labelStyle: TextStyle(color: isSelected ? (isAlert ? _alertColor : (isOnline ? _safeColor : Colors.white)) : _textColor, fontWeight: FontWeight.bold),
        avatar: isAlert ? const Icon(Icons.error_outline, color: _alertColor, size: 16) : (isOnline ? const Icon(Icons.check_circle_outline, color: _safeColor, size: 16) : null),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget _buildLabGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _filteredLabs.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, childAspectRatio: 0.8, crossAxisSpacing: 20, mainAxisSpacing: 20),
      itemBuilder: (context, index) => _LabCard(lab: _filteredLabs[index]),
    );
  }

  Widget _buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildPageNumber(1, true),
        _buildPageNumber(2, false),
        _buildPageNumber(3, false),
        const SizedBox(width: 10),
        Text('...', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: _subTextColor)),
        const SizedBox(width: 10),
        InkWell(onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Navigating to next page...'))), child: Text('Next >', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: _textColor))),
      ],
    );
  }

  Widget _buildPageNumber(int page, bool isActive) {
    return InkWell(
      onTap: () {
        setState(() => _currentPage = page);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Navigating to page $page')));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.blue.shade600 : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(page.toString(), style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: isActive ? Colors.white : _textColor)),
      ),
    );
  }
}

// --- LAB CARD WIDGET ---
class _LabCard extends StatelessWidget {
  final LabInfo lab;
  const _LabCard({required this.lab});

  @override
  Widget build(BuildContext context) {
    final isAlert = lab.status == LabStatus.overheating || lab.status == LabStatus.leak_detected;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isAlert ? _alertColor : Colors.transparent, width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(lab.department, style: GoogleFonts.inter(color: _subTextColor, fontSize: 12, fontWeight: FontWeight.bold)),
              _buildStatusChip(),
            ],
          ),
          const SizedBox(height: 5),
          Text(lab.name, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: _textColor)),
          const SizedBox(height: 15),
          Expanded(child: _buildCardContent(context)),
          if (isAlert) ...[
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Managing alert for ${lab.name}'))),
              icon: const Icon(Icons.warning, size: 16),
              label: const Text('Manage Alert'),
              style: ElevatedButton.styleFrom(backgroundColor: _alertColor, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), minimumSize: const Size(double.infinity, 40)),
            ),
          ] else if (lab.status != LabStatus.offline) ...[
            const SizedBox(height: 15),
            InkWell(onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Viewing live feed for ${lab.name}'))), child: Text('View Live Feed →', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.blue.shade700)))
          ],
        ],
      ),
    );
  }

  Widget _buildStatusChip() {
    String text = 'SAFE';
    Color color = _safeColor;
    switch (lab.status) {
      case LabStatus.overheating:
        text = 'OVERHEATING';
        color = _alertColor;
        break;
      case LabStatus.offline:
        text = 'OFFLINE';
        color = _subTextColor;
        break;
      case LabStatus.leak_detected:
        text = 'LEAK DETECTED';
        color = _alertColor;
        break;
      default:
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: GoogleFonts.inter(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildCardContent(BuildContext context) {
    if (lab.status == LabStatus.offline) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.signal_wifi_off_outlined, color: _subTextColor, size: 50),
          const SizedBox(height: 10),
          Text(lab.maintenanceNote ?? '', textAlign: TextAlign.center, style: GoogleFonts.inter(color: _subTextColor)),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.history, size: 14, color: _subTextColor), const SizedBox(width: 5), Text('Last seen ${lab.lastSeen ?? 'N/A'}', style: GoogleFonts.inter(color: _subTextColor, fontSize: 12))]),
        ],
      );
    }

    return Column(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(lab.imagePath, fit: BoxFit.cover, width: double.infinity, errorBuilder: (context, error, stack) => const Icon(Icons.image_not_supported)),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (lab.temperature != null) _buildInfoItem(Icons.thermostat, 'TEMP', lab.temperature!),
            if (lab.occupancy != null) _buildInfoItem(Icons.person_outline, 'STATUS', lab.occupancy!),
            if (lab.load != null) _buildInfoItem(Icons.bolt, 'LOAD', lab.load!, isAlert: true),
            if (lab.airQuality != null) _buildInfoItem(Icons.air, 'AIR Q', lab.airQuality!, isAlert: true),
            if (lab.lockStatus != null) _buildInfoItem(Icons.lock_outline, 'LOCK', lab.lockStatus!, isAlert: lab.lockStatus != 'Engaged'),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value, {bool isAlert = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [Icon(icon, size: 14, color: isAlert ? _alertColor : _subTextColor), const SizedBox(width: 4), Text(label, style: GoogleFonts.inter(fontSize: 10, color: _subTextColor, fontWeight: FontWeight.bold))]),
        const SizedBox(height: 5),
        Text(value, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: isAlert ? _alertColor : _textColor)),
      ],
    );
  }
}
