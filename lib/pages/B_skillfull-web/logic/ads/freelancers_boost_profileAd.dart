// FREELANCER BOOST PROFILE WIDGET
import 'package:buddy/pages/_logik/components/theme_color_mainpage.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FreelancerBoostAdWidget extends StatefulWidget {
  const FreelancerBoostAdWidget({super.key});

  @override
  State<FreelancerBoostAdWidget> createState() =>
      _FreelancerBoostAdWidgetState();
}

class _FreelancerBoostAdWidgetState extends State<FreelancerBoostAdWidget> {
  int _currentPage = 0;
  late PageController _pageController;
  List<Map<String, String>> ads = [];
  bool showAds = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    fetchAds();
    autoSlide();
  }

  void autoSlide() {
    Future.delayed(const Duration(seconds: 6), () {
      if (_pageController.hasClients && mounted && ads.isNotEmpty) {
        int nextPage = (_currentPage + 1) % ads.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
        setState(() => _currentPage = nextPage);
        autoSlide();
      }
    });
  }

  Future<void> fetchAds() async {
    final collectionRef =
        FirebaseFirestore.instance.collection('freelancerboostads');

    // 1. Check config doc
    final configDoc = await collectionRef.doc('configfreelancerboostads').get();
    if (!configDoc.exists || configDoc.data()?['showAds'] != true) {
      setState(() => showAds = false);
      return;
    }

    // 2. Fetch other ad documents
    final querySnapshot = await collectionRef.get();
    final List<Map<String, String>> loadedAds = [];

    for (var doc in querySnapshot.docs) {
      if (doc.id == 'configfreelancerboostads') continue;
      final data = doc.data();
      if (data.containsKey('title') && data.containsKey('imageUrl')) {
        loadedAds.add({
          'title': data['title'] ?? '',
          'imageUrl': data['imageUrl'] ?? '',
        });
      }
    }

    setState(() {
      ads = loadedAds;
      showAds = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!showAds || ads.isEmpty) return const SizedBox.shrink();
    final brightness = Theme.of(context).brightness;
    final colors =
        getThemeColorsMainPages('freelancer', brightness: brightness);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: colors.fieldFillColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colors.borderColor,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 240,
            child: PageView.builder(
              controller: _pageController,
              itemCount: ads.length,
              itemBuilder: (context, index) {
                final ad = ads[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 24),
                  child: Column(
                    children: [
                      if (ad['imageUrl']!.endsWith('.json'))
                        Expanded(
                          child: Lottie.network(ad['imageUrl']!,
                              fit: BoxFit.contain),
                        )
                      else
                        Expanded(
                          child: Image.network(ad['imageUrl']!,
                              fit: BoxFit.contain),
                        ),
                      const SizedBox(height: 8),
                      Text(
                        ad['title'] ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: colors.textColor,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: colors.auxIconColor
                  ?.withValues(alpha: 0.6), // 0.95 * 255 ≈ 242
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                        context, '/boostProfile'); // Define this route
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: colors.textColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('🚀 Boost Profile Now'),
                ),
                const SizedBox(height: 8),
                Text(
                  'Get noticed by more clients and grow your service reach.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.textColor.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
