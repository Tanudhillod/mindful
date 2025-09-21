import 'package:flutter/material.dart';
import '../theme.dart';

class ProfessionalDirectoryScreen extends StatefulWidget {
  const ProfessionalDirectoryScreen({super.key});

  @override
  State<ProfessionalDirectoryScreen> createState() => _ProfessionalDirectoryScreenState();
}

class _ProfessionalDirectoryScreenState extends State<ProfessionalDirectoryScreen> {
  String searchQuery = '';
  String selectedSpecialty = 'All';
  String selectedLanguage = 'All';
  String selectedLocation = 'All';
  
  final List<String> specialties = [
    'All',
    'Clinical Psychology',
    'Counseling Psychology',
    'Psychiatry',
    'Child Psychology',
    'Marriage & Family Therapy',
    'Addiction Counseling',
    'Trauma Therapy',
  ];

  final List<String> languages = [
    'All',
    'English',
    'Hindi',
    'Marathi',
    'Bengali',
    'Tamil',
    'Telugu',
    'Gujarati',
    'Kannada',
    'Malayalam',
    'Punjabi',
  ];

  final List<String> locations = [
    'All',
    'Mumbai',
    'Delhi',
    'Bangalore',
    'Chennai',
    'Kolkata',
    'Hyderabad',
    'Pune',
    'Online Only',
  ];

  final List<Map<String, dynamic>> professionals = [
    {
      'name': 'Dr. Priya Sharma',
      'specialty': 'Clinical Psychology',
      'qualification': 'PhD Clinical Psychology, M.Phil',
      'experience': '12 years',
      'rating': 4.8,
      'languages': ['English', 'Hindi', 'Marathi'],
      'location': 'Mumbai',
      'consultationFee': '₹1,500',
      'availability': 'Available',
      'verified': true,
      'profileImage': null,
      'specializations': ['Anxiety', 'Depression', 'Stress Management'],
    },
    {
      'name': 'Dr. Rahul Mehta',
      'specialty': 'Psychiatry',
      'qualification': 'MBBS, MD Psychiatry',
      'experience': '15 years',
      'rating': 4.9,
      'languages': ['English', 'Hindi', 'Gujarati'],
      'location': 'Delhi',
      'consultationFee': '₹2,000',
      'availability': 'Available',
      'verified': true,
      'profileImage': null,
      'specializations': ['Bipolar Disorder', 'Anxiety', 'ADHD'],
    },
    {
      'name': 'Dr. Ananya Iyer',
      'specialty': 'Child Psychology',
      'qualification': 'PhD Child Psychology, M.A Psychology',
      'experience': '8 years',
      'rating': 4.7,
      'languages': ['English', 'Tamil', 'Hindi'],
      'location': 'Chennai',
      'consultationFee': '₹1,200',
      'availability': 'Busy until next week',
      'verified': true,
      'profileImage': null,
      'specializations': ['Child Development', 'Learning Disabilities', 'Autism'],
    },
    {
      'name': 'Ms. Kavya Reddy',
      'specialty': 'Counseling Psychology',
      'qualification': 'M.Phil Clinical Psychology, M.A Psychology',
      'experience': '6 years',
      'rating': 4.6,
      'languages': ['English', 'Telugu', 'Hindi'],
      'location': 'Hyderabad',
      'consultationFee': '₹1,000',
      'availability': 'Available',
      'verified': true,
      'profileImage': null,
      'specializations': ['Relationship Issues', 'Career Counseling', 'Self-esteem'],
    },
    {
      'name': 'Dr. Arjun Singh',
      'specialty': 'Addiction Counseling',
      'qualification': 'PhD Psychology, Certified Addiction Counselor',
      'experience': '10 years',
      'rating': 4.5,
      'languages': ['English', 'Hindi', 'Punjabi'],
      'location': 'Online Only',
      'consultationFee': '₹1,300',
      'availability': 'Available',
      'verified': true,
      'profileImage': null,
      'specializations': ['Substance Abuse', 'Behavioral Addictions', 'Recovery Support'],
    },
  ];

  List<Map<String, dynamic>> get filteredProfessionals {
    return professionals.where((professional) {
      final matchesSearch = searchQuery.isEmpty ||
          professional['name'].toLowerCase().contains(searchQuery.toLowerCase()) ||
          professional['specialty'].toLowerCase().contains(searchQuery.toLowerCase()) ||
          professional['specializations'].any((spec) => 
              spec.toLowerCase().contains(searchQuery.toLowerCase()));
      
      final matchesSpecialty = selectedSpecialty == 'All' ||
          professional['specialty'] == selectedSpecialty;
      
      final matchesLanguage = selectedLanguage == 'All' ||
          professional['languages'].contains(selectedLanguage);
      
      final matchesLocation = selectedLocation == 'All' ||
          professional['location'] == selectedLocation;
      
      return matchesSearch && matchesSpecialty && matchesLanguage && matchesLocation;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mental Health Professionals'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryBlue.withOpacity(0.1),
                  AppColors.primaryGreen.withOpacity(0.1),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Find Professional Support',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Connect with verified mental health professionals in your area',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textMedium,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Search bar
                TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search by name, specialty, or condition...',
                    prefixIcon: Icon(Icons.search, color: AppColors.textMedium),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Quick filters
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildQuickFilter('Specialty', selectedSpecialty),
                      const SizedBox(width: 8),
                      _buildQuickFilter('Language', selectedLanguage),
                      const SizedBox(width: 8),
                      _buildQuickFilter('Location', selectedLocation),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Results count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  '${filteredProfessionals.length} professionals found',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textMedium,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _showFilterDialog,
                  child: const Text('Advanced Filters'),
                ),
              ],
            ),
          ),
          
          // Professionals list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredProfessionals.length,
              itemBuilder: (context, index) {
                final professional = filteredProfessionals[index];
                return _buildProfessionalCard(professional);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickFilter(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: value != 'All' ? AppColors.primaryBlue.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: value != 'All' ? AppColors.primaryBlue : Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: $value',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: value != 'All' ? AppColors.primaryBlue : AppColors.textMedium,
              fontWeight: value != 'All' ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          if (value != 'All') ...[
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () {
                setState(() {
                  if (label == 'Specialty') selectedSpecialty = 'All';
                  if (label == 'Language') selectedLanguage = 'All';
                  if (label == 'Location') selectedLocation = 'All';
                });
              },
              child: Icon(
                Icons.close,
                size: 16,
                color: AppColors.primaryBlue,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProfessionalCard(Map<String, dynamic> professional) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with photo and basic info
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
                child: Text(
                  professional['name'].split(' ').map((name) => name[0]).join(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          professional['name'],
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.textDark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (professional['verified']) ...[
                          const SizedBox(width: 4),
                          Icon(
                            Icons.verified,
                            size: 16,
                            color: AppColors.successSoft,
                          ),
                        ],
                      ],
                    ),
                    Text(
                      professional['specialty'],
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${professional['experience']} experience',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textMedium,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 16,
                        color: AppColors.warningAmber,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        professional['rating'].toString(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    professional['consultationFee'],
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Qualification and specializations
          Text(
            professional['qualification'],
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textMedium,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Specializations
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: professional['specializations'].map<Widget>((spec) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  spec,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.primaryGreen,
                    fontSize: 11,
                  ),
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 12),
          
          // Languages and location
          Row(
            children: [
              Icon(
                Icons.language,
                size: 14,
                color: AppColors.textLight,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  professional['languages'].join(', '),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textMedium,
                  ),
                ),
              ),
              Icon(
                Icons.location_on,
                size: 14,
                color: AppColors.textLight,
              ),
              const SizedBox(width: 4),
              Text(
                professional['location'],
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textMedium,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Availability and actions
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: professional['availability'] == 'Available' 
                      ? AppColors.successSoft.withOpacity(0.1)
                      : AppColors.warningAmber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  professional['availability'],
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: professional['availability'] == 'Available' 
                        ? AppColors.successSoft
                        : AppColors.warningAmber,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => _showProfessionalDetails(professional),
                child: const Text('View Profile'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: professional['availability'] == 'Available' 
                    ? () => _bookConsultation(professional)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Book Now'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Professionals'),
        content: StatefulBuilder(
          builder: (context, setDialogState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Specialty filter
              DropdownButtonFormField<String>(
                value: selectedSpecialty,
                decoration: const InputDecoration(labelText: 'Specialty'),
                items: specialties.map((specialty) => DropdownMenuItem(
                  value: specialty,
                  child: Text(specialty),
                )).toList(),
                onChanged: (value) {
                  setDialogState(() {
                    selectedSpecialty = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              
              // Language filter
              DropdownButtonFormField<String>(
                value: selectedLanguage,
                decoration: const InputDecoration(labelText: 'Language'),
                items: languages.map((language) => DropdownMenuItem(
                  value: language,
                  child: Text(language),
                )).toList(),
                onChanged: (value) {
                  setDialogState(() {
                    selectedLanguage = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              
              // Location filter
              DropdownButtonFormField<String>(
                value: selectedLocation,
                decoration: const InputDecoration(labelText: 'Location'),
                items: locations.map((location) => DropdownMenuItem(
                  value: location,
                  child: Text(location),
                )).toList(),
                onChanged: (value) {
                  setDialogState(() {
                    selectedLocation = value!;
                  });
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                selectedSpecialty = 'All';
                selectedLanguage = 'All';
                selectedLocation = 'All';
              });
              Navigator.pop(context);
            },
            child: const Text('Clear All'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {});
              Navigator.pop(context);
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _showProfessionalDetails(Map<String, dynamic> professional) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
                      child: Text(
                        professional['name'].split(' ').map((name) => name[0]).join(),
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            professional['name'],
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: AppColors.textDark,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            professional['specialty'],
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.primaryBlue,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                size: 16,
                                color: AppColors.warningAmber,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${professional['rating']} rating',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Professional details
                _buildDetailSection('Qualification', professional['qualification']),
                _buildDetailSection('Experience', professional['experience']),
                _buildDetailSection('Languages', professional['languages'].join(', ')),
                _buildDetailSection('Location', professional['location']),
                _buildDetailSection('Consultation Fee', professional['consultationFee']),
                
                const SizedBox(height: 16),
                
                Text(
                  'Specializations',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: professional['specializations'].map<Widget>((spec) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        spec,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                
                const SizedBox(height: 24),
                
                // Book button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: professional['availability'] == 'Available' 
                        ? () => _bookConsultation(professional)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      professional['availability'] == 'Available' 
                          ? 'Book Consultation'
                          : professional['availability'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textMedium,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _bookConsultation(Map<String, dynamic> professional) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Book Consultation with ${professional['name']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Consultation Fee: ${professional['consultationFee']}'),
            const SizedBox(height: 8),
            const Text('Note: This is a demonstration. In a real app, this would integrate with booking systems and payment processing.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Booking request sent to ${professional['name']}'),
                  backgroundColor: AppColors.successSoft,
                ),
              );
            },
            child: const Text('Confirm Booking'),
          ),
        ],
      ),
    );
  }
}