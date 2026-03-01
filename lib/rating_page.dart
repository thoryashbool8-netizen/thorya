import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:audioplayers/audioplayers.dart';

class RatingPage extends StatefulWidget {
  const RatingPage({super.key});

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  double _rating = 3;
  final AudioPlayer _player = AudioPlayer();

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _handleRating(double value) async {
    setState(() {
      _rating = value;
    });

    // إذا المستخدم أعطى 4 نجوم أو أكثر، نشغل صوت تصفيق
    if (value >= 4) {
      await _player.stop();
      await _player.play(AssetSource('audio/clap.mp3'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("تقييم التطبيق")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "قيّم التطبيق",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 6),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: _handleRating,
            ),

            const SizedBox(height: 20),

            Text(
              "تقييمك الحالي: ${_rating.toStringAsFixed(1)} / 5",
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 10),

          ],
        ),
      ),
    );
  }
}