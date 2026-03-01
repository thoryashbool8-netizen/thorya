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
    _controller = VideoPlayerController.asset('assets/video/intro.mp4')
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlay() {
    if (!_controller.value.isInitialized) return;

    setState(() {
      _controller.value.isPlaying ? _controller.pause() : _controller.play();
    });
  }

  void _unlockQuiz() {
    AppState.watchedVideo = true;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(" تم فتح الاختبار! يمكنك الدخول الآن."),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isReady = _controller.value.isInitialized;
    final isPlaying = isReady && _controller.value.isPlaying;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6FA),
        appBar: AppBar(
          title: const Text("فيديو سياحي"),
          centerTitle: true,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              //  كرت الفيديو
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                clipBehavior: Clip.antiAlias,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: isReady
                      ? AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        )
                      : const SizedBox(
                          height: 220,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                ),
              ),

              const SizedBox(height: 16),

              //  حالة الفيديو
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isPlaying ? Icons.play_circle_fill : Icons.pause_circle_filled,
                    size: 22,
                    color: isPlaying ? Colors.green : Colors.orange,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isPlaying ? "الفيديو يعمل الآن" : "الفيديو متوقف",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isPlaying ? Colors.green : Colors.orange,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              //  زر تشغيل/إيقاف واضح
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: isReady ? _togglePlay : null,
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  label: Text(isPlaying ? "إيقاف مؤقت" : "تشغيل الفيديو"),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              //  زر فتح الاختبار 
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: isReady ? _unlockQuiz : null,
                  icon: const Icon(Icons.check_circle),
                  label: const Text("أنهيت المشاهدة (فتح الاختبار)"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              //  ملاحظة للمستخدم
              const Text(
                "بعد إنهاء مشاهدة الفيديو اضغط زر (أنهيت المشاهدة) لفتح الاختبار.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}