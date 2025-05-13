import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ParseVideo extends StatefulWidget {
  final Map<String, dynamic> child;
  const ParseVideo({super.key, required this.child});

  @override
  State<ParseVideo> createState() => _ParseVideoState();
}

class _ParseVideoState extends State<ParseVideo> {
  late VideoPlayerController _controller;
  bool _initialized = false;
  String? videoUrl;
  ChewieController? chewieController;

  @override
  void initState() {
    debugPrint("initState triggered");
    String url = widget.child["value"]["url"];
    setState(() {
      videoUrl = url;
    });
    debugPrint("this is for video parser :: $url");
    if (url != null) {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(url),
        videoPlayerOptions: VideoPlayerOptions(allowBackgroundPlayback: true),
      );

      _initializeVideo();
    }

    super.initState();
  }

  Future<void> _initializeVideo() async {
    try {
      await _controller.initialize();

      // Create chewie controller after video is initialized
      chewieController = ChewieController(
        videoPlayerController: _controller,
        autoPlay: false,
        looping: false,
        aspectRatio: _controller.value.aspectRatio,
        placeholder:null
      );

      setState(() {
        _initialized = true;
      });
    } catch (error) {
      debugPrint("Error initializing video: $error");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized || chewieController == null) {
      return AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: Container(
          color: const Color(0xFF000000),
          child: const CircularProgressIndicator.adaptive(),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: Chewie(controller: chewieController!),
    );
  }
}
