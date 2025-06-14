import 'package:buddy/pages/B_skillfull-web/logic/ads/ad_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<AppAd>> fetchAdsForUser(String userType) async {
  try {
    // Step 1: Fetch the config document to check if ads should be shown
    DocumentSnapshot configSnapshot = await FirebaseFirestore.instance
        .collection('ads')
        .doc('configads')
        .get();

    // If the config document is not available or the showAds field is false, return an empty list
    if (!configSnapshot.exists || configSnapshot['showAds'] != true) {
      return [];
    }
    // Step 2: Fetch the ads collection
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('ads')
        .where('userType', isEqualTo: userType) // Filter by userType
        .get();

    // Step 3: Map documents to AppAd objects
    List<AppAd> ads = querySnapshot.docs.map((doc) {
      return AppAd.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();

    // Step 4: Filter ads by the show field (only ads with show: true will be displayed)
    List<AppAd> filteredAds = ads.where((ad) => ad.show).toList();

    return filteredAds;
  } catch (e) {
    print("Error fetching ads: $e");
    return [];
  }
}
