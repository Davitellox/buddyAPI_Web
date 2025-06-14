import 'package:buddy/pages/_logik/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BothProfileScreen extends StatefulWidget {
  const BothProfileScreen({super.key});

  @override
  State<BothProfileScreen> createState() => _BothProfileScreenState();
}

class _BothProfileScreenState extends State<BothProfileScreen> {
  bool isClientView = true;

  // Sample user data for both client and freelancer views
  final Map<String, String> clientData = {
    'name': 'John Doe',
    'email': 'johndoe@email.com',
    'bio': 'Looking for service providers for home improvement projects.',
    'phone': '+1234567890',
  };

  final Map<String, String> freelancerData = {
    'name': 'Jane Smith',
    'email': 'janesmith@email.com',
    'bio': 'I specialize in web development and app design.',
    'portfolio': 'www.janesmithportfolio.com',
    'phone': '+0987654321',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              // Handle logout logic
              // Example: FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ToggleButtons(
              isSelected: [isClientView, !isClientView],
              onPressed: (index) {
                setState(() {
                  isClientView = index == 0;
                });
              },
              borderRadius: BorderRadius.circular(8),
              selectedColor: Colors.white,
              fillColor: Theme.of(context).primaryColor,
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text("Client"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text("Freelancer"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            isClientView ? _buildClientProfile() : _buildFreelancerProfile(),
            const SizedBox(height: 20),
            _buildPremiumPurchaseButton(),
            const SizedBox(height: 20),
            _buildEditAccountButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildClientProfile() {
    final theme = Theme.of(context);
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          secondary: Icon(
            isDarkMode ? Icons.light_mode : Icons.dark_mode,
            color: Colors.green,
          ),
          title: Text(isDarkMode ? "Light Mode" : "Dark Mode"),
          value: isDarkMode,
          onChanged: (value) {
            context.read<ThemeProvider>().setTheme(value);
          },
        ),
        _buildProfileRow('Name', clientData['name']!),
        _buildProfileRow('Email', clientData['email']!),
        _buildProfileRow('Bio', clientData['bio']!),
        _buildProfileRow('Phone', clientData['phone']!),
        _buildEditProfileButton('Edit Client Bio'),
      ],
    );
  }

  Widget _buildFreelancerProfile() {
    final theme = Theme.of(context);
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          secondary: Icon(
            isDarkMode ? Icons.light_mode : Icons.dark_mode,
            color: Colors.green,
          ),
          title: Text(isDarkMode ? "Light Mode" : "Dark Mode"),
          value: isDarkMode,
          onChanged: (value) {
            context.read<ThemeProvider>().setTheme(value);
          },
        ),
        _buildProfileRow('Name', freelancerData['name']!),
        _buildProfileRow('Email', freelancerData['email']!),
        _buildProfileRow('Bio', freelancerData['bio']!),
        _buildProfileRow('Portfolio', freelancerData['portfolio']!),
        _buildProfileRow('Phone', freelancerData['phone']!),
        _buildEditProfileButton('Edit Freelancer Portfolio'),
      ],
    );
  }

  Widget _buildProfileRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text('$title: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildEditProfileButton(String label) {
    return ElevatedButton(
      onPressed: () {
        // Navigate to the profile editing page
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const EditBothProfileScreen()),
        );
      },
      child: Text(label),
    );
  }

  Widget _buildPremiumPurchaseButton() {
    return ElevatedButton(
      onPressed: () {
        // Handle premium purchase logic
        // Example: Navigate to a payment gateway
      },
      child: const Text('Purchase Premium Plan'),
    );
  }

  Widget _buildEditAccountButton() {
    return ElevatedButton(
      onPressed: () {
        // Navigate to edit account screen (email/password change, etc.)
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EditAccountScreen()),
        );
      },
      child: const Text('Edit Account'),
    );
  }
}

class EditBothProfileScreen extends StatelessWidget {
  const EditBothProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: const Center(
          child: Text('Profile Edit Screen')), // Add fields to edit profile
    );
  }
}

class EditAccountScreen extends StatelessWidget {
  const EditAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Account')),
      body: const Center(
          child: Text('Edit Account Screen')), // Add fields for account changes
    );
  }
}
