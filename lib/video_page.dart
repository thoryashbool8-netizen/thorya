import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'app_state.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
      'assets/video/intro.mp4', // مسار الفيديو الموجود داخل مجلد assets
    )..initialize().then((_) {
        // بعد ما يجهز الفيديو، نعمل تحديث للواجهة
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlay() {
    // إذا الفيديو لسا ما تهيأ، ما نعمل أي شيء
    if (!_controller.value.isInitialized) return;

    setState(() {
      // إذا كان شغال نوقفه، وإذا متوقف نشغله
      _controller.value.isPlaying ? _controller.pause() : _controller.play();
    });
  }

  void _unlockQuiz() {
    // نغيّر الحالة حتى نسمح بفتح الاختبار
    AppState.watchedVideo = true;

    // نظهر رسالة بسيطة للمستخدم أنه يمكنه الدخول الى الاختبار
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(" Quiz unlocked! You can open the quiz now."),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tourism Video")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // عرض الفيديو إذا كان جاهز، وإذا لا. نظهر دائرة تحميل
            _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : const Center(child: CircularProgressIndicator()),

            const SizedBox(height: 16),

            // زر تشغيل وإيقاف الفيديو
            ElevatedButton(
              onPressed: _togglePlay,
              child: Text(_controller.value.isPlaying ? "Pause" : "Play"),
            ),

            const SizedBox(height: 12),

            // بعد ما ينتهي المشاهدة يضغط هذا الزر لفتح الاختبار
            ElevatedButton.icon(
              icon: const Icon(Icons.check),
              label: const Text("I finished watching (Unlock Quiz)"),
              onPressed: _unlockQuiz,
            ),
          ],
        ),
      ),
    );
  }
}