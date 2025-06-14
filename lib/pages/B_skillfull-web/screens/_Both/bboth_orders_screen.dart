import 'package:flutter/material.dart';

class BothOrdersScreen extends StatefulWidget {
  const BothOrdersScreen({super.key});

  @override
  State<BothOrdersScreen> createState() => _BothOrdersScreenState();
}

class _BothOrdersScreenState extends State<BothOrdersScreen> {
  bool isClientView = true;

  final List<Map<String, String>> clientOrders = [
    {
      'provider': 'FixIt Pro',
      'service': 'Electrical Repair',
      'date': 'Apr 10, 2025',
      'price': '\$80',
    },
    {
      'provider': 'CleanMaid',
      'service': 'Home Cleaning',
      'date': 'Apr 12, 2025',
      'price': '\$60',
    },
  ];

  final List<Map<String, String>> freelancerOrders = [
    {
      'client': 'Sarah M.',
      'service': 'Web Design',
      'date': 'Apr 14, 2025',
      'price': '\$120',
    },
    {
      'client': 'David K.',
      'service': 'Logo Creation',
      'date': 'Apr 15, 2025',
      'price': '\$50',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
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
        child: isClientView ? _buildClientOrders() : _buildFreelancerOrders(),
      ),
    );
  }

  Widget _buildClientOrders() {
    return ListView.builder(
      itemCount: clientOrders.length,
      itemBuilder: (context, index) {
        final order = clientOrders[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: const Icon(Icons.person, color: Colors.green),
            title: Text(order['provider'] ?? ''),
            subtitle: Text('${order['service']} • ${order['date']}'),
            trailing: Text(order['price'] ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        );
      },
    );
  }

  Widget _buildFreelancerOrders() {
    return ListView.builder(
      itemCount: freelancerOrders.length,
      itemBuilder: (context, index) {
        final order = freelancerOrders[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: const Icon(Icons.shopping_cart, color: Colors.blue),
            title: Text(order['client'] ?? ''),
            subtitle: Text('${order['service']} • ${order['date']}'),
            trailing: Text(order['price'] ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        );
      },
    );
  }
}
