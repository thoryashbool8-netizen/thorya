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

    if (value >= 4) {
      await _player.stop();
      await _player.play(AssetSource('audio/clap.mp3'));
    }
  }

  String _ratingMessage() {
    if (_rating >= 4.5) return "رائع جداً! 🌟";
    if (_rating >= 4) return "ممتاز! شكراً لدعمك 💙";
    if (_rating >= 3) return "جيد 👍";
    if (_rating >= 2) return "يمكننا التحسين 🙂";
    return "سنحاول أن نكون أفضل 🙏";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text("تقييم التطبيق"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 40,
                horizontal: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.star_rounded,
                    size: 60,
                    color: Colors.amber,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "قيّم تجربتك معنا",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 30),

                  RatingBar.builder(
                    initialRating: _rating,
                    minRating: 1,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 36,
                    itemPadding:
                        const EdgeInsets.symmetric(horizontal: 6),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: _handleRating,
                  ),

                  const SizedBox(height: 25),

                  Text(
                    "تقييمك: ${_rating.toStringAsFixed(1)} / 5",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    _ratingMessage(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}