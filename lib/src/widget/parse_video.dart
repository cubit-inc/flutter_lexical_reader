import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ParseVideo extends StatefulWidget {
  final Map<String, dynamic> child;

  const ParseVideo({super.key, required this.child});

  @override
  State<ParseVideo> createState() => _ParseVideoState();
}

class _ParseVideoState extends State<ParseVideo> {
  late VideoPlayerController _controller;
  ChewieController? chewieController;
  bool _initialized = false;
  String? videoUrl;

  @override
  void initState() {
    super.initState();
    final url = widget.child["value"]["url"] as String?;
    if (url != null) {
      videoUrl = url;
      debugPrint("Video URL: $url");
      _initializeVideo(url);
    }
  }

  Future<void> _initializeVideo(String url) async {
    try {
      final file = await DefaultCacheManager().getSingleFile(url);

      _controller = VideoPlayerController.file(file);

      await _controller.initialize();

      chewieController = ChewieController(
        videoPlayerController: _controller,
        autoPlay: false,
        looping: false,
        aspectRatio: _controller.value.aspectRatio,
      );

      setState(() {
        _initialized = true;
      });
    } catch (error) {
      debugPrint("Error loading video: $error");
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
      return const AspectRatio(
        aspectRatio: 16 / 9,
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator.adaptive(),
          ),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: Chewie(controller: chewieController!),
    );
  }
}
