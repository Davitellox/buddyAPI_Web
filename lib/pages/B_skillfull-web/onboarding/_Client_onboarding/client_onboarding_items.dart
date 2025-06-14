import 'package:buddy/pages/B_skillfull-web/onboarding/_Client_onboarding/client_onboarding_info.dart';

class ClientOnboardingItems {
  List<ClientOnboardingInfo> items = [
// 1 - Welcome
    ClientOnboardingInfo(
      title: "Welcome to SkillFULL!",
      description:
          "Looking for top-tier service providers? From plumbers to programmers — find trusted experts in seconds.",
      image: "assets/client/onboarding1.json",
    ),

// 2 - Find the Right Talent
    ClientOnboardingInfo(
      title: "Find the Right Talent",
      description:
          "Browse skilled professionals, view their work, and pick the perfect match for your project.",
      image: "assets/client/onboarding2.json",
    ),

// 3 - Hire & Get Things Done
    ClientOnboardingInfo(
      title: "Hire & Get Things Done",
      description:
          "Message directly, get quick responses, and pay only when satisfied. It's that easy.",
      image: "assets/client/onboarding3.json",
    ),

// 4 - Let’s Get Started!
    ClientOnboardingInfo(
      title: "Let's Get Started!",
      description:
          "Create an account to bring your next project to life and get your job done with SkillFULL experts.",
      image: "assets/client/onboarding4.json",
    ),
  ];
}
