import 'package:buddy/pages/B_skillfull-web/bintro_screen.dart';
import 'package:buddy/pages/B_skillfull-web/skillfull_home_page.dart';
import 'package:flutter/material.dart';

class NavSkillful_Intro_or_Home extends StatelessWidget {
  final bool isProfileSetup;
  
  const NavSkillful_Intro_or_Home({
    super.key,
    required this.isProfileSetup,
  });

  @override
  Widget build(BuildContext context) {
    if (isProfileSetup) {
      return const SkillfullHomePage(userType: 'freelancer',); ////
    } else {
      return const IntroScreen();
    }
  }
}
