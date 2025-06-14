import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FreelanceOrderScreen extends StatelessWidget {
  const FreelanceOrderScreen({super.key});

  // Example order data (you can replace this with API data later)
  final List<Map<String, dynamic>> orders = const [
    {
      'clientName': 'Alex Johnson',
      'service': 'Graphic Design',
      'dateTime': '2025-04-29 14:30:00',
      'price': 150,
      'isPaid': false,
    },
    {
      'clientName': 'Sophia Smith',
      'service': 'Home Cleaning',
      'dateTime': '2025-04-28 10:00:00',
      'price': 80,
      'isPaid': true,
    },
    {
      'clientName': 'Daniel Craig',
      'service': 'Tutoring - Math',
      'dateTime': '2025-04-27 16:00:00',
      'price': 200,
      'isPaid': false,
    },
  ];

  String formatDate(String dateTime) {
    final DateTime dt = DateTime.parse(dateTime);
    return DateFormat('MMM d, y – h:mm a').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: orders.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final order = orders[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: const Offset(2, 2),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order['service'],
                  style: theme.textTheme.titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text("Client: ${order['clientName']}",
                    style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 6),
                Text("Time: ${formatDate(order['dateTime'])}"),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("\$${order['price']}",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    ElevatedButton.icon(
                      onPressed:
                          order['isPaid'] ? null : () {/* trigger pay request */},
                      icon: Icon(order['isPaid']
                          ? Icons.check_circle
                          : Icons.request_page),
                      label: Text(order['isPaid'] ? "Paid" : "Request Pay"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: order['isPaid']
                            ? Colors.grey
                            : Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
