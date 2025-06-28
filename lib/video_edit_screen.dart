import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:gallery_saver/gallery_saver.dart';

class VideoEditScreen extends StatefulWidget {
  final String videoPath;
  final String taskText;

  const VideoEditScreen({
    super.key,
    required this.videoPath,
    required this.taskText,
  });

  @override
  State<VideoEditScreen> createState() => _VideoEditScreenState();
}

class _VideoEditScreenState extends State<VideoEditScreen> {
  late VideoPlayerController _controller;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ---- САМАЯ ГЛАВНАЯ ФУНКЦИЯ ----
  Future<void> _saveVideoWithText() async {
    setState(() {
      _saving = true;
    });
    try {
      final Directory tempDir = await getTemporaryDirectory();
      final String outputPath = "${tempDir.path}/video_with_text.mp4";

      final String aiText = widget.taskText.replaceAll("'", "\\'");

      final String ffmpegCmd =
          "-i '${widget.videoPath}' "
          "-vf \"drawtext=text='$aiText':fontcolor=white:fontsize=36:borderw=2:bordercolor=black:x=(w-text_w)/2:y=h-text_h-80\" "
          "-codec:a copy '$outputPath'";

      await FFmpegKit.execute(ffmpegCmd);
      final bool? result = await GallerySaver.saveVideo(outputPath);
      if (result == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Video saved to gallery!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("⚠️ Failed to save video.")),
        );
      }
      if (await File(outputPath).exists()) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('✅ Video saved with text!\n$outputPath')),
          );
        }
      } else {
        throw 'Failed to save video';
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() {
        _saving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit & Save Video'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          if (_controller.value.isInitialized)
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
          else
            const Center(child: CircularProgressIndicator()),
          const SizedBox(height: 18),
          Text(
            'AI Task: ${widget.taskText}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 18),
          ElevatedButton.icon(
            onPressed: _saving ? null : _saveVideoWithText,
            icon: const Icon(Icons.save),
            label:
                _saving
                    ? const Text('Saving...')
                    : const Text('Save with Text'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
