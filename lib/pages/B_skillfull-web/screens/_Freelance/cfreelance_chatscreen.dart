import 'package:flutter/material.dart';

class FreelancerPreChatScreen extends StatelessWidget {
  const FreelancerPreChatScreen({super.key});

  final List<Map<String, String>> chats = const [
    {
      'name': 'David Miller',
      'message': 'Hi, are you available for...',
      'avatar': 'https://i.pravatar.cc/150?img=3'
    },
    {
      'name': 'Amanda Lee',
      'message': 'Can we schedule the service?',
      'avatar': 'https://i.pravatar.cc/150?img=5'
    },
    {
      'name': 'Samuel Kent',
      'message': 'I need help with plumbing work.',
      'avatar': 'https://i.pravatar.cc/150?img=8'
    },
    {
      'name': 'Lana West',
      'message': 'Is your rate still \$100?',
      'avatar': 'https://i.pravatar.cc/150?img=10'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: const CircleAvatar(
          backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=1'),
        ),
        title: const Text('Messages', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        actions: const [
          Icon(Icons.card_giftcard, color: Colors.black),
          SizedBox(width: 10),
          Icon(Icons.emoji_emotions_outlined, color: Colors.black),
          SizedBox(width: 10),
          Icon(Icons.notifications_none, color: Colors.black),
          SizedBox(width: 10),
          Icon(Icons.settings, color: Colors.black),
          SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          // Banner or promo box
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text("Tip: Respond quickly to get more clients!",
                      style: TextStyle(fontSize: 14)),
                ),
                Icon(Icons.flash_on, color: Colors.green),
              ],
            ),
          ),

          // Search + Filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search",
                      prefixIcon: const Icon(Icons.search),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Icon(Icons.filter_alt, color: Colors.white),
                )
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Chat preview list
          Expanded(
            child: ListView.builder(
              itemCount: chats.length,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemBuilder: (context, index) {
                final chat = chats[index];
                return InkWell(
                  onTap: () {
                    // Navigate to chat screen
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: const Offset(1, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(chat['avatar']!),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(chat['name']!,
                                  style: theme.textTheme.titleMedium),
                              const SizedBox(height: 4),
                              Text(chat['message']!,
                                  style: const TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 16)
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
