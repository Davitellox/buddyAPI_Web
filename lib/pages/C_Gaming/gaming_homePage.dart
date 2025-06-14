import 'dart:ui';
import 'package:buddy/pages/C_Gaming/battlebot_videoPage.dart';
import 'package:buddy/pages/_logik/animated_robotGrid.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class GamingHomePage extends StatelessWidget {
  const GamingHomePage({super.key});

  final List<String> robotGridImages = const [
    'assets/robot_img/0.jpg',
    'assets/robot_img/1.jpg',
    'assets/robot_img/2.jpg',
    'assets/robot_img/3.jpg',
    'assets/robot_img/4.jpeg',
    'assets/robot_img/5.jpg',
    'assets/robot_img/6.jpg',
    'assets/robot_img/7.jpg',
    'assets/robot_img/81.jpg',
    'assets/robot_img/7.webp',
    'assets/robot_img/8.jpg',
    'assets/robot_img/91.jpg',
    'assets/robot_img/92.jpg',
    'assets/robot_img/9.jpg',
    'assets/robot_img/10.jpg',
    'assets/robot_img/11.jpg',
  ];

  final List<String> carouselSlides = const [
    'assets/robot_slide/0.png',
    'assets/robot_slide/1.png',
    'assets/robot_slide/2.png',
    'assets/robot_slide/3.png',
    'assets/robot_slide/4.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: Stack(
        children: [
          const Positioned.fill(child: AnimatedRobotGrid()),
          Positioned.fill(
            child: Container(
                color: Colors.black.withOpacity(0.3)), // subtle overlay
          ),
          // _buildRobotGrid(),
          Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 600),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CarouselSlider(
                          options: CarouselOptions(
                            height: 300,
                            autoPlay: true,
                            enlargeCenterPage: true,
                            viewportFraction: 0.9,
                          ),
                          items: carouselSlides.map((img) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                img,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const BattleBotVideoPage(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.smart_toy),
                          label: const Text("Preview Battle Bot"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00FF94),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRobotGrid() {
    return Positioned.fill(
      child: GridView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6,
          childAspectRatio: 1,
          mainAxisSpacing: 1,
          crossAxisSpacing: 1,
        ),
        itemCount: 120,
        itemBuilder: (context, index) {
          final imagePath = robotGridImages[index % robotGridImages.length];
          return Image.asset(
            imagePath,
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.2),
            colorBlendMode: BlendMode.darken,
          );
        },
      ),
    );
  }
}
