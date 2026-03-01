import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final AudioPlayer _player = AudioPlayer();

  final List<QuizQuestion> questions = [
    QuizQuestion(
      question: "أي موقع يُعرف بالمدينة الوردية؟",
      options: ["جرش", "البتراء", "العقبة", "وادي رم"],
      correctIndex: 1,
    ),
    QuizQuestion(
      question: "أين يمكن الطفو بسبب الملوحة العالية؟",
      options: ["العقبة", "البحر الميت", "جرش", "البتراء"],
      correctIndex: 1,
    ),
    QuizQuestion(
      question: "أي موقع مشهور بالآثار الرومانية؟",
      options: ["جرش", "وادي رم", "البحر الميت", "العقبة"],
      correctIndex: 0,
    ),
    QuizQuestion(
      question: "أي موقع مشهور بالصحراء والمغامرات؟",
      options: ["وادي رم", "جرش", "البتراء", "البحر الميت"],
      correctIndex: 0,
    ),
    QuizQuestion(
      question: "أي مدينة ساحلية على البحر الأحمر؟",
      options: ["العقبة", "جرش", "البتراء", "وادي رم"],
      correctIndex: 0,
    ),
  ];

  int currentIndex = 0;
  int score = 0;
  int? selectedOption;

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> selectAnswer(int i) async {
    // إذا المستخدم اختار إجابة من قبل، لا يمكنه يختار مرة ثانية لنفس السؤال
    if (selectedOption != null) return;

    setState(() => selectedOption = i);

    final isCorrect = i == questions[currentIndex].correctIndex;

    if (isCorrect) {
      score++;

      // ✅ اهتزاز قوي عند الإجابة الصحيحة
      HapticFeedback.heavyImpact();

      // ✅ صوت تشجيعي عند الإجابة الصحيحة
      await _player.stop();
      await _player.play(AssetSource('audio/cheer.mp3'));
    } else {
      // ✅ اهتزاز تنبيه عند الإجابة الخاطئة
      HapticFeedback.vibrate();
    }
  }

  void nextQuestion() {
    // ✅ لا ينتقل للسؤال الذي بعده إلا إذا المستخدم اختار إجابة
    if (selectedOption == null) {
      // اهتزاز خفيف للتنبيه
      HapticFeedback.selectionClick();
      return;
    }

    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        selectedOption = null;
      });
    } else {
      // إذا انتهت الأسئلة كلها، اذهب على صفحة النتيجة
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => QuizResultPage(score: score, total: questions.length),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = questions[currentIndex];

    return Scaffold(
      appBar: AppBar(title: const Text("Quiz")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "سؤال ${currentIndex + 1} من ${questions.length}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(q.question, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 12),

            ...List.generate(q.options.length, (i) {
              final isChosen = selectedOption == i;
              return Card(
                child: ListTile(
                  title: Text(q.options[i]),
                  trailing: isChosen ? const Icon(Icons.check) : null,
                  onTap: () => selectAnswer(i),
                ),
              );
            }),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: nextQuestion,
                child: Text(
                  currentIndex == questions.length - 1 ? "إنهاء" : "التالي",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizResultPage extends StatefulWidget {
  final int score;
  final int total;

  const QuizResultPage({super.key, required this.score, required this.total});

  @override
  State<QuizResultPage> createState() => _QuizResultPageState();
}

class _QuizResultPageState extends State<QuizResultPage> {
  final AudioPlayer _player = AudioPlayer();
  bool _played = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // ✅ إذا كانت النتيجة ممتازة (4 من 5 أو أكثر) تشغل صوت + اهتزاز مرة واحدة فقط
    if (!_played && widget.score >= 4) {
      _played = true;
      HapticFeedback.heavyImpact();
      _player.play(AssetSource('audio/clap.mp3'));
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("النتيجة")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "نتيجتك: ${widget.score} / ${widget.total}",
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                widget.score >= 4 ? "🎉 ممتاز!" : "حاول مرة ثانية!",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 18),
              ElevatedButton.icon(
                icon: const Icon(Icons.home),
                label: const Text("العودة للرئيسية"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}