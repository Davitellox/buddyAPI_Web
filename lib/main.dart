import 'package:buddy/pages/_config/asplash_screen.dart';
import 'package:buddy/pages/_logik/theme_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
//GENERAL APP MAIN.DART

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: kIsWeb
        ? const FirebaseOptions(
            apiKey: "AIzaSyAozaFiwpPqIuysxgltQ0eMLCf5cBjaf2s",
            authDomain: "buddy-ai-c8f1d.firebaseapp.com",
            projectId: "buddy-ai-c8f1d",
            storageBucket: "buddy-ai-c8f1d.firebasestorage.app",
            messagingSenderId: "833901646451",
            appId: "1:833901646451:web:8bef431b718f3df7dc1006",
          )
        // measurementId: "G-HF105ZSGW2")
        : null, // Mobile uses default options in firebase_options.dart
    // options: DefaultFirebaseOptions.currentPlatform,
  );

  // Create ThemeProvider instance and wait for theme to load
  final themeProvider = ThemeProvider();
  await themeProvider.loadTheme(); // manually expose this method

  runApp(
    ChangeNotifierProvider.value(
      value: themeProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Buddy AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.themeMode,
      home: const SplashScreen(),
    );
  }
}
