import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _controller;
  Future<void>? _initFuture;

  XFile? _lastPhoto;
  XFile? _lastVideo;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final backCamera = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );

    final controller = CameraController(
      backCamera,
      ResolutionPreset.high,
      enableAudio: true,
    );

    _controller = controller;
    _initFuture = controller.initialize();

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  Future<void> _takePhoto() async {
    final c = _controller;
    if (c == null) return;

    HapticFeedback.selectionClick();

    try {
      await _initFuture;

      if (c.value.isRecordingVideo) {
        HapticFeedback.vibrate();
        _snack("أوقف تسجيل الفيديو أولاً");
        return;
      }

      final file = await c.takePicture();

      setState(() {
        _lastPhoto = file;
        _lastVideo = null;
      });

      // بدون gallery_saver: الصورة محفوظة بمسار الملف اللي رجعه camera
      HapticFeedback.heavyImpact();
      _snack("تم التقاط الصورة ✅");
    } catch (e) {
      HapticFeedback.vibrate();
      _snack("خطأ بالتصوير: $e");
    }
  }

  Future<void> _toggleVideo() async {
    final c = _controller;
    if (c == null) return;

    HapticFeedback.selectionClick();

    try {
      await _initFuture;

      if (c.value.isRecordingVideo) {
        final file = await c.stopVideoRecording();

        setState(() {
          _lastVideo = file;
          _lastPhoto = null;
        });

        // بدون gallery_saver: الفيديو محفوظ بمسار الملف اللي رجعه camera
        HapticFeedback.heavyImpact();
        _snack("تم حفظ الفيديو ✅");
      } else {
        await c.startVideoRecording();

        HapticFeedback.mediumImpact();
        setState(() {});
        _snack("بدأ التسجيل...");
      }
    } catch (e) {
      HapticFeedback.vibrate();
      _snack("خطأ بالفيديو: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = _controller;

    return Scaffold(
      appBar: AppBar(title: const Text('Camera')),
      body: c == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder(
              future: _initFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Stack(
                  children: [
                    Positioned.fill(child: CameraPreview(c)),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 24,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FloatingActionButton(
                                heroTag: "photo",
                                onPressed: _takePhoto,
                                child: const Icon(Icons.photo_camera),
                              ),
                              const SizedBox(width: 16),
                              FloatingActionButton(
                                heroTag: "video",
                                onPressed: _toggleVideo,
                                child: Icon(
                                  c.value.isRecordingVideo
                                      ? Icons.stop
                                      : Icons.videocam,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          if (_lastPhoto != null) ...[
                            Text(
                              'Photo path: ${_lastPhoto!.path}',
                              style: const TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ],

                          if (_lastVideo != null) ...[
                            Text(
                              'Video path: ${_lastVideo!.path}',
                              style: const TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ],

                          if (c.value.isRecordingVideo)
                            const Text(
                              "● Recording...",
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}