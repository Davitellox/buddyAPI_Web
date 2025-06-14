import 'package:flutter/material.dart';

class BothHomeScreen extends StatefulWidget {
  const BothHomeScreen({super.key});

  @override
  State<BothHomeScreen> createState() => _BothHomeScreenState();
}

class _BothHomeScreenState extends State<BothHomeScreen> {
  bool isClientView = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
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
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('Client'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('Freelancer'),
              ),
            ],
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: isClientView ? _buildClientView() : _buildFreelancerView(),
    );
  }

  Widget _buildClientView() {
    final List<Map<String, dynamic>> providers = [
      {
        'name': 'Jane Doe',
        'skill': 'Graphic Designer',
        'rating': 4.8,
        'image': 'https://via.placeholder.com/150'
      },
      {
        'name': 'John Smith',
        'skill': 'Web Developer',
        'rating': 4.7,
        'image': 'https://via.placeholder.com/150'
      },
      {
        'name': 'Maria Lee',
        'skill': 'Content Writer',
        'rating': 4.9,
        'image': 'https://via.placeholder.com/150'
      },
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('📦 Your Orders',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(child: Text('You have no current orders')),
        ),
        const SizedBox(height: 24),
        const Text('🌟 Top Service Providers',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...providers.map((provider) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 3,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(provider['image']!),
                radius: 28,
              ),
              title: Text(provider['name']!,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(provider['skill']!),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(provider['rating'].toString()),
                    ],
                  ),
                ],
              ),
              trailing: ElevatedButton(
                onPressed: () {
                  // Navigate to profile or order screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Order'),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildFreelancerView() {
    final List<Map<String, dynamic>> jobRequests = [
      {
        'clientName': 'Alice Brown',
        'service': 'Logo Design',
        'budget': '\$80',
        'deadline': '2 days',
      },
      {
        'clientName': 'Daniel Cruz',
        'service': 'Mobile App UI',
        'budget': '\$150',
        'deadline': '5 days',
      },
    ];

    final List<Map<String, dynamic>> topJobs = [
      {
        'title': 'Website Redesign',
        'pay': '\$300',
        'description': 'Redesign landing page for tech startup.',
      },
      {
        'title': 'Social Media Banners',
        'pay': '\$120',
        'description': 'Create banners for IG and Twitter.',
      },
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('📥 Client Job Requests',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...jobRequests.map((job) => Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(job['service'] as String),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Client: ${job['clientName']}'),
                    Text('Deadline: ${job['deadline']}'),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.attach_money, color: Colors.green),
                    Text(job['budget'] as String,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            )),
        const SizedBox(height: 24),
        const Text('🏆 Top Job Offers',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...topJobs.map((job) => Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(job['title'] as String),
                subtitle: Text(job['description'] as String),
                trailing: Chip(
                  label: Text(job['pay'] as String),
                  backgroundColor: Colors.green.shade100,
                ),
              ),
            )),
      ],
    );
  }
}
