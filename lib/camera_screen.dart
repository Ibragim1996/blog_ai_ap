import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  String randomTask = 'Random Task Appears Here';
  bool taskAccepted = false;

  void acceptTask() {
    setState(() {
      taskAccepted = true;
    });
  }

  void saveTask() {
    setState(() {
      taskAccepted = true;
    });
  }

  void skipTask() {
    setState(() {
      randomTask = 'Another Random Task';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Здесь будет в будущем камера
          Center(
            child: Container(
              color: Colors.black,
              child: const Text(
                'Camera Preview Here',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),

          // Текст задания
          if (!taskAccepted)
            Positioned(
              bottom: 150,
              left: 20,
              right: 20,
              child: Column(
                children: [
                  Text(
                    randomTask,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: acceptTask,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFF1E88E5,
                          ), // стильный синий
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              12,
                            ), // скругление углов
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        child: const Text(
                          'Accept',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: saveTask,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF43A047), // зелёный
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        child: const Text(
                          'Save',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: skipTask,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF757575), // серый
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        child: const Text(
                          'Skip',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          // Кнопка Назад
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
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
