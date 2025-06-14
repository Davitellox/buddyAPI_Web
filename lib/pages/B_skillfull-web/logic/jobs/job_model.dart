//job model for every job posted and created by the clients
import 'package:cloud_firestore/cloud_firestore.dart';

class Job {
  final String id;
  final String title;
  final String clientName;
  final String price;
  final String location;
  final DateTime? deadline; // Optional
  final String? description;
  final String? distance; // Optional
  final bool isPremiumClient;
  final List<String> category;

  Job(
      {required this.id,
      required this.title,
      required this.clientName,
      required this.price,
      required this.location,
      this.deadline,
      this.description,
      this.distance,
      this.isPremiumClient = false,
      required this.category});

  factory Job.fromDocument(doc) {
    final data = doc.data() as Map<String, dynamic>;
    final rawDeadline = data['deadline'];

    return Job(
      id: doc.id,
      title: data['title'] ?? '',
      clientName: data['client'] ?? '',
      price: data['price'] ?? '',
      location: data['location'] ?? '',
      deadline: rawDeadline != null
          ? (rawDeadline is Timestamp
              ? rawDeadline.toDate()
              : DateTime.tryParse(rawDeadline))
          : null,
      description: data['description'],
      distance: data['distance'],
      isPremiumClient: data['isPremiumClient'] ?? false,
      category: List<String>.from(data['category'] ?? []),
    );
  }
}

extension JobExtension on Job {
  double get priceValue {
    final cleaned = price.replaceAll(RegExp(r'[^\d.]'), '');
    if (cleaned.isEmpty) return 0.0; // Handles 'Negotiable', 'N/A', etc.
    return double.tryParse(cleaned) ?? 0.0;
  }
}
