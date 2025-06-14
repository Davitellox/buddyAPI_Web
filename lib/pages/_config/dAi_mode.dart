// Your previous imports here...
import 'dart:async';
import 'dart:math';
import 'dart:html' as html;
import 'dart:js_util' as js_util;
import 'package:buddy/pages/_logik/splash_screenload.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:buddy/pages/_logik/splash_screen_to.dart';

class AIMode extends StatefulWidget {
  final String characterName;

  const AIMode({super.key, required this.characterName});

  @override
  State<AIMode> createState() => _AIModeState();
}

class _AIModeState extends State<AIMode> with SingleTickerProviderStateMixin {
  final AudioPlayer _player = AudioPlayer();
  final AudioPlayer _bgMusicPlayer = AudioPlayer();
  final stt.SpeechToText _speech = stt.SpeechToText();
  final Random _random = Random();

  List<String> remainingCategories = [];
  String? currentCategory;
  int currentQuestionIndex = 1;
  bool _micVisible = false;
  bool _isListening = false;
  bool _speechAvailable = false;
  String _transcribedText = '';
  bool allDone = false;
  String? currentAudio;
  List<_BubbleFeedback> feedbackBubbles = [];
  Completer<void>? _webListeningCompleter;

  final Map<String, int> questionsPerCategory = {
    'career': 3,
    'fashion_style': 2,
    'personality': 4,
    'resume': 3,
    'youtube_videos': 3,
  };

  final Map<String, List<String>> moodFeedbackMap = {
    'happy': ['Great job! 🎉', 'Well done! 🌟', "That's awesome! 😎"],
    'thoughtful': ['Interesting thought 🤔', "That's deep 💭"],
    'confused': ['Thanks for sharing 🙏', "Let's explore more 🔍"],
    'default': ['Thank you! 🙌', 'Cool! 😄'],
  };

  @override
  void initState() {
    super.initState();
    _initSpeech();
    remainingCategories = questionsPerCategory.keys.toList();
    pickNextCategory();
    startBackgroundMusic();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!allDone) playCurrentQuestion();
    });

    _player.onPlayerComplete.listen((event) {
      setState(() => _micVisible = true);
      _startListening();
    });
  }

  void _initSpeech() async {
    if (kIsWeb) {
      setState(() => _speechAvailable = true);
    } else {
      try {
        bool available = await _speech.initialize();
        setState(() => _speechAvailable = available);
      } catch (_) {
        setState(() => _speechAvailable = false);
      }
    }
  }

  Future<void> startBackgroundMusic() async {
    try {
      await _bgMusicPlayer.setVolume(0.05);
      await _bgMusicPlayer.setReleaseMode(ReleaseMode.loop);
      await _bgMusicPlayer.play(
        UrlSource('characters/${widget.characterName}/main/bg_music.mp3'),
      );
    } catch (e) {
      print("Error playing background music: $e");
    }
  }

  Future<void> stopBackgroundMusic() async {
    await _bgMusicPlayer.stop();
  }

  void pickNextCategory() {
    if (remainingCategories.isEmpty) {
      stopBackgroundMusic();
      setState(() {
        allDone = true;
        currentCategory = null;
      });
      Future.delayed(Duration(seconds: 2), () {
        //funct sendDataToModel called
        sendDataToModel(context);
      });
      return;
    }

    setState(() {
      currentCategory = remainingCategories.removeAt(0);
      currentQuestionIndex = 1;
    });
  }

  Future<void> playCurrentQuestion() async {
    if (currentCategory == null || allDone) return;

    final questionCount = questionsPerCategory[currentCategory]!;
    if (currentQuestionIndex > questionCount) {
      pickNextCategory();
      Future.delayed(Duration(milliseconds: 500), playCurrentQuestion);
      return;
    }

    final questionFile = 'q$currentQuestionIndex.mp3';
    final url =
        'characters/${widget.characterName}/main/$currentCategory/$questionFile';

    try {
      await _player.stop();
      await _player.play(UrlSource(url));
      setState(() {
        currentAudio = questionFile;
        _transcribedText = '';
      });
    } catch (e) {
      print('Error playing question: $e');
    }
  }

  Future<void> _playFeedbackAndContinue() async {
    final mood = getMoodFromText(_transcribedText.toLowerCase());
    final feedbackList = moodFeedbackMap[mood] ?? moodFeedbackMap['default']!;
    final feedbackText = feedbackList[_random.nextInt(feedbackList.length)];

    setState(() {
      feedbackBubbles.add(
        _BubbleFeedback(text: feedbackText, id: UniqueKey().toString()),
      );
    });

    // Auto-remove bubble after some time
    Future.delayed(Duration(seconds: 4), () {
      setState(() {
        feedbackBubbles.removeWhere((b) => b.text == feedbackText);
      });
    });

    if (_transcribedText.trim().isNotEmpty && currentCategory != null) {
      //data stored in firebase
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({
            currentCategory!: FieldValue.arrayUnion([_transcribedText.trim()])
          });
        }
      } catch (e) {
        print("Error saving answer: $e");
      }
    }

    await _player.onPlayerComplete.first;

    setState(() => currentQuestionIndex++);
    Future.delayed(Duration(milliseconds: 500), playCurrentQuestion);
  }

  void _startListening() {
    if (kIsWeb) {
      _startListeningWeb();
    } else {
      _startListeningMobile();
    }
  }

  Future<void> _startListeningWeb() async {
    setState(() {
      _isListening = true;
      _transcribedText = 'Listening...';
    });

    _webListeningCompleter = Completer<void>();

    try {
      final resultFuture = js_util.promiseToFuture<String>(
        js_util.callMethod(html.window, 'startSpeechRecognition', []),
      );

      // Wait for either result or manual stop
      final result = await Future.any([
        resultFuture,
        _webListeningCompleter!.future.then((_) => throw 'Stopped manually'),
      ]);

      setState(() {
        _transcribedText = result;
        _isListening = false;
        _micVisible = false;
      });
      await _playFeedbackAndContinue();
    } catch (error) {
      setState(() {
        _transcribedText = 'Error: $error';
        _isListening = false;
        _micVisible = false;
      });
      await _playFeedbackAndContinue();
    }
  }

  void _stopListeningWeb() {
    if (_isListening &&
        _webListeningCompleter != null &&
        !_webListeningCompleter!.isCompleted) {
      _webListeningCompleter!.complete(); // Cancel recognition
    }
  }

  void _startListeningMobile() async {
    if (_isListening || !_speechAvailable) return;

    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          setState(() => _transcribedText = result.recognizedWords);
          if (result.finalResult) {
            _speech.stop();
            setState(() {
              _isListening = false;
              _micVisible = false;
            });
            _playFeedbackAndContinue();
          }
        },
      );
    }
  }

  String getMoodFromText(String input) {
    if (input.contains('great') ||
        input.contains('happy') ||
        input.contains('love')) {
      return 'happy';
    }
    if (input.contains('hmm') ||
        input.contains('maybe') ||
        input.contains('think')) {
      return 'thoughtful';
    }
    if (input.contains('not sure') || input.contains('confused')) {
      return 'confused';
    }
    return 'default';
  }

  Future<void> sendDataToModel(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!doc.exists) return;

    final data = doc.data() ?? {};

    // Fallback to empty string [" "] if value is null or empty
    List<String> ensureListOrString(dynamic value) {
      if (value == null || (value is List && value.isEmpty)) {
        return [" "];
      } else if (value is List<String>) {
        return value;
      } else if (value is String) {
        return [value];
      } else {
        return [" "];
      }
    }

    final payload = {
      'uid': user.uid,
      'career': ensureListOrString(data['career']),
      'fashion_style': ensureListOrString(data['fashion_style']),
      'personality': ensureListOrString(data['personality']),
      'resume': ensureListOrString(data['resume']),
      'youtube_videos': ensureListOrString(data['youtube_videos']),
    };

    // 👉 Navigate to SplashscreenLoad which will handle waiting and moving to results
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SplashScreenTo(
          screen: SplashscreenLoad(payload: payload),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _player.dispose();
    _bgMusicPlayer.dispose();
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "BUddy AI 🤖",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Made with Trae AI 🤖",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 40),

                /// Siri-style glowing animated circle
                AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  width: _isListening ? 200 : 120,
                  height: _isListening ? 200 : 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.deepPurpleAccent.withOpacity(0.2),
                        Colors.deepPurpleAccent.withOpacity(0.6),
                        Colors.deepPurpleAccent,
                      ],
                      stops: [0.3, 0.6, 1.0],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurpleAccent.withOpacity(0.8),
                        blurRadius: 30,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(Icons.graphic_eq,
                        color: Colors.white.withOpacity(0.9), size: 40),
                  ),
                ),

                SizedBox(height: 40),
                // Text(
                //   "Category: $currentCategory\n"
                //   "${currentAudio != null ? "Now Playing: $currentAudio" : "Loading..."}",
                //   textAlign: TextAlign.center,
                //   style: TextStyle(color: Colors.white70),
                // ),
                // SizedBox(height: 16),
                if (_transcribedText.isNotEmpty)
                  Text(
                    "🗣️ You said: $_transcribedText",
                    style: TextStyle(color: Colors.greenAccent),
                    textAlign: TextAlign.center,
                  ),
                SizedBox(height: 30),
                if (_micVisible && _speechAvailable)
                  Column(
                    children: [
                      FloatingActionButton.extended(
                        backgroundColor: Colors.deepPurpleAccent,
                        onPressed: !_isListening ? _startListening : null,
                        label: Text("Listening..."),
                        icon: Icon(Icons.mic),
                      ),
                      if (kIsWeb && _isListening) SizedBox(height: 10),
                      if (kIsWeb && _isListening)
                        ElevatedButton.icon(
                          onPressed: _stopListeningWeb,
                          icon: Icon(Icons.stop),
                          label: Text("Stop"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),

          // Glowing bubble feedbacks (unchanged)
          ...feedbackBubbles.map((bubble) => bubble.build(context)),
        ],
      ),
    );
  }
}

class _BubbleFeedback {
  final String text;
  final String id;

  _BubbleFeedback({required this.text, required this.id});

  Widget build(BuildContext context) {
    final random = Random();
    final double top =
        random.nextDouble() * MediaQuery.of(context).size.height * 0.6;
    final double left =
        random.nextDouble() * MediaQuery.of(context).size.width * 0.6;

    return Positioned(
      top: top,
      left: left,
      child: AnimatedOpacity(
        opacity: 1.0,
        duration: Duration(milliseconds: 600),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.purpleAccent.withOpacity(0.6),
                blurRadius: 12,
                spreadRadius: 2,
              )
            ],
          ),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ),
    );
  }
}
