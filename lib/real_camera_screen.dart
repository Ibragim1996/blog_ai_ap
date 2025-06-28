import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'video_preview_screen.dart';

class RealCameraScreen extends StatefulWidget {
  final String taskText;
  const RealCameraScreen({super.key, required this.taskText});

  @override
  State<RealCameraScreen> createState() => _RealCameraScreenState();
}

class _RealCameraScreenState extends State<RealCameraScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      final front = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
      );
      _controller = CameraController(front, ResolutionPreset.medium);
      _initializeControllerFuture = _controller!.initialize();
      setState(() {});
    } catch (e) {
      print("Camera error: $e");
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Camera error: $e")));
      }
    }
  }

  Future<void> _startRecording() async {
    if (_controller != null &&
        _controller!.value.isInitialized &&
        !_controller!.value.isRecordingVideo) {
      await _controller!.startVideoRecording();
      setState(() {
        _isRecording = true;
      });
    }
  }

  Future<void> _stopAndSave() async {
    if (_controller != null && _controller!.value.isRecordingVideo) {
      final file = await _controller!.stopVideoRecording();
      setState(() {
        _isRecording = false;
      });

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (_) => VideoPreviewScreen(
                videoPath: file.path,
                taskText: widget.taskText,
              ),
        ),
      );
    }
  }

  Future<void> _uploadFromGallery() async {
    final status = await Permission.photos.request();

    if (status.isGranted) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
      if (pickedFile != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (_) => VideoPreviewScreen(
                  videoPath: pickedFile.path,
                  taskText: widget.taskText,
                ),
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("No video selected.")));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Permission to access gallery was denied."),
        ),
      );
    }
  }

  Future<void> _uploadPhotoFromGallery() async {
    final status = await Permission.photos.request();

    if (status.isGranted) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (_) => VideoPreviewScreen(
                  videoPath: pickedFile.path,
                  taskText: widget.taskText,
                ),
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("No photo selected.")));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Permission to access gallery was denied."),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Widget _buildOverlayText() {
    return Positioned(
      bottom: 100,
      left: 20,
      right: 20,
      child: Text(
        widget.taskText,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          backgroundColor: Color.fromARGB(120, 0, 0, 0),
        ),
      ),
    );
  }

  Widget _buildControlButtons() {
    return Positioned(
      bottom: 30,
      left: 10,
      right: 10,
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 12,
        children: [
          ElevatedButton(
            onPressed: _isRecording ? null : _startRecording,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text('Record'),
          ),
          ElevatedButton(
            onPressed: _isRecording ? _stopAndSave : null,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Finish'),
          ),
          ElevatedButton(
            onPressed: _uploadFromGallery,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Gallery'),
          ),
          ElevatedButton(
            onPressed: _uploadPhotoFromGallery,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            child: const Text('Photo'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body:
          _initializeControllerFuture == null
              ? const Center(child: CircularProgressIndicator())
              : FutureBuilder(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      _controller != null) {
                    return Stack(
                      children: [
                        CameraPreview(_controller!),
                        _buildOverlayText(),
                        _buildControlButtons(),
                        Positioned(
                          top: 40,
                          left: 20,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Ошибка камеры: ${snapshot.error}'),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
    );
  }
}
