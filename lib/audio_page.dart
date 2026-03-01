import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

class AudioPage extends StatefulWidget {
  const AudioPage({super.key});

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  final AudioRecorder _recorder = AudioRecorder();

  bool isRecording = false;
  String status = "جاهز";
  String? filePath;

  Future<void> startRecording() async {
    if (!await _recorder.hasPermission()) {
      setState(() => status = "لم يتم منح صلاحية المايكروفون");
      return;
    }

    final dir = await getApplicationDocumentsDirectory();
    filePath = "${dir.path}/audio.m4a";

    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
      ),
      path: filePath!,
    );

    setState(() {
      isRecording = true;
      status = "يتم التسجيل...";
    });
  }

  Future<void> stopRecording() async {
    final path = await _recorder.stop();

    setState(() {
      isRecording = false;
      status = path == null
          ? "فشل إيقاف التسجيل"
          : "تم الحفظ: $path";
    });
  }

  @override
  void dispose() {
    _recorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تسجيل الصوت"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              status,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: isRecording ? null : startRecording,
              child: const Text("بدء التسجيل"),
            ),
            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: isRecording ? stopRecording : null,
              child: const Text("إيقاف التسجيل"),
            ),
          ],
        ),
      ),
    );
  }
}