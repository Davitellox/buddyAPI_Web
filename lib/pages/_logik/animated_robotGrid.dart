import 'package:flutter/material.dart';

class AnimatedRobotGrid extends StatefulWidget {
  const AnimatedRobotGrid({super.key});

  @override
  State<AnimatedRobotGrid> createState() => _AnimatedRobotGridState();
}

class _AnimatedRobotGridState extends State<AnimatedRobotGrid>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  final robotImages = [
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
    // Add more as needed
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 40),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildGrid() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        childAspectRatio: 1,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
      ),
      itemCount: 120,
      itemBuilder: (_, index) => Image.asset(
        robotImages[index % robotImages.length],
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final dx = _controller.value * width;
          return Stack(
            children: [
              Positioned(
                left: -dx,
                top: 0,
                width: width,
                height: constraints.maxHeight,
                child: _buildGrid(),
              ),
              Positioned(
                left: width - dx,
                top: 0,
                width: width,
                height: constraints.maxHeight,
                child: _buildGrid(),
              ),
            ],
          );
        },
      );
    });
  }
}
