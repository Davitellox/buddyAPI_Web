// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';

// class ClientMapScreen extends StatefulWidget {
//   const ClientMapScreen({super.key});

//   @override
//   State<ClientMapScreen> createState() => _ClientMapScreenState();
// }

// class _ClientMapScreenState extends State<ClientMapScreen> {
//   GoogleMapController? _mapController;
//   Position? _currentPosition;
//   Set<Marker> _markers = {};
//   String selectedService = 'Plumber';

//   // Sample static data
//   final List<Map<String, dynamic>> allProviders = [
//     {
//       'id': '1',
//       'name': 'John Pipes',
//       'lat': 37.421998,
//       'lng': -122.084,
//       'service': 'Plumber'
//     },
//     {
//       'id': '2',
//       'name': 'Ella Spark',
//       'lat': 37.4225,
//       'lng': -122.085,
//       'service': 'Electrician'
//     },
//     {
//       'id': '3',
//       'name': 'Mike Shine',
//       'lat': 37.4205,
//       'lng': -122.082,
//       'service': 'Cleaner'
//     },
//     {
//       'id': '4',
//       'name': 'Tina Tools',
//       'lat': 37.4235,
//       'lng': -122.086,
//       'service': 'Plumber'
//     },
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   void _getCurrentLocation() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       await Geolocator.openLocationSettings();
//     }

//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied ||
//         permission == LocationPermission.deniedForever) {
//       permission = await Geolocator.requestPermission();
//     }

//     final position = await Geolocator.getCurrentPosition();
//     setState(() {
//       _currentPosition = position;
//     });

//     _mapController?.animateCamera(
//       CameraUpdate.newLatLngZoom(
//         LatLng(position.latitude, position.longitude),
//         14,
//       ),
//     );

//     _filterProviders(); // show markers after getting location
//   }

//   void _filterProviders() {
//     final filtered = allProviders.where(
//         (provider) => provider['service'] == selectedService).toList();

//     final newMarkers = filtered.map((provider) {
//       return Marker(
//         markerId: MarkerId(provider['id']),
//         position: LatLng(provider['lat'], provider['lng']),
//         infoWindow: InfoWindow(
//           title: provider['name'],
//           snippet: provider['service'],
//         ),
//         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
//       );
//     }).toSet();

//     setState(() {
//       _markers = newMarkers;
//     });
//   }

//   void _onServiceChange(String? value) {
//     if (value != null && value != selectedService) {
//       setState(() {
//         selectedService = value;
//       });
//       _filterProviders();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Nearby Providers'),
//         backgroundColor: Colors.green,
//       ),
//       body: Stack(
//         children: [
//           if (_currentPosition != null)
//             GoogleMap(
//               onMapCreated: (controller) => _mapController = controller,
//               initialCameraPosition: CameraPosition(
//                 target: LatLng(
//                     _currentPosition!.latitude, _currentPosition!.longitude),
//                 zoom: 14,
//               ),
//               markers: _markers,
//               myLocationEnabled: true,
//               myLocationButtonEnabled: true,
//             )
//           else
//             const Center(child: CircularProgressIndicator()),

//           // Dropdown Filter
//           Positioned(
//             top: 10,
//             left: 15,
//             right: 15,
//             child: Card(
//               elevation: 3,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 child: DropdownButton<String>(
//                   value: selectedService,
//                   icon: const Icon(Icons.arrow_drop_down),
//                   isExpanded: true,
//                   underline: Container(),
//                   items: const [
//                     DropdownMenuItem(value: 'Plumber', child: Text('Plumber')),
//                     DropdownMenuItem(
//                         value: 'Electrician', child: Text('Electrician')),
//                     DropdownMenuItem(value: 'Cleaner', child: Text('Cleaner')),
//                   ],
//                   onChanged: _onServiceChange,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
