import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class BattleBotVideoPage extends StatefulWidget {
  const BattleBotVideoPage({super.key});

  @override
  State<BattleBotVideoPage> createState() => _BattleBotVideoPageState();
}

class _BattleBotVideoPageState extends State<BattleBotVideoPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Replace this with your web-hosted video link or local asset
    _controller = VideoPlayerController.network(
      'assets/battlebot_preview.mp4',
    )..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const CircularProgressIndicator(color: Colors.greenAccent),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          color: Colors.black,
        ),
      ),
    );
  }
}
