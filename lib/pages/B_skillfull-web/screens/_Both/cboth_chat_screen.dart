import 'package:flutter/material.dart';

class BothChatScreen extends StatefulWidget {
  const BothChatScreen({super.key});

  @override
  State<BothChatScreen> createState() => _BothChatScreenState();
}

class _BothChatScreenState extends State<BothChatScreen> {
  bool isClientView = true;

  final List<Map<String, String>> clientChats = [
    {
      'freelancer': 'FixIt Pro',
      'lastMessage': 'Hello, I can fix your electrical issue.',
      'time': 'Apr 10, 2025, 3:00 PM',
    },
    {
      'freelancer': 'CleanMaid',
      'lastMessage': 'Your cleaning appointment is scheduled.',
      'time': 'Apr 12, 2025, 10:30 AM',
    },
  ];

  final List<Map<String, String>> freelancerChats = [
    {
      'client': 'Sarah M.',
      'lastMessage': 'Looking forward to the website design!',
      'time': 'Apr 14, 2025, 2:00 PM',
    },
    {
      'client': 'David K.',
      'lastMessage': 'Can you work on my logo design?',
      'time': 'Apr 15, 2025, 9:15 AM',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        actions: [
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
          const SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isClientView ? _buildClientChats() : _buildFreelancerChats(),
      ),
    );
  }

  Widget _buildClientChats() {
    return ListView.builder(
      itemCount: clientChats.length,
      itemBuilder: (context, index) {
        final chat = clientChats[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: const Icon(Icons.person, color: Colors.green),
            title: Text(chat['freelancer'] ?? ''),
            subtitle: Text('${chat['lastMessage']} • ${chat['time']}'),
            trailing: Icon(Icons.chat_bubble_outline, color: Colors.grey),
            onTap: () {
              // Navigate to detailed chat screen
            },
          ),
        );
      },
    );
  }

  Widget _buildFreelancerChats() {
    return ListView.builder(
      itemCount: freelancerChats.length,
      itemBuilder: (context, index) {
        final chat = freelancerChats[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: const Icon(Icons.shopping_cart, color: Colors.blue),
            title: Text(chat['client'] ?? ''),
            subtitle: Text('${chat['lastMessage']} • ${chat['time']}'),
            trailing: Icon(Icons.chat_bubble_outline, color: Colors.grey),
            onTap: () {
              // Navigate to detailed chat screen
            },
          ),
        );
      },
    );
  }
}
