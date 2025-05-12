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
  late ChewieController chewieController;

  _invokePlay() async {
    await Future.delayed(const Duration(minutes: 5));
    _controller.play();
  }

  @override
  void initState() {
    debugPrint("initState triggered");
    String url = widget.child["value"]["url"];
    setState(() {
      videoUrl = url;
    });
    debugPrint("this is for video parser :: $url");
    if (url != null) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(url),
          videoPlayerOptions: VideoPlayerOptions(allowBackgroundPlayback: true))
        ..initialize().then((value) {
          setState(() {
            _initialized = true;
          });
        });
      debugPrint("this is for video ::: ${_controller.value.aspectRatio}");
      chewieController = ChewieController(
        aspectRatio: _controller.value.aspectRatio,
        // placeholder:
        //     CachedNetworkImage(imageUrl: widget.child["value"]["thumbnailURL"]),
        videoPlayerController: _controller,
        autoPlay: false,
        looping: false,
      );
    }

    super.initState();
  }

  @override
  void dispose() {
    chewieController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (videoUrl == null && !_initialized) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          color: const Color(0xFF000000),
          child: const CircularProgressIndicator.adaptive(),
        ),
      );
    }
    return AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: Chewie(controller: chewieController));
  }
}
