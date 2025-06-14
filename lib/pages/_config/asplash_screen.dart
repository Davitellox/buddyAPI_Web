// import 'package:buddy/pages/_config/bchoose_ur_Buddy.dart';
import 'package:buddy/pages/_config/bchoose_ur_buddy.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return introWelcomeScreen(context);
  }

  Widget introWelcomeScreen(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Set image size based on screen width
    double imageSize;
    if (screenWidth < 600) {
      // Mobile
      imageSize = 250;
    } else if (screenWidth < 1024) {
      // Tablet
      imageSize = 400;
    } else {
      // Laptop/Desktop
      imageSize = 500;
    }

    final Map<String, dynamic> samplePayload = {
      "buddy": "Alex Johnson",
      "career": [
        {
          "title": "Software Engineer",
          "description": "Build amazing mobile and web apps.",
          "imageUrl":
              "https://images.unsplash.com/photo-1519389950473-47ba0277781c",
        },
        {
          "title": "Product Manager",
          "description": "Lead product development and strategy.",
          "imageUrl":
              "https://images.unsplash.com/photo-1504384308090-c894fdcc538d",
        },
      ],
      "fashion_style": [
        {
          "title": "Casual Wear",
          "description": "Comfort meets style.",
          "imageUrl":
              "https://images.unsplash.com/photo-1520975920957-3a8f3675f4ee",
        },
        {
          "title": "Formal Attire",
          "description": "Look sharp for every occasion.",
          "imageUrl":
              "https://images.unsplash.com/photo-1492562080023-ab3db95bfbce",
        }
      ],
      "personality": [
        {
          "text": "Energetic, creative, and highly adaptable.",
          "imageUrl":
              "https://images.unsplash.com/photo-1544005313-94ddf0286df2"
        }
      ],
      "resume": [
        {
          "text": "Experienced in mobile app development and UI/UX design.",
          "imageUrl":
              "https://images.unsplash.com/photo-1504384308090-c894fdcc538d"
        }
      ],
      "youtube_videos": [
        "latest flutter tutorials",
        "fashion styling tips",
        "career advice for developers"
      ]
    };

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1B1B2F), // Deep navy-purple
              Colors.black, // Rich black
            ],
          ),
        ),
        child: AnimatedSplashScreen(
          splash: Center(
            child: Lottie.asset('assets/animation/Tworobot_fun.json',
                fit: BoxFit.cover), ////////////////
          ),
          nextScreen: const Choose_Ur_BuddyScreen(),
          // nextScreen: MainHomePage(payload: samplePayload),
          duration: 2500,
          backgroundColor: Colors.transparent,
          splashIconSize: imageSize,
          splashTransition: SplashTransition.fadeTransition,
        ),
      ),
    );
  }
}
