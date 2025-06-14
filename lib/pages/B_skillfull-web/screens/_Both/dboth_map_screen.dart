import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BothMapScreen extends StatefulWidget {
  const BothMapScreen({super.key});

  @override
  State<BothMapScreen> createState() => _BothMapScreenState();
}

class _BothMapScreenState extends State<BothMapScreen> {
  bool isClientView = true; // Toggle between client and freelancer view
  late GoogleMapController mapController;

  // Sample freelancer service locations (mock data)
  final List<Marker> freelancerMarkers = [
    Marker(
      markerId: MarkerId('1'),
      position: LatLng(37.7749, -122.4194), // San Francisco
      infoWindow: InfoWindow(title: 'John Doe', snippet: 'Electrical Repair'),
    ),
    Marker(
      markerId: MarkerId('2'),
      position: LatLng(37.8044, -122.2711), // Oakland
      infoWindow: InfoWindow(title: 'Jane Smith', snippet: 'Home Cleaning'),
    ),
    Marker(
      markerId: MarkerId('3'),
      position: LatLng(37.6879, -122.4702), // Richmond
      infoWindow: InfoWindow(title: 'Alice Lee', snippet: 'Web Design'),
    ),
  ];

  // Client's current location (mock data)
  final LatLng clientLocation = LatLng(37.7749, -122.4194); // San Francisco

  // Freelancers' locations
  final List<LatLng> freelancerLocations = [
    LatLng(37.7749, -122.4194), // Freelancer 1
    LatLng(37.8044, -122.2711), // Freelancer 2
    LatLng(37.6879, -122.4702), // Freelancer 3
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Freelancers'),
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
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: clientLocation, // Client's initial location
          zoom: 12,
        ),
        markers: Set<Marker>.of(freelancerMarkers),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onTap: (LatLng latLng) {
          // Handle tap event for client to select a freelancer
          if (isClientView) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Freelancer Details'),
                content: const Text('Service: Electrical Repair\nProvider: John Doe'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: isClientView
          ? FloatingActionButton(
              onPressed: _findNearbyFreelancers,
              tooltip: 'Find Nearby Freelancers',
              child: const Icon(Icons.search),
            )
          : null,
    );
  }

  // Mock function to find nearby freelancers (you can expand with real functionality)
  void _findNearbyFreelancers() {
    // In a real app, you would use the user's current location and calculate distances to the freelancers
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Finding nearby freelancers...')),
    );
    // Here we just simulate showing freelancer markers on the map
    setState(() {
      freelancerMarkers.addAll([
        Marker(
          markerId: MarkerId('4'),
          position: LatLng(37.6879, -122.4702), // Another Freelancer
          infoWindow: InfoWindow(title: 'Bob Brown', snippet: 'Plumbing'),
        ),
      ]);
    });
  }
}
