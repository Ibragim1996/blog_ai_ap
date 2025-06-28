import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path/path.dart' as p;

class VideoPreviewScreen extends StatefulWidget {
  final String videoPath;
  final String taskText;

  const VideoPreviewScreen({
    super.key,
    required this.videoPath,
    required this.taskText,
  });

  @override
  State<VideoPreviewScreen> createState() => _VideoPreviewScreenState();
}

class _VideoPreviewScreenState extends State<VideoPreviewScreen> {
  VideoPlayerController? _controller;
  bool isSaved = false;
  late bool isVideo;

  @override
  void initState() {
    super.initState();

    final ext = p.extension(widget.videoPath).toLowerCase();
    isVideo = ext == '.mp4' || ext == '.mov' || ext == '.avi' || ext == '.mkv';

    if (isVideo) {
      _controller = VideoPlayerController.file(File(widget.videoPath))
        ..initialize().then((_) {
          setState(() {});
          _controller?.play();
          _controller?.setLooping(true);
        });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _saveMedia() async {
    if (!isSaved) {
      bool? result;
      if (isVideo) {
        result = await GallerySaver.saveVideo(widget.videoPath);
      } else {
        result = await GallerySaver.saveImage(widget.videoPath);
      }
      setState(() {
        isSaved = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result == true
                ? (isVideo
                    ? "✅ Video saved to gallery"
                    : "✅ Photo saved to gallery")
                : "⚠️ Failed to save.",
          ),
        ),
      );
    }
  }

  Future<void> _shareMedia() async {
    await Share.shareXFiles([XFile(widget.videoPath)], text: widget.taskText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Preview"),
        actions: [
          IconButton(
            onPressed: _saveMedia,
            icon: const Icon(Icons.save),
            tooltip: 'Save',
          ),
          IconButton(
            onPressed: _shareMedia,
            icon: const Icon(Icons.share),
            tooltip: 'Share',
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
            tooltip: 'Close',
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child:
                isVideo
                    ? (_controller != null && _controller!.value.isInitialized
                        ? AspectRatio(
                          aspectRatio: _controller!.value.aspectRatio,
                          child: VideoPlayer(_controller!),
                        )
                        : const CircularProgressIndicator())
                    : Image.file(File(widget.videoPath), fit: BoxFit.contain),
          ),
          // Task text overlay
          Positioned(
            bottom: 80,
            left: 20,
            right: 20,
            child: Text(
              widget.taskText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                backgroundColor: Colors.black54,
              ),
            ),
          ),
          // Large Share & Save buttons at the bottom
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _saveMedia,
                  icon: const Icon(Icons.save),
                  label: Text(isVideo ? 'Save Video' : 'Save Photo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _shareMedia,
                  icon: const Icon(Icons.share),
                  label: const Text('Share'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
