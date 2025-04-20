import 'package:flutter/material.dart';

class CameraOverlayScreen extends StatelessWidget {
  final String taskText;

  const CameraOverlayScreen({super.key, required this.taskText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Чёрный фон (как будто камера)
          Positioned.fill(
            child: Container(color: Colors.black),
          ),

          // Текст задания
          Positioned(
            bottom: 100,
            left: 20,
            right: 20,
            child: Text(
              taskText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Кнопка "Запись"
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('🎬 Фейковая запись началась...'),
                  ));
                },
                icon: const Icon(Icons.videocam),
                label: const Text("Начать запись"),
              ),
            ),
          ),

          // Назад
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
