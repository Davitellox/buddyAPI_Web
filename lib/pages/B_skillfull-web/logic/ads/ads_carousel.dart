import 'package:buddy/pages/B_skillfull-web/logic/ads/ad_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdsCarousel extends StatefulWidget {
  const AdsCarousel({super.key});

  @override
  _AdsCarouselState createState() => _AdsCarouselState();
}

class _AdsCarouselState extends State<AdsCarousel> {
  List<AppAd> ads = [];
  bool showCarousel =
      true; // Variable to determine whether to show the carousel

  @override
  void initState() {
    super.initState();
    loadAds(); // Load the ads when the widget is initialized
  }

  // Function to fetch user type from Firebase or local storage
  Future<String> getUserType() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      var userType = userDoc['userType'] ?? '';
      return userType;
    }
    return ''; // Default if user is not logged in
  }

  // Function to fetch the configads document and check if ads should be shown
  Future<void> checkAdsConfig() async {
    var configDoc = await FirebaseFirestore.instance
        .collection('ads')
        .doc('configads')
        .get();
    bool show = configDoc['showAds'] ?? false;
    setState(() {
      showCarousel = show; // Update the state to control visibility
    });
  }

  // Function to fetch ads for the user type
  Future<void> loadAds() async {
    String userType = await getUserType();
    if (userType.isNotEmpty) {
      List<AppAd> fetchedAds = await fetchAdsForUser(userType);
      setState(() {
        ads = fetchedAds;
      });
    }
    // Check if ads should be shown based on configads document
    await checkAdsConfig();
  }

  // Function to fetch ads based on userType
  Future<List<AppAd>> fetchAdsForUser(String userType) async {
    var adsQuery = FirebaseFirestore.instance.collection('ads');
    var snapshot = await adsQuery.where('userType', isEqualTo: userType).get();

    List<AppAd> adsList = [];
    for (var doc in snapshot.docs) {
      var ad = AppAd.fromMap(doc.data());
      adsList.add(ad);
    }
    return adsList;
  }
  @override
  Widget build(BuildContext context) {
    // If showCarousel is false, return an empty SizedBox to hide the carousel
    if (!showCarousel) {
      return const SizedBox.shrink(); // The entire carousel is hidden
    }
    // If no ads to show
    if (ads.isEmpty) {
      return const SizedBox(
        height: 160,
        child: Center(child: Text("No ads to display")),
      );
    }
    return CarouselSlider(
      options: CarouselOptions(
        height: 160,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.9,
      ),
      items:
          ads.where((ad) => ad.show && ad.imageUrl.trim().isNotEmpty).map((ad) {
        return GestureDetector(
          onTap: () async {
            final url = Uri.tryParse(ad.redirectUrl);
            if (url != null && await canLaunchUrl(url)) {
              await launchUrl(url);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Could not launch ad link')),
              );
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: NetworkImage(ad.imageUrl),
                fit: BoxFit.cover,
                onError: (error, stackTrace) =>
                    debugPrint('Image load error: $error'),
              ),
            ),
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.all(12),
            child: Text(
              ad.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 4,
                    color: Colors.black87,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

Future<String> getUserType() async {
  // Assuming you're using FirebaseAuth to get the current user
  var user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    // Assuming you store user type in Firebase under the 'users' collection
    var userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    var userType =
        userDoc['userType'] ?? ''; // Default to an empty string if not found
    return userType;
  }
  return ''; // If no user is logged in
}