import 'package:buddy/pages/_config/bchoose_ur_buddy.dart';
import 'package:buddy/pages/_logik/splash_screen_to.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  _ProfileSettingsScreenState createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  bool _darkMode = false;
  bool _notifications = true;
  String? _userPhotoUrl;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      final doc = await docRef.get();

      setState(() {
        _userPhotoUrl = user.photoURL;
        _nameController.text =
            doc.exists ? (doc.data()?['name'] ?? '') : user.displayName ?? '';
        _emailController.text =
            doc.exists ? (doc.data()?['email'] ?? '') : user.email ?? '';
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _showConfirmationDialog(
      String title, String content, Function() onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 600;
    final contentWidth = isDesktop ? 600.0 : screenWidth;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Settings'),
        elevation: 0,
      ),
      body: Center(
        child: SizedBox(
          width: contentWidth,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 32.0 : 16.0,
                vertical: 16.0,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: isDesktop ? 60 : 50,
                            backgroundImage: _userPhotoUrl != null
                                ? NetworkImage(_userPhotoUrl!)
                                : const NetworkImage(
                                    'https://via.placeholder.com/150'),
                            backgroundColor: Colors.grey[200],
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.camera_alt,
                                    color: Colors.white),
                                onPressed: () {
                                  // Handle image upload
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: isDesktop ? 40 : 32),
                    TextFormField(
                      controller: _nameController,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.email),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Preferences',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: Column(
                        children: [
                          SwitchListTile(
                            title: const Text('Dark Mode'),
                            subtitle: const Text('Enable dark theme'),
                            value: _darkMode,
                            onChanged: (value) {
                              setState(() {
                                _darkMode = value;
                              });
                            },
                          ),
                          SwitchListTile(
                            title: const Text('Notifications'),
                            subtitle: const Text('Enable push notifications'),
                            value: _notifications,
                            onChanged: (value) {
                              setState(() {
                                _notifications = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Save profile settings
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Save Changes',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Account Actions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.refresh),
                            title: const Text('Regenerate Personal Data'),
                            subtitle: const Text('Create new profile data'),
                            onTap: () {
                              _showConfirmationDialog(
                                'Regenerate Personal Data',
                                'Are you sure you want to regenerate your personal data? Note this would delete your existing data.',
                                () {
                                  // Handle regenerate personal data
                                },
                              );
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.logout),
                            title: const Text('Logout'),
                            subtitle: const Text('Sign out from your account'),
                            onTap: () {
                              _showConfirmationDialog(
                                'Logout',
                                'Are you sure you want to logout?',
                                () {
                                  // Handle logout
                                  FirebaseAuth.instance.signOut();
                                  Navigator.of(context).pop();
                                  // Optionally navigate to login screen
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => SplashScreenTo(
                                        screen: Choose_Ur_BuddyScreen(),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          ListTile(
                            leading: const Icon(FontAwesomeIcons.robot),
                            title: const Text('Powered by Trae AI'),
                            subtitle: const Text(
                                'This application was made with Trae AI'),
                            onTap: () {
                              _showConfirmationDialog(
                                'Download Trae AI',
                                'Download Trae AI Code Editor.',
                                () {
                                  // Handle regenerate personal data
                                },
                              );
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.delete_forever,
                                color: Colors.red),
                            title: const Text(
                              'Deactivate Account',
                              style: TextStyle(color: Colors.red),
                            ),
                            subtitle:
                                const Text('Permanently delete your account'),
                            onTap: () {
                              _showConfirmationDialog(
                                'Deactivate Account',
                                'Are you sure you want to deactivate your account? This action cannot be undone.',
                                () {
                                  // Handle account deactivation
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
