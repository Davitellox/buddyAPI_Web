import 'package:buddy/pages/A_self_Discovery/self_discovery_home.dart';
import 'package:buddy/pages/B_skillfull-web/logic/nav_home_or_intro.dart';
import 'package:buddy/pages/C_Gaming/gaming_homePage.dart';
import 'package:buddy/pages/D_profile_settings.dart/profile_settings.dart';
import 'package:buddy/pages/_logik/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class MainHomePage extends StatefulWidget {
  final Map<String, dynamic> payload;

  const MainHomePage({super.key, required this.payload});

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage>
    with TickerProviderStateMixin {
  late List<IconData> _iconsFilled;
  late List<IconData> _iconsOutlined;
  bool _isSidebarOpen = true;
  late List<String> _labels;
  late List<Widget> _pages;
  int _selectedIndex = 0;

  // final Map<String, dynamic> samplePayload = {
  //   "buddy": "Alex Johnson",
  //   "career": [
  //     {
  //       "title": "Software Engineer",
  //       "description": "Build amazing mobile and web apps.",
  //       "imageUrl":
  //           "https://images.unsplash.com/photo-1519389950473-47ba0277781c",
  //     },
  //     {
  //       "title": "Product Manager",
  //       "description": "Lead product development and strategy.",
  //       "imageUrl":
  //           "https://images.unsplash.com/photo-1504384308090-c894fdcc538d",
  //     },
  //   ],
  //   "fashion_style": [
  //     {
  //       "title": "Casual Wear",
  //       "description": "Comfort meets style.",
  //       "imageUrl":
  //           "https://images.unsplash.com/photo-1520975920957-3a8f3675f4ee",
  //     },
  //     {
  //       "title": "Formal Attire",
  //       "description": "Look sharp for every occasion.",
  //       "imageUrl":
  //           "https://images.unsplash.com/photo-1492562080023-ab3db95bfbce",
  //     }
  //   ],
  //   "personality": [
  //     {
  //       "text": "Energetic, creative, and highly adaptable.",
  //       "imageUrl": "https://images.unsplash.com/photo-1544005313-94ddf0286df2"
  //     }
  //   ],
  //   "resume": [
  //     {
  //       "text": "Experienced in mobile app development and UI/UX design.",
  //       "imageUrl":
  //           "https://images.unsplash.com/photo-1504384308090-c894fdcc538d"
  //     }
  //   ],
  //   "youtube_videos": [
  //     "latest flutter tutorials",
  //     "fashion styling tips",
  //     "career advice for developers"
  //   ]
  // };

  @override
  void initState() {
    super.initState();
    _pages = [
      SelfDiscoveryHome(
        payload: widget.payload,
      ), //self discovery
      NavSkillful_Intro_or_Home(
        isProfileSetup: false,
      ), //marketplace skillfull
      GamingHomePage(), //gaming
      ProfileSettingsScreen() //profile ...
    ];
    _iconsFilled = [
      FontAwesomeIcons.house,
      FontAwesomeIcons.briefcase,
      FontAwesomeIcons.gamepad,
      FontAwesomeIcons.solidUser
    ];
    _iconsOutlined = [
      Icons.home_outlined,
      Icons.work_outline_rounded,
      FontAwesomeIcons.gamepad,
      Icons.person_outline
    ];
    _labels = ["Home", "Marketplace", "Gaming", "Profile"]; //
  }

  bool get isDarkMode => Theme.of(context).brightness == Brightness.dark;

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
                      ? Colors.deepPurpleAccent.shade100.withOpacity(0.3)
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
                          ? Colors.deepPurpleAccent.shade200
                          : Colors.white70,
                      size: 28,
                      shadows: (isSelected || isHovered)
                          ? getIconGlow(Colors.deepPurpleAccent.shade200)
                          : null,
                    ),
                    if (_isSidebarOpen) ...[
                      const SizedBox(width: 12),
                      Text(
                        label,
                        style: TextStyle(
                          color: isSelected || isHovered
                              ? Colors.deepPurpleAccent.shade200
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
                color: Colors.deepPurpleAccent.shade200,
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
                        shadows: getIconGlow(Colors.deepPurpleAccent.shade200),
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
                        shadows: getIconGlow(Colors.deepPurpleAccent.shade200),
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
                            ? Colors.deepPurpleAccent.shade100
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
                              ? Colors.deepPurpleAccent.shade200
                              : Colors.white70,
                          size: 26,
                          shadows: isSelected
                              ? getIconGlow(Colors.deepPurpleAccent.shade200)
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _labels[index],
                      style: TextStyle(
                        color: isSelected
                            ? Colors.deepPurpleAccent.shade200
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
