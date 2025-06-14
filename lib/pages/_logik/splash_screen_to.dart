import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:buddy/pages/_logik/components/color.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreenTo extends StatelessWidget {
  final screen;
  const SplashScreenTo({super.key, required this.screen});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Set image size based on screen width
    double imageSize;
    if (screenWidth < 600) {
      // Mobile
      imageSize = 250;
    } else if (screenWidth < 1024) {
      // Tablet
      imageSize = 300;
    } else {
      // Laptop/Desktop
      imageSize = 400;
    }

    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: bkgndcolor_grad,
        ),
        AnimatedSplashScreen(
          splash: Center(
            child: Lottie.asset('assets/animation/loading4.json',
                fit: BoxFit.cover), ////////////////
          ),
          nextScreen: screen,
          duration: 1100,
          backgroundColor: Colors.transparent,
          splashIconSize: imageSize,
          splashTransition: SplashTransition.fadeTransition,
        ),
      ],
    ));
  }
}
