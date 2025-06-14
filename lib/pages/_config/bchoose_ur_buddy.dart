import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:buddy/pages/_config/dAi_mode.dart';
import 'package:buddy/pages/_config/eMain_homePage.dart';
import 'package:buddy/pages/_logik/components/font.dart';
import 'package:buddy/pages/_logik/splash_screen_to.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:html' as html;

// only for web

class Choose_Ur_BuddyScreen extends StatefulWidget {
  const Choose_Ur_BuddyScreen({super.key});
  @override
  State<Choose_Ur_BuddyScreen> createState() => _Choose_Ur_BuddyScreenState();
}

class _Choose_Ur_BuddyScreenState extends State<Choose_Ur_BuddyScreen>
    with SingleTickerProviderStateMixin {
  int? hoveredIndex;
  int? selectedCardIndex;
  late final AnimationController _sparkController;
  final List<Map<String, String>> characters = [
    {"name": "NovA", "image": "nova.jpg"},
    {"name": "Spectra", "image": "spectra.jpg"},
    {"name": "Halo", "image": "halo.png"},
    {"name": "SnoWflakE", "image": "snowflake.png"},
    {"name": "Lady Mara", "image": "lady_mara.jpg"},
    {"name": "Jack Hammer", "image": "jack.jpeg"},
    {"name": "Diva", "image": "diva.jpg"},
    {"name": "Smoke", "image": "smoke.png"},
    {"name": "Buddi", "image": "buddi.png"},
    {"name": "SilverBlade", "image": "silverblade.png"},
    {"name": "Chuk", "image": "chuk.jpeg"},
    {"name": "SpaceCat", "image": "space_cat.jpeg"},
    {"name": "Hard Shot", "image": "hardshot.jpeg"},
    {"name": "Kay", "image": "k.png"},
    {"name": "Big Head", "image": "bighead.png"},
    {"name": "NejI", "image": "neji.jpeg"},
  ];

  final AudioPlayer _audioPlayer = AudioPlayer();
  final Random _random = Random();

  Future<void> _requestMicrophoneAccess(BuildContext context) async {
    try {
      await html.window.navigator.mediaDevices?.getUserMedia({'audio': true});
      debugPrint("Microphone access granted");
      // Navigate to the voice convo screen
      Navigator.pushNamed(context, '/voiceConvo');
    } catch (e) {
      debugPrint("Microphone access denied: $e");
      // Show a dialog or error UI
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Microphone access denied. Please enable it to continue.")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _sparkController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void deactivate() {
    _audioPlayer.stop(); // Ensures it stops when navigating away
    super.deactivate();
  }

  @override
  void dispose() {
    _sparkController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1000;
    final isMobile = screenWidth < 600;
    // final selectedName = characters[selectedCardIndex!]['name']!;
    // final novaSelected = selectedName == "NovA";

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Color.fromARGB(255, 45, 25, 80)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          /////////
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1400),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 32 : 16,
                  vertical: isDesktop ? 24 : 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                        ////////
                        child: BuddyText()),
                    SizedBox(height: isDesktop ? 35 : 18),
                    Center(child: BuddySubText()),
                    const SizedBox(height: 24),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            ////////
                            flex: isDesktop ? 7 : 10,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                int crossAxisCount = isMobile ? 1 : 2;
                                if (constraints.maxWidth > 900) {
                                  crossAxisCount = 3;
                                }
                                if (constraints.maxWidth > 1200) {
                                  crossAxisCount = 4;
                                }
                                return GridView.builder(
                                  itemCount: characters.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: isMobile ? 4 : 3,
                                  ),
                                  itemBuilder: (context, index) {
                                    final character = characters[index];
                                    final isSelected =
                                        selectedCardIndex == index;
                                    return MouseRegion(
                                      onEnter: (_) =>
                                          setState(() => hoveredIndex = index),
                                      onExit: (_) =>
                                          setState(() => hoveredIndex = null),
                                      child: GestureDetector(
                                        onTap: () {
                                          final name =
                                              characters[index]['name']!;

                                          // Update UI instantly
                                          setState(() {
                                            selectedCardIndex = index;
                                          });

                                          // Then play audio after a short delay
                                          Future.delayed(
                                              Duration(milliseconds: 50), () {
                                            playCharacterPreviewAudio(name);
                                          });
                                        },
                                        child: AnimatedBuilder(
                                          ///////////////////////////////////////////
                                          animation: _sparkController,
                                          builder: (context, child) {
                                            return Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                AnimatedScale(
                                                  scale: hoveredIndex == index
                                                      ? 1.05
                                                      : 1.0,
                                                  duration: const Duration(
                                                      milliseconds: 300),
                                                  curve: Curves.easeInOut,
                                                  child: AnimatedContainer(
                                                    duration: const Duration(
                                                        milliseconds: 300),
                                                    padding: EdgeInsets.all(
                                                        isDesktop ? 16 : 12),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                      color: isSelected
                                                          ? Colors.deepPurple
                                                          : Colors.white10,
                                                      border: Border.all(
                                                        color: isSelected
                                                            ? Colors
                                                                .deepPurpleAccent
                                                            : Colors.white24,
                                                        width: 2,
                                                      ),
                                                      boxShadow: [
                                                        if (isSelected)
                                                          BoxShadow(
                                                            color: Colors
                                                                .deepPurpleAccent
                                                                .withOpacity(
                                                                    0.7),
                                                            blurRadius: 20,
                                                            spreadRadius: 5,
                                                          )
                                                        else if (hoveredIndex ==
                                                            index)
                                                          BoxShadow(
                                                            color: Colors
                                                                .deepPurpleAccent
                                                                .withOpacity(
                                                                    0.3),
                                                            blurRadius: 15,
                                                            spreadRadius: 2,
                                                          ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        CircleAvatar(
                                                          radius: isDesktop
                                                              ? 40
                                                              : 30,
                                                          backgroundImage: character[
                                                                      'image'] !=
                                                                  ""
                                                              ? AssetImage(
                                                                  'assets/characters/images/${character['image']!}')
                                                              : null,
                                                          backgroundColor:
                                                              Colors.white10,
                                                          child: character[
                                                                      'image'] ==
                                                                  ""
                                                              ? Icon(
                                                                  Icons.person,
                                                                  size:
                                                                      isDesktop
                                                                          ? 40
                                                                          : 30)
                                                              : null,
                                                        ),
                                                        const SizedBox(
                                                            width: 20),
                                                        Expanded(
                                                          child: Text(
                                                            character['name']!,
                                                            style: TextStyle(
                                                              fontSize:
                                                                  isDesktop
                                                                      ? 24
                                                                      : 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: isSelected
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .white70,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                if (isSelected)
                                                  Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: Container(
                                                      width: 15 +
                                                          5 *
                                                              _sparkController
                                                                  .value,
                                                      height: 15 +
                                                          5 *
                                                              _sparkController
                                                                  .value,
                                                      decoration: BoxDecoration(
                                                        color: Colors
                                                            .deepPurpleAccent
                                                            .withOpacity(0.7),
                                                        shape: BoxShape.circle,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors
                                                                .deepPurpleAccent
                                                                .withOpacity(
                                                                    0.5),
                                                            blurRadius: 10,
                                                            spreadRadius: 3,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          if (isDesktop && selectedCardIndex != null)
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 32),
                                child: _buildSelectedCharacterDetails(),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (!isDesktop) ////////////////////////
                      Center(
                          child: TextButton(
                        onPressed: selectedCardIndex != null
                            ? () async {
                                try {
                                  await _requestMicrophoneAccess(context);
                                  // Optional: Show confirmation
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text("Microphone access granted."),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                } catch (e) {
                                  debugPrint(
                                      "Mic permission denied or error: $e");

                                  // Show dialog to explain why mic is needed
                                  await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text("Microphone Access Needed"),
                                      content: Text(
                                        "To talk to the AI, we need access to your microphone. Please tap 'Allow' when prompted by your browser.",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text("OK"),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                // Continue to character selection and sign-in regardless
                                await _onSelectCharacter(context);
                              }
                            : null,
                        style: TextButton.styleFrom(
                          backgroundColor: selectedCardIndex != null
                              ? Colors.deepPurple.withOpacity(0.25)
                              : Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 32,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: selectedCardIndex != null
                                  ? Colors.deepPurpleAccent
                                  : Colors.white24,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Continue with Google",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: selectedCardIndex != null
                                    ? Colors.deepPurpleAccent
                                    : Colors.white38,
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Icon(
                              FontAwesomeIcons.google,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      )),
                    // const SizedBox(height: 20),
                    Center(
                      child: selectedCardIndex != null
                          ? null
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account? LogIn",
                                  style: TextStyle(
                                    color: Colors.deepPurpleAccent,
                                    fontSize: isDesktop ? 17 : 14,
                                    // decoration: TextDecoration.underline,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Icon(
                                  FontAwesomeIcons.google,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ), //////////
      ),
    );
  }

  Widget _buildSelectedCharacterDetails() {
    if (selectedCardIndex == null) return const SizedBox();
    final character = characters[selectedCardIndex!];
    final imageUrl = character['image'] ?? "";
    final hasImage = imageUrl.trim().isNotEmpty;
    final novaselected = character['name'] == "NovA";

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.deepPurpleAccent, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selected Character',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 24),

          /// ✅ Updated image handling here
          Center(
            child: CircleAvatar(
              radius: 80,
              backgroundColor: Colors.white10,
              backgroundImage: character['image'] != ""
                  ? AssetImage(
                      'assets/characters/images/${character['image']!}')
                  : null,
              child: character['image'] == ""
                  ? const Icon(Icons.person, size: 80)
                  : null,
            ),
          ),

          const SizedBox(height: 24),

          Text(
            character['name'] ?? '',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 32),
          novaselected
              ? TextButton(
                  onPressed: () => _onSelectCharacter(context),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.deepPurple.withOpacity(0.25),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 32),
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(
                        color: Colors.deepPurpleAccent,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Continue with Google",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(FontAwesomeIcons.google, color: Colors.white),
                    ],
                  ),
                )
              : TextButton(
                  onPressed: null,
                  child: Text("This Buddy isn't available now\nTry Nova")),
        ],
      ),
    );
  }

  void showErrormsg(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor:
              Colors.black.withOpacity(0.8), // Dark background with opacity
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0), // Rounded corners
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline, // Error icon
                  color: Colors.redAccent,
                  size: 40,
                ),
                const SizedBox(height: 15),
                Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white, // White text for contrast
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> loginWithGoogle(BuildContext context) async {
    try {
      await _audioPlayer.stop(); // 🔇 Stop preview audio

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      UserCredential userCredential;

      if (kIsWeb) {
        // --- Web Google Sign-In ---
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        userCredential =
            await FirebaseAuth.instance.signInWithPopup(googleProvider);
      } else {
        // --- Mobile Google Sign-In ---
        final GoogleSignIn googleSignIn = GoogleSignIn();

        // Optional: force account selection
        await googleSignIn.signOut();

        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
        if (googleUser == null) {
          Navigator.pop(context);
          return;
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
      }

      final User? user = userCredential.user;
      if (user == null) {
        Navigator.pop(context);
        showErrormsg("User data not available.");
        return;
      }

      String uid = user.uid;
      String name = user.displayName ?? "User";
      String email = user.email ?? "Email not found";

      // Check if user exists in Firestore
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();

      if (!userDoc.exists ||
          !(userDoc.data() as Map<String, dynamic>).containsKey('buddy')) {
        Navigator.pop(context);
        showErrormsg("User profile incomplete or not found.");
        return;
      }

      // Fetch user data from Firestore
      final data = userDoc.data() as Map<String, dynamic>;

      String buddy = data['buddy'] ?? '';
      name = data['name'] ?? name;
      email = data['email'] ?? email;

      // Read arrays safely with fallback empty list
      List<String> career = List<String>.from(data['career'] ?? []);
      List<String> fashionStyle =
          List<String>.from(data['fashion_style'] ?? []);
      List<String> personality = List<String>.from(data['personality'] ?? []);
      List<String> resume = List<String>.from(data['resume'] ?? []);
      List<String> youtubeVideos =
          List<String>.from(data['youtube_videos'] ?? []);

      // Build the payload map
      final payload = {
        'career': career,
        'fashion_style': fashionStyle,
        'personality': personality,
        'resume': resume,
        'youtube_videos': youtubeVideos,
      };

      // Save locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_uid', uid);
      await prefs.setString('user_name', name);
      await prefs.setString('user_email', email);
      await prefs.setString('buddy', buddy);

      Navigator.pop(context);

      // Navigate to home page with payload
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainHomePage(
            payload: payload,

            // ytApiKey: '',
          ),
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      showErrormsg("Failed to Login with Google. Reload & Try Again");
    }
  }

//play character preview Audio(
//),
  Future<void> playCharacterPreviewAudio(String characterName) async {
    try {
      final safeName =
          characterName.replaceAll(' ', ''); // e.g. Tony Stark → TonyStark
      final index = Random().nextInt(3); // 0, 1, or 2
      final url =
          'characters/$safeName/intro_audio/${safeName.toLowerCase()}$index.mp3';

      print("🎧 Playing: $url");

      await _audioPlayer.stop();
      await _audioPlayer.play(UrlSource(url));
    } catch (e) {
      print('⚠️ Error playing audio: $e');
    }
  }

  // Future<void> playCharacterPreviewAudio(String characterName) async {
  //   try {
  //     final safeName = characterName.replaceAll(' ', '');
  //     final index = Random().nextInt(3); // 0, 1, or 2
  //     final assetPath =
  //         'assets/characters/$safeName/intro_audio/${safeName.toLowerCase()}$index.mp3';

  //     print("🎧 Playing: $assetPath");

  //     // Stop if something is playing
  //     await _audioPlayer.stop();

  //     // Introduce a short delay to ensure cleanup (web-specific fix)
  //     await Future.delayed(Duration(milliseconds: 100));

  //     // Play from asset
  //     await _audioPlayer.play(AssetSource(assetPath));
  //   } catch (e) {
  //     print('⚠️ Error playing audio: $e');
  //   }
  // }

  // once a character is selected;; the google sign up logic

  Future<void> _onSelectCharacter(BuildContext context) async {
    final selectedName = characters[selectedCardIndex!]['name']!;
    await _audioPlayer.stop();

    try {
      // Logout previous user (optional if you're not switching accounts)
      await FirebaseAuth.instance.signOut();

      // Start Google Sign-In
      final googleProvider = GoogleAuthProvider();
      googleProvider.setCustomParameters({'prompt': 'select_account'});
      final userCredential =
          await FirebaseAuth.instance.signInWithPopup(googleProvider);

      final user = userCredential.user!;
      final uid = user.uid;
      final name = user.displayName ?? 'No Name';
      final email = user.email ?? 'No Email';

      final docRef = FirebaseFirestore.instance.collection("users").doc(uid);
      final doc = await docRef.get();

      if (!doc.exists) {
        // Create new user record with default values
        await docRef.set({
          'name': name,
          'email': email,
          'uid': uid,
          'registeredAt': FieldValue.serverTimestamp(),
          'buddy': selectedName,
          'career': <String>[],
          'fashion_style': <String>[],
          'personality': <String>[],
          'resume': <String>[],
          'youtube_videos': <String>[],
        });
        debugPrint("✅ New user registered: $email");
      } else {
        debugPrint("👤 Existing user detected: $email — no data overwritten.");
      }

      // Navigate to next screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              SplashScreenTo(screen: AIMode(characterName: selectedName)),
        ),
      );
    } catch (e) {
      showErrormsg("Google sign-in failed. Try again.");
    }
  }
}

class BuddyText extends StatelessWidget {
  const BuddyText({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1000;
    return AnimatedTextKit(
      animatedTexts: [
        TypewriterAnimatedText(
          "Buddy",
          textStyle: TextStyle(
            fontSize: isDesktop ? 30 : 20,
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

class BuddySubText extends StatelessWidget {
  const BuddySubText({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1000;
    return AnimatedTextKit(
      animatedTexts: [
        TypewriterAnimatedText(
          "Choose your buddy\nMade with Trae AI 🤖",
          textStyle: TextStyle(
            fontSize: isDesktop ? 30 : 20,
            color: Colors.white70,
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

//   Widget _blurredIcon(String imageUrl) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(20),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//         child: Container(
//           width: 100,
//           height: 100,
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.2),
//             image: DecorationImage(
//               image: NetworkImage(imageUrl),
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
