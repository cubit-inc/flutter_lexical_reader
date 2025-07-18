import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';

class ParseVideo extends StatefulWidget {
  final Map<String, dynamic> child;

  const ParseVideo({super.key, required this.child});

  @override
  State<ParseVideo> createState() => _ParseVideoState();
}

class _ParseVideoState extends State<ParseVideo> {
  CachedVideoPlayerPlusController? _controller;
  bool _initialized = false;
  bool _isPlaying = false;
  bool _showControls = false;
  String? videoUrl;
  Timer? _hideControlsTimer;

  @override
  void initState() {
    super.initState();
    try {
      final url = widget.child["value"]?["url"] as String?;
      if (url != null && url.isNotEmpty) {
        videoUrl = url;
        debugPrint("Video URL: $url");
        _initializeVideo(url);
      }
    } catch (e) {
      debugPrint("Error parsing video URL: $e");
    }
  }

  Future<void> _initializeVideo(String url) async {
    try {
      _controller = CachedVideoPlayerPlusController.networkUrl(
        Uri.parse(url),
        invalidateCacheIfOlderThan: const Duration(days: 7),
      );

      await _controller!.initialize();

      // Add listener to track playing state
      _controller!.addListener(() {
        if (mounted) {
          setState(() {
            _isPlaying = _controller!.value.isPlaying;
          });
        }
      });

      // // Start playing automatically
      // await _controller!.play();

      setState(() {
        _initialized = true;
      });
    } catch (error) {
      debugPrint("Error loading video: $error");
    }
  }

  void _togglePlayPause() {
    if (_controller != null) {
      if (_isPlaying) {
        _controller!.pause();
      } else {
        _controller!.play();
      }
      _showControlsTemporarily();
    }
  }

  void _showControlsTemporarily() {
    setState(() {
      _showControls = true;
    });

    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 1), () {
      if (mounted && _isPlaying) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _hideControls() {
    if (_isPlaying) {
      setState(() {
        _showControls = false;
      });
    }
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized || _controller == null) {
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

    try {
      return AspectRatio(
        aspectRatio: _controller!.value.aspectRatio,
        child: GestureDetector(
          onTap: _togglePlayPause,
          onDoubleTap: _hideControls,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CachedVideoPlayerPlus(_controller!),
              // Custom play/pause button overlay (only show when paused or controls are visible)
              if (!_isPlaying || _showControls)
                AnimatedOpacity(
                  opacity: _showControls || !_isPlaying ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    } catch (e) {
      debugPrint("Error building video player: $e");
      return const AspectRatio(
        aspectRatio: 16 / 9,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.grey, size: 32),
              SizedBox(height: 8),
              Text(
                'Video not available',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }
  }
}
