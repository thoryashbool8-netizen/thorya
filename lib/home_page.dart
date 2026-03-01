import 'package:flutter/material.dart';

import 'video_page.dart';
import 'places_page.dart';
import 'rating_page.dart';
import 'quiz_page.dart';
import 'app_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _goToVideo(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const VideoPage()),
    );
    // بعد الرجوع من صفحة الفيديو، نعيد بناء الصفحة لتحديث النص/الحالة
    setState(() {});
  }

  void _openQuiz(BuildContext context) {
    if (!AppState.watchedVideo) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("ممنوع فتح الاختبار"),
          content: const Text("يجب أن تشاهد الفيديو أولاً"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("حسناً"),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await _goToVideo(context);
              },
              child: const Text("اذهب للفيديو"),
            ),
          ],
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const QuizPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tourism App")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.play_circle),
                label: const Text("فيديو تعريفي"),
                onPressed: () => _goToVideo(context),
              ),
            ),
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.place),
                label: const Text("المعالم السياحية"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PlacesPage()),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.star),
                label: const Text("تقييم التطبيق"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RatingPage()),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.quiz),
                label: const Text("اختبار Quiz"),
                onPressed: () => _openQuiz(context),
              ),
            ),

            const SizedBox(height: 10),

            Text(
              AppState.watchedVideo
                  ? "✅ الاختبار مفتوح"
                  : "🔒 الاختبار مغلق — شاهدي الفيديو أولاً",
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}