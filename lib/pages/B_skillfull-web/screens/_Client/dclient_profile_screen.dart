import 'package:buddy/pages/_logik/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClientProfileScreen extends StatefulWidget {
  const ClientProfileScreen({super.key});

  @override
  State<ClientProfileScreen> createState() => _ClientProfileScreenState();
}

class _ClientProfileScreenState extends State<ClientProfileScreen> {
  final TextEditingController nameController =
      TextEditingController(text: "John Doe");
  final TextEditingController emailController =
      TextEditingController(text: "john.doe@example.com");
  final TextEditingController phoneController =
      TextEditingController(text: "+1234567890");

  bool isPremium = false;

  void _saveProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile updated!")),
    );
  }

  void _upgradeToPremium() {
    setState(() {
      isPremium = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Thank you for upgrading to Premium!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: Colors.green[700],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar + edit
            Stack(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      AssetImage("assets/user.png"), // replace with actual
                ),
                Positioned(
                  bottom: 0,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child:
                        const Icon(Icons.edit, size: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
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
            const SizedBox(height: 20),

            // Name
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Full Name",
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 10),

            // Email
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10),

            // Phone
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: "Phone Number",
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),

            // Save Changes
            ElevatedButton.icon(
              onPressed: _saveProfile,
              icon: const Icon(Icons.save),
              label: const Text("Save Changes"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
            ),

            const SizedBox(height: 30),

            // Upgrade to Premium
            if (!isPremium)
              Card(
                color: Colors.yellow[700],
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: const Icon(Icons.star, color: Colors.white),
                  title: const Text("Upgrade to Premium",
                      style: TextStyle(color: Colors.white)),
                  subtitle: const Text("Access premium features",
                      style: TextStyle(color: Colors.white70)),
                  trailing: ElevatedButton(
                    onPressed: _upgradeToPremium,
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.white),
                    child: const Text("Go Premium",
                        style: TextStyle(color: Colors.black)),
                  ),
                ),
              )
            else
              const ListTile(
                leading: Icon(Icons.verified, color: Colors.green),
                title: Text("You are a Premium Client!"),
                subtitle: Text("Enjoy all features."),
              ),

            const SizedBox(height: 30),

            // Logout
            TextButton.icon(
              onPressed: () {
                // logout logic here
              },
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
