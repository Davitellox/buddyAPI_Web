import 'package:buddy/pages/_logik/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FreelancerProfileScreen extends StatelessWidget {
  const FreelancerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;

    final List<Map<String, dynamic>> profileOptions = [
      {'icon': Icons.edit, 'title': 'Edit Account', 'onTap': () {}},
      {'icon': Icons.work, 'title': 'Portfolio', 'onTap': () {}},
      {'icon': Icons.lock, 'title': 'Account Settings', 'onTap': () {}},
      {'icon': Icons.star, 'title': 'Upgrade to Premium', 'onTap': () {}},
      {'icon': Icons.logout, 'title': 'Logout', 'onTap': () {}},
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: const Icon(Icons.person, color: Colors.black),
        title: const Text("My Profile", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        actions: const [
          Icon(Icons.card_giftcard, color: Colors.black),
          SizedBox(width: 12),
          Icon(Icons.settings, color: Colors.black),
          SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          // Profile Picture & Name
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 45,
                  backgroundImage:
                      NetworkImage("https://i.pravatar.cc/150?img=9"),
                ),
                const SizedBox(height: 10),
                Text("Alex Grant", style: theme.textTheme.titleLarge),
                Text("Creative Designer", style: theme.textTheme.bodyMedium),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // List of profile actions + Theme toggle
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: profileOptions.length + 1, // +1 for theme switch
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Theme Toggle Switch
                  return SwitchListTile(
                    secondary: Icon(
                      isDarkMode ? Icons.light_mode : Icons.dark_mode,
                      color: Colors.green,
                    ),
                    title: Text(isDarkMode ? "Light Mode" : "Dark Mode"),
                    value: isDarkMode,
                    onChanged: (value) {
                      context.read<ThemeProvider>().setTheme(value);
                    },
                  );
                } else {
                  final option = profileOptions[index - 1];
                  return ListTile(
                    leading: Icon(option['icon'], color: Colors.green),
                    title: Text(option['title']),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: option['onTap'],
                  );
                }
              },
            ),
          ),

          const SizedBox(height: 10),

          // Delete account
          TextButton.icon(
            onPressed: () {
              // Handle deletion confirmation
            },
            icon: const Icon(Icons.delete, color: Colors.red),
            label: const Text("Delete Account",
                style: TextStyle(color: Colors.red)),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
