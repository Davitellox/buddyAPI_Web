import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:buddy/pages/B_skillfull-web/screens/_Both/aboth_home_screen.dart';
import 'package:buddy/pages/B_skillfull-web/screens/_Both/bboth_orders_screen.dart';
import 'package:buddy/pages/B_skillfull-web/screens/_Both/cboth_chat_screen.dart';
import 'package:buddy/pages/B_skillfull-web/screens/_Both/dboth_profile_screen.dart';
import 'package:buddy/pages/B_skillfull-web/screens/_Client/aclient_homescreen.dart';
import 'package:buddy/pages/B_skillfull-web/screens/_Client/bclient_orders_screen.dart';
import 'package:buddy/pages/B_skillfull-web/screens/_Client/cclient_chats_screen.dart';
import 'package:buddy/pages/B_skillfull-web/screens/_Client/dclient_profile_screen.dart';
import 'package:buddy/pages/B_skillfull-web/screens/_Freelance/afreelance_homescreen.dart';
import 'package:buddy/pages/B_skillfull-web/screens/_Freelance/bfreelance_orderscreen.dart';
import 'package:buddy/pages/B_skillfull-web/screens/_Freelance/cfreelance_chatscreen.dart';
import 'package:buddy/pages/B_skillfull-web/screens/_Freelance/dfreelance_proflie.dart';
import 'package:buddy/pages/_config/eMain_homePage.dart';
import 'package:buddy/pages/_logik/components/font.dart';
import 'package:buddy/pages/_logik/splash_screen_to.dart';
import 'package:buddy/pages/_logik/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SkillfullHomePage extends StatefulWidget {
  final String userType;
  const SkillfullHomePage({super.key, required this.userType});

  @override
  State<SkillfullHomePage> createState() => _SkillfullHomePageState();
}

class _SkillfullHomePageState extends State<SkillfullHomePage>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isSidebarOpen = true;
  bool get isDarkMode => Theme.of(context).brightness == Brightness.dark;

  late List<Widget> _pages;
  late List<IconData> _iconsFilled;
  late List<IconData> _iconsOutlined;
  late List<String> _labels;

  @override
  void initState() {
    super.initState();
    if (widget.userType == 'client') {
      _pages = const [
        ClientHomeScreen(),
        ClientOrdersPage(),
        ClientChatScreen(),
        ClientProfileScreen(),
        BuddyLaunchScreen()
      ];
      _iconsFilled = [
        Icons.home,
        Icons.shopping_cart,
        Icons.chat,
        Icons.person,
        FontAwesomeIcons.robot
      ];
      _iconsOutlined = [
        Icons.home_outlined,
        Icons.shopping_cart_outlined,
        Icons.chat_outlined,
        Icons.person_outline,
        FontAwesomeIcons.robot
      ];
      _labels = ["Home", "Orders", "Chats", "Profile", "Buddy AI"];
    } else if (widget.userType == 'freelancer') {
      _pages = const [
        FreelancerHomeScreen(), //
        FreelanceOrderScreen(),
        FreelancerPreChatScreen(),
        FreelancerProfileScreen(),
        BuddyLaunchScreen()
      ];
      _iconsFilled = [
        Icons.home,
        Icons.shopping_cart,
        Icons.chat,
        Icons.person,
        FontAwesomeIcons.robot
      ];
      _iconsOutlined = [
        Icons.home_outlined,
        Icons.shopping_cart_outlined,
        Icons.chat_outlined,
        Icons.person_outline,
        FontAwesomeIcons.robot
      ];
      _labels = ["Home", "Orders", "Chats", "Profile", "Buddy AI"];
    } else {
      _pages = const [
        BothHomeScreen(),
        BothOrdersScreen(),
        BothChatScreen(),
        BothProfileScreen(),
        BuddyLaunchScreen()
      ];
      _iconsFilled = [
        Icons.home,
        Icons.shopping_bag,
        Icons.chat,
        Icons.person,
        FontAwesomeIcons.robot
      ];
      _iconsOutlined = [
        Icons.home_outlined,
        Icons.shopping_bag_outlined,
        Icons.chat_outlined,
        Icons.person_outline,
        FontAwesomeIcons.robot
      ];
      _labels = ["Home", "Orders", "Chats", "Profile", 'Buddy AI'];
    }
  }

  // Mild orange glow effect for icons only
  List<Shadow> getIconGlow(Color color) {
    return [
      Shadow(
        color: color.withOpacity(0.4),
        blurRadius: 6,
      ),
    ];
  }

  Widget _buildSidebarItem(
      int index, String label, IconData iconFilled, IconData iconOutlined) {
    bool isSelected = _selectedIndex == index;
    bool isHovered = false;

    return StatefulBuilder(
      builder: (context, setStateHover) {
        return MouseRegion(
          onEnter: (_) => setStateHover(() => isHovered = true),
          onExit: (_) => setStateHover(() => isHovered = false),
          child: Tooltip(
            message: _isSidebarOpen ? "" : label,
            child: GestureDetector(
              onTap: () => setState(() {
                _selectedIndex = index;
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                padding: EdgeInsets.symmetric(
                    vertical: 12, horizontal: _isSidebarOpen ? 16 : 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.deepOrangeAccent.shade100.withOpacity(0.3)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  // No box shadow here anymore, only icon glows
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isSelected || isHovered ? iconFilled : iconOutlined,
                      color: isSelected || isHovered
                          ? Colors.deepOrangeAccent.shade200
                          : Colors.white70,
                      size: 28,
                      shadows: (isSelected || isHovered)
                          ? getIconGlow(Colors.deepOrangeAccent.shade200)
                          : null,
                    ),
                    if (_isSidebarOpen) ...[
                      const SizedBox(width: 12),
                      Text(
                        label,
                        style: TextStyle(
                          color: isSelected || isHovered
                              ? Colors.deepOrangeAccent.shade200
                              : Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          shadows: null, // No glow on text
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: _isSidebarOpen ? 220 : 70,
      color: Colors.grey[900],
      child: Column(
        children: [
          SizedBox(height: 12),
          // Toggle button
          Align(
            alignment:
                _isSidebarOpen ? Alignment.centerRight : Alignment.center,
            child: IconButton(
              icon: Icon(
                _isSidebarOpen ? Icons.arrow_back_ios_new : Icons.menu,
                color: Colors.deepOrangeAccent.shade200,
                size: 24,
              ),
              tooltip: _isSidebarOpen ? 'Close navigation' : 'Open navigation',
              onPressed: () {
                setState(() {
                  _isSidebarOpen = !_isSidebarOpen;
                });
              },
            ),
          ),
          const SizedBox(height: 10),

          // Navigation items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: List.generate(_labels.length, (index) {
                return _buildSidebarItem(index, _labels[index],
                    _iconsFilled[index], _iconsOutlined[index]);
              }),
            ),
          ),

          const Divider(
            color: Colors.white24,
            thickness: 1,
            indent: 12,
            endIndent: 12,
          ),

          // Settings at bottom
          // Theme toggle and settings
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: 12, horizontal: _isSidebarOpen ? 16 : 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    context.read<ThemeProvider>().setTheme(!isDarkMode);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isDarkMode ? Icons.light_mode : Icons.dark_mode,
                        color: Colors.white70,
                        size: 26,
                        shadows: getIconGlow(Colors.deepOrangeAccent.shade200),
                      ),
                      if (_isSidebarOpen) ...[
                        const SizedBox(width: 12),
                        Text(
                          isDarkMode ? "Light Mode" : "Dark Mode",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    // TODO: Navigate to Settings
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.settings,
                        color: Colors.white70,
                        size: 26,
                        shadows: getIconGlow(Colors.deepOrangeAccent.shade200),
                      ),
                      if (_isSidebarOpen) ...[
                        const SizedBox(width: 12),
                        Text(
                          'Settings',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          ///

          const SizedBox(height: 12),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth > 900) {
      return Scaffold(
        backgroundColor: Colors.grey[850],
        body: Row(
          children: [
            _buildSidebar(),
            Expanded(child: _pages[_selectedIndex]),
          ],
        ),
      );
    } else {
      // Mobile bottom navigation
      return Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_iconsFilled.length, (index) {
              final bool isSelected = _selectedIndex == index;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? Colors.deepOrangeAccent.shade100
                            : Colors.transparent,
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        transitionBuilder: (child, animation) =>
                            ScaleTransition(scale: animation, child: child),
                        child: Icon(
                          isSelected
                              ? _iconsFilled[index]
                              : _iconsOutlined[index],
                          key: ValueKey<bool>(isSelected),
                          color: isSelected
                              ? Colors.deepOrangeAccent.shade200
                              : Colors.white70,
                          size: 26,
                          shadows: isSelected
                              ? getIconGlow(Colors.deepOrangeAccent.shade200)
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _labels[index],
                      style: TextStyle(
                        color: isSelected
                            ? Colors.deepOrangeAccent.shade200
                            : Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              );
            }),
          ),
        ),
      );
    }
  }
}

class BuddyLaunchScreen extends StatefulWidget {
  const BuddyLaunchScreen({super.key});

  @override
  State<BuddyLaunchScreen> createState() => _BuddyLaunchScreenState();
}

class _BuddyLaunchScreenState extends State<BuddyLaunchScreen> {
  // @override
  // void initState() {
  //   super.initState();
  //   // Simulate a delay before showing the dialog
  //   Future.delayed(const Duration(seconds: 2), () {
  //     _GoToBuddyDialog("Go to Buddy AI MainPage?",
  //         "This Action will take you to Buddy AI Mainpage.", () {
  // Navigator.pushReplacement(
  //   context,
  //   MaterialPageRoute(
  //     builder: (context) => SkillfullHomePage(userType: 'both'),
  //   ),
  // );
  //     });
  //   });
  // }
  void _GoToBuddyDialog(String title, String content, Function() onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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

    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1000;
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[900]
          : Colors.grey[100],
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isDesktop ? 500 : 350,
            minWidth: 250,
          ),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[850]
                : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        "Navigate Back to Buddy AI?🤖",
                        textStyle: TextStyle(
                          fontSize: isDesktop ? 30 : 20,
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                          fontFamily: fontfam,
                        ),
                        speed: const Duration(milliseconds: 80),
                      ),
                    ],
                    totalRepeatCount: 1,
                    pause: const Duration(milliseconds: 1000),
                    displayFullTextOnTap: true,
                    stopPauseOnTap: true,
                  ),
                  const SizedBox(height: 20),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     _GoToBuddyDialog(
                  //       "Go to Buddy AI MainPage?",
                  //       "This Action will take you to Buddy AI Mainpage.",
                  //       () {
                  //         Navigator.pushReplacement(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (context) =>
                  //                 MainHomePage(payload: samplePayload),
                  //           ),
                  //         );
                  //       },
                  //     );
                  //   },
                  //   child: const Text(
                  //     "Let's Go! 🚀",
                  //     style: TextStyle(
                  //       color: Colors.white60,
                  //       fontWeight: FontWeight.w600,
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () async {
                      final user = FirebaseAuth.instance.currentUser;
                      if (user == null) return;

                      final docRef = FirebaseFirestore.instance
                          .collection('ai_results')
                          .doc(user.uid);
                      final doc = await docRef.get();

                      if (!doc.exists) {
                        // Handle error: no results found
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  "Page Unable to load. Logout and try Again")),
                        );
                        return;
                      }

                      final payload = doc.data() ?? {};

                      _GoToBuddyDialog(
                        "Go to Buddy AI MainPage?",
                        "This Action will take you to Buddy AI Mainpage.",
                        () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SplashScreenTo(
                                  screen: MainHomePage(payload: payload)),
                            ),
                          );
                        },
                      );
                    },
                    child: const Text(
                      "Yep Let's Go!🤖",
                      style: TextStyle(
                        color: Colors.deepPurpleAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
