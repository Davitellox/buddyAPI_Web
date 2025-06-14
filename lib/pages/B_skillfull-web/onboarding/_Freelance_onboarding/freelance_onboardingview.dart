import 'package:buddy/pages/B_skillfull-web/bintro_screen.dart';
import 'package:buddy/pages/B_skillfull-web/onboarding/_Freelance_onboarding/freelance_onboarding_items.dart';
import 'package:buddy/pages/B_skillfull-web/skillfull_home_page.dart';
import 'package:buddy/pages/_logik/splash_screen_to.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Add this import
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class FreelanceOnboardingview extends StatefulWidget {
  const FreelanceOnboardingview({super.key});

  @override
  State<FreelanceOnboardingview> createState() =>
      _FreelanceOnboardingViewState();
}

class _FreelanceOnboardingViewState extends State<FreelanceOnboardingview> {
  final controller = FreelanceOnboardingItems();
  final pageController = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Determine layout scale
    final bool isMobile = screenWidth < 600;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1024;
    final bool isDesktop = screenWidth >= 1024;

    final double titleFontSize = isMobile
        ? 32
        : isTablet
            ? 40
            : 46; //Desktop
    final double subtitleFontSize = isMobile
        ? 16
        : isTablet
            ? 18
            : 20;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const IntroScreen()),
        );
        return false;
      },
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 800;

            return Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black, Colors.black87],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 900),
                      child: PageView.builder(
                        controller: pageController,
                        itemCount: controller.items.length,
                        onPageChanged: (index) => setState(() {
                          isLastPage = controller.items.length - 1 == index;
                        }),
                        itemBuilder: (context, index) {
                          final item = controller.items[index];
                          final isLottie =
                              item.image.toLowerCase().endsWith('.json');

                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: SizedBox(
                                    height: isDesktop ? 400 : 250,
                                    child: isLottie
                                        ? Lottie.asset(item.image)
                                        : Image.asset(item.image),
                                  ),
                                ),
                                SizedBox(height: isDesktop ? 10 : 40),
                                Text(
                                  item.title,
                                  style: TextStyle(
                                    fontSize: titleFontSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: isDesktop ? 5 : 20),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Text(
                                    item.description,
                                    style: TextStyle(
                                      color: Colors.grey.shade300,
                                      fontSize: subtitleFontSize,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                // Bottom Controls
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: isDesktop
                        ? const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 20)
                        : const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 40),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 900),
                      child: isLastPage
                          ? getStartedButton()
                          : navigationControls(),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget navigationControls() {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          onPressed: () =>
              pageController.jumpToPage(controller.items.length - 1),
          child: const Text("Skip", style: TextStyle(color: Colors.grey)),
        ),
        SmoothPageIndicator(
          controller: pageController,
          count: controller.items.length,
          onDotClicked: (index) => pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
          ),
          effect: const WormEffect(
            dotColor: Colors.grey,
            activeDotColor: Colors.orangeAccent,
            dotHeight: 12,
            dotWidth: 12,
          ),
        ),
        TextButton(
          onPressed: () => pageController.nextPage(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
          ),
          child: const Text("Next",
              style: TextStyle(
                color: Colors.orangeAccent,
              )),
        ),
      ],
    );
  }

  Widget getStartedButton() {
    final screenWidth = MediaQuery.of(context).size.width;

    // Determine layout scale
    final bool isMobile = screenWidth < 600;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1024;
    final bool isDesktop = screenWidth >= 1024;
    return SizedBox(
      width: isDesktop ? 420 : double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orangeAccent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 4,
        ),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SplashScreenTo(
                // screen: WelcomeSplashscreen(userType: 'freelancer'),
                screen: SkillfullHomePage(userType: 'freelancer'),
              ),
            ),
          );
        },
        child: const Text(
          "Get Started",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
