import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'video_page.dart';
import 'places_page.dart';
import 'rating_page.dart';
import 'quiz_page.dart';
import 'app_state.dart';
import 'location_page.dart';
import 'audio_page.dart';
import 'camera_page.dart';
import 'favorites_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _goToVideo(BuildContext context) async {
    HapticFeedback.selectionClick();
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const VideoPage()),
    );
    setState(() {});
  }

  void _openQuiz(BuildContext context) {
    HapticFeedback.selectionClick();

    if (!AppState.watchedVideo) {
      HapticFeedback.vibrate();

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("ممنوع فتح الاختبار"),
          content: const Text("يجب مشاهدة الفيديو أولاً"),
          actions: [
            TextButton(
              onPressed: () {
                HapticFeedback.selectionClick();
                Navigator.pop(context);
              },
              child: const Text("حسناً"),
            ),
            ElevatedButton(
              onPressed: () async {
                HapticFeedback.selectionClick();
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

  void _openFavorites(BuildContext context) {
    HapticFeedback.selectionClick();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FavoritesPage()),
    );
  }

  void _openLocation(BuildContext context) {
    HapticFeedback.selectionClick();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LocationPage()),
    );
  }

  void _openAudio(BuildContext context) {
    HapticFeedback.selectionClick();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AudioPage()),
    );
  }

  void _openCamera(BuildContext context) {
    HapticFeedback.selectionClick();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CameraPage()),
    );
  }

  void _openPlaces(BuildContext context) {
    HapticFeedback.selectionClick();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PlacesPage()),
    );
  }

  void _openRating(BuildContext context) {
    HapticFeedback.selectionClick();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RatingPage()),
    );
  }

  Widget _smallButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool disabled = false,
  }) {
    final textColor = disabled ? Colors.grey : color;
    final bgColor =
        disabled ? Colors.grey.withOpacity(0.1) : color.withOpacity(0.15);

    return InkWell(
      onTap: disabled
          ? () {
              HapticFeedback.vibrate();
            }
          : () {
              HapticFeedback.selectionClick();
              onTap();
            },
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: textColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: textColor),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final quizLocked = !AppState.watchedVideo;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  'assets/images/tourist.jpg',
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black54,
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Tourism App",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "استكشف أجمل الأماكن السياحية",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Text(
                    quizLocked
                        ? "🔒 الاختبار مغلق — شاهد الفيديو أولاً"
                        : "✅ الاختبار مفتوح",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: quizLocked ? Colors.red : Colors.green,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      _smallButton(
                        title: "فيديو",
                        icon: Icons.play_circle,
                        color: const Color(0xFF6C5CE7),
                        onTap: () => _goToVideo(context),
                      ),
                      _smallButton(
                        title: "Quiz",
                        icon: Icons.quiz,
                        color: const Color(0xFF2ECC71),
                        onTap: () => _openQuiz(context),
                      ),
                      _smallButton(
                        title: "المعالم",
                        icon: Icons.place,
                        color: const Color(0xFF0984E3),
                        onTap: () => _openPlaces(context),
                      ),
                      _smallButton(
                        title: "المفضلة",
                        icon: Icons.star,
                        color: const Color(0xFFF1C40F),
                        onTap: () => _openFavorites(context),
                      ),
                      _smallButton(
                        title: "موقعي",
                        icon: Icons.my_location,
                        color: const Color(0xFF00B894),
                        onTap: () => _openLocation(context),
                      ),
                      _smallButton(
                        title: "ميكروفون",
                        icon: Icons.mic,
                        color: const Color(0xFFE17055),
                        onTap: () => _openAudio(context),
                      ),
                      _smallButton(
                        title: "كاميرا",
                        icon: Icons.camera_alt,
                        color: const Color(0xFF111111),
                        onTap: () => _openCamera(context),
                      ),
                      _smallButton(
                        title: "تقييم",
                        icon: Icons.star_rate,
                        color: const Color(0xFFE84393),
                        onTap: () => _openRating(context),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}