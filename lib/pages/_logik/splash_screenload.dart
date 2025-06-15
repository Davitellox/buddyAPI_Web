import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:buddy/pages/_config/eMain_homePage.dart';
import 'package:buddy/pages/_logik/components/font.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashscreenLoad extends StatefulWidget {
  final Map<String, dynamic> payload;

  const SplashscreenLoad({super.key, required this.payload});

  @override
  State<SplashscreenLoad> createState() => _SplashscreenLoadState();
}

class _SplashscreenLoadState extends State<SplashscreenLoad> {
  String? _error;

  final Map<String, String> modelSlugMap = {
    'career': 'Davitello/buddy-career-space',
    'fashion_style': 'Davitello/buddy-fashion-api',
    'personality': 'Davitello/buddy-personality-api',
    'resume': 'Davitello/buddy-resume-api',
    'youtube_videos': 'Davitello/buddy-youtube-api',
  };

  @override
  void initState() {
    super.initState();
    _fetchAndNavigate();
  }

  Future<void> saveResultsToFirestore(Map<String, dynamic> results) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docRef =
        FirebaseFirestore.instance.collection('ai_results').doc(user.uid);

    final dataToSave = {
      ...results,
      'uid': user.uid,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    await docRef.set(dataToSave);
  }

  Future<dynamic> callGradioModel({
    required String modelSlug,
    required List<String> inputList,
  }) async {
    final url = Uri.parse("https://$modelSlug.hf.space/run/predict");

    const hfToken = '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';

    final body = jsonEncode({
      "data": [inputList]
    });

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $hfToken',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      return result["data"];
    } else {
      throw Exception("Model call failed: ${response.statusCode}");
    }
  }

  Future<void> _fetchAndNavigate() async {
    try {
      final payload = widget.payload;
      final results = <String, dynamic>{};

      for (final entry in payload.entries) {
        final key = entry.key;
        if (key == 'uid' || key == 'email' || key == 'registeredAt') continue;

        final modelSlug = modelSlugMap[key];
        if (modelSlug == null) continue;

        List<String> inputList = [];

        if (entry.value is List) {
          inputList = List<String>.from(entry.value
              .map((e) => e.toString().trim())
              .where(
                  (e) => e.isNotEmpty && !e.toLowerCase().contains("error")));
        } else if (entry.value is String) {
          final str = entry.value.toString().trim();
          if (str.isNotEmpty && !str.toLowerCase().contains("error")) {
            inputList = [str];
          }
        }

        if (inputList.isEmpty) {
          debugPrint("⚠️ Skipping empty/invalid input for $key");
          continue;
        }

        try {
          final output = await callGradioModel(
            modelSlug: modelSlug,
            inputList: inputList,
          );

          final List<String> cleanedOutput = List<String>.from(output)
              .map((e) => e.toString().trim())
              .where((e) => e.isNotEmpty && !e.toLowerCase().contains("error"))
              .toList();

          if (key == "career" || key == "fashion_style") {
            results[key] = cleanedOutput.map((item) {
              return {
                "title": item.split(".").first.trim(),
                "description": item,
                "imageUrl":
                    "https://source.unsplash.com/random/?$key&sig=${item.hashCode}"
              };
            }).toList();
          } else if (key == "personality" || key == "resume") {
            results[key] = cleanedOutput.map((item) {
              return {
                "text": item,
                "imageUrl":
                    "https://source.unsplash.com/random/?$key&sig=${item.hashCode}"
              };
            }).toList();
          } else if (key == "youtube_videos") {
            results[key] = cleanedOutput;
          } else {
            results[key] = cleanedOutput;
          }
        } catch (e) {
          results[key] = {
            'error': true,
            'message': e.toString(),
          };
          debugPrint("⚠️ Model for '$key' failed: $e");
        }
      }

      if (payload.containsKey('buddy')) {
        results['buddy'] = payload['buddy'];
      }

      await saveResultsToFirestore(results);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MainHomePage(payload: results),
        ),
      );
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    double imageSize;
    if (screenWidth < 600) {
      imageSize = 250;
    } else if (screenWidth < 1024) {
      imageSize = 400;
    } else {
      imageSize = 500;
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1B1B2F),
              Colors.black,
            ],
          ),
        ),
        child: Center(
          child: _error != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 48, color: Colors.red),
                    const SizedBox(height: 20),
                    Text(
                      _error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _fetchAndNavigate,
                      child: const Text("Retry"),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const BuddyBuildText(),
                    const SizedBox(height: 30),
                    Lottie.asset(
                      'assets/animation/ai_building.json',
                      width: imageSize,
                      height: imageSize,
                      repeat: true,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class BuddyBuildText extends StatelessWidget {
  const BuddyBuildText({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1000;

    return AnimatedTextKit(
      animatedTexts: [
        TypewriterAnimatedText(
          "Buddy is building your Data...",
          textStyle: TextStyle(
            fontSize: isDesktop ? 42 : 31,
            color: Colors.white70,
            fontWeight: FontWeight.w500,
            fontFamily: fontfam,
          ),
          speed: const Duration(milliseconds: 160),
        ),
      ],
      totalRepeatCount: 1,
      pause: const Duration(milliseconds: 1000),
      displayFullTextOnTap: true,
      stopPauseOnTap: true,
    );
  }
}
