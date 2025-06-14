import 'package:buddy/pages/B_skillfull-web/onboarding/_Both_onboarding/both_onboardingview.dart';
import 'package:buddy/pages/B_skillfull-web/onboarding/_Client_onboarding/client_onboardingview.dart';
import 'package:buddy/pages/B_skillfull-web/onboarding/_Freelance_onboarding/freelance_onboardingview.dart';
import 'package:buddy/pages/_logik/components/font.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Determine layout scale
    final bool isMobile = screenWidth < 600;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1024;
    final bool isDesktop = screenWidth >= 1024;

    // Dynamic font sizes
    final double titleFontSize = isMobile
        ? 32
        : isTablet
            ? 40
            : 50; //Desktop
    final double subtitleFontSize = isMobile
        ? 16
        : isTablet
            ? 18
            : 20;

    return Scaffold(
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
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Center(child: TypewriterTextExample(fontSize: titleFontSize)),
                const SizedBox(height: 12),
                Center(child: typesubtl(fontSize: subtitleFontSize)),
                const SizedBox(height: 50),
                ButtonCard(
                  headtext: "Freelancer",
                  iconchoice: Icons.design_services,
                  subtext:
                      "I would be offering a service\nand looking for work",
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FreelanceOnboardingview()));
                  },
                ),
                const SizedBox(height: 15),
                ButtonCard(
                  headtext: "Client",
                  iconchoice: Icons.work_outline,
                  subtext: "I would be hiring services\nand creating jobs",
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ClientOnboardingview()));
                  },
                ),
                const SizedBox(height: 15),
                ButtonCard(
                  headtext: "Both",
                  iconchoice: Icons.handshake_outlined,
                  subtext:
                      "I would be offering a service\nand hiring others service",
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BothOnboardingview()));
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TypewriterTextExample extends StatelessWidget {
  final double fontSize;
  const TypewriterTextExample({super.key, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(
      animatedTexts: [
        TypewriterAnimatedText(
          "WELCOME",
          textStyle: TextStyle(
            fontSize: fontSize,
            color: Colors.deepPurpleAccent,
            fontWeight: FontWeight.bold,
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

class typesubtl extends StatelessWidget {
  final double fontSize;
  const typesubtl({super.key, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(
      animatedTexts: [
        TypewriterAnimatedText(
          "What would you be doing mainly?",
          textStyle: TextStyle(
            fontSize: fontSize,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          speed: const Duration(milliseconds: 30),
        ),
      ],
      totalRepeatCount: 1,
      pause: const Duration(milliseconds: 1000),
      displayFullTextOnTap: true,
      stopPauseOnTap: true,
    );
  }
}

class ButtonCard extends StatefulWidget {
  final String headtext;
  final IconData iconchoice;
  final String subtext;
  final String? iconlabel;
  final Function()? onTap;

  const ButtonCard({
    super.key,
    required this.headtext,
    required this.iconchoice,
    required this.subtext,
    this.iconlabel,
    required this.onTap,
  });

  @override
  State<ButtonCard> createState() => _ButtonCardState();
}

class _ButtonCardState extends State<ButtonCard> {
  double _scale = 1.0;

  void _animateTap() {
    setState(() {
      _scale = 1.1;
    });
    Future.delayed(const Duration(milliseconds: 120), () {
      setState(() {
        _scale = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      // Center for horizontal alignment on wider screens
      child: ConstrainedBox(
        constraints:
            const BoxConstraints(maxWidth: 500), // Limit width on large screens
        child: Material(
          color: const Color(0xFF1E1E2C), // Soft dark card color
          borderRadius: BorderRadius.circular(20),
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.2),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            splashColor: Colors.deepPurpleAccent.withOpacity(0.2),
            highlightColor: Colors.deepPurple.withOpacity(0.05),
            onTap: () {
              _animateTap();
              Future.delayed(const Duration(milliseconds: 120), () {
                widget.onTap?.call();
              });
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(17.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 1.0, end: _scale),
                    duration: const Duration(milliseconds: 120),
                    builder: (context, scale, child) {
                      return Transform.scale(
                        scale: scale,
                        child: Icon(
                          widget.iconchoice,
                          size: 35,
                          color: Colors.deepPurpleAccent,
                          semanticLabel: widget.iconlabel,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.headtext,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.subtext,
                          style: const TextStyle(
                            fontSize: 15.6,
                            color: Colors.white70,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
