import 'dart:async';
import 'package:flutter/material.dart';

class CameraOverlayScreen extends StatefulWidget {
  final String taskText;

  const CameraOverlayScreen({super.key, required this.taskText});

  @override
  State<CameraOverlayScreen> createState() => _CameraOverlayScreenState();
}

class _CameraOverlayScreenState extends State<CameraOverlayScreen> {
  String _displayedText = '';
  Timer? _timer;
  int _charIndex = 0;

  @override
  void initState() {
    super.initState();
    _startTypingEffect();
  }

  void _startTypingEffect() {
    const duration = Duration(milliseconds: 50); // скорость печати

    _timer = Timer.periodic(duration, (Timer timer) {
      if (_charIndex < widget.taskText.length) {
        setState(() {
          _displayedText += widget.taskText[_charIndex];
          _charIndex++;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // пока нет камеры - черный фон
      body: Stack(
        children: [
          Center(
            child: Icon(
              Icons.videocam,
              color: Colors.white.withOpacity(0.3),
              size: 100,
            ), // иконка камеры для имитации
          ),

          // Текст задания с эффектом печати
          Positioned(
            bottom: 40, // немного ниже, чем раньше
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _displayedText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'Courier', // стиль "печатная машинка"
                  letterSpacing: 1.2,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
