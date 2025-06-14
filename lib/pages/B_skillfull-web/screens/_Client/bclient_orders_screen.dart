import 'package:flutter/material.dart';

class ClientOrdersPage extends StatelessWidget {
  const ClientOrdersPage({super.key});

  // Dummy order data
  final List<Map<String, dynamic>> currentOrders = const [
    {
      'title': 'House Cleaning',
      'provider': 'Jane Doe',
      'status': 'In Progress',
      'date': 'Apr 28, 2025',
    },
    {
      'title': 'Plumbing Repair',
      'provider': 'John Smith',
      'status': 'Scheduled',
      'date': 'May 2, 2025',
    },
  ];

  final List<Map<String, dynamic>> pastOrders = const [
    {
      'title': 'Electrician Service',
      'provider': 'Mike Johnson',
      'status': 'Completed',
      'date': 'Mar 15, 2025',
    },
    {
      'title': 'Gardening',
      'provider': 'Lisa Green',
      'status': 'Completed',
      'date': 'Feb 22, 2025',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            const Text(
              'Ongoing Orders',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...currentOrders.map((order) => OrderCard(order: order)),

            const SizedBox(height: 20),
            const Text(
              'Past Orders',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...pastOrders.map((order) => OrderCard(order: order)),
          ],
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.green,
          child: Icon(Icons.build, color: Colors.white),
        ),
        title: Text(order['title']),
        subtitle: Text('Provider: ${order['provider']}\nDate: ${order['date']}'),
        trailing: Text(
          order['status'],
          style: TextStyle(
            color: order['status'] == 'Completed' ? Colors.grey : Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
