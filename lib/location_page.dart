import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  String status = "يرجى الضغط على الزر أدناه لعرض موقعك الحالي.";
  Position? pos;
  bool loading = false;

  Future<void> getLocation() async {
    if (loading) return;

    // ✅ نقرة خفيفة عند الضغط على الزر
    HapticFeedback.selectionClick();

    setState(() {
      loading = true;
      status = "جارٍ التحقق من إعدادات الموقع...";
      pos = null;
    });

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // ✅ تنبيه اهتزاز لأن GPS مطفي
      HapticFeedback.vibrate();

      setState(() {
        loading = false;
        status =
            "خدمة تحديد الموقع غير مفعّلة. يرجى تفعيل GPS من إعدادات الجهاز.";
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      // ✅ تنبيه اهتزاز لأن الإذن مرفوض
      HapticFeedback.vibrate();

      setState(() {
        loading = false;
        status = "تم رفض إذن الوصول إلى الموقع.";
      });
      return;
    }

    if (permission == LocationPermission.deniedForever) {
      // ✅ تنبيه اهتزاز لأن الإذن مرفوض بشكل دائم
      HapticFeedback.vibrate();

      setState(() {
        loading = false;
        status =
            "تم رفض الإذن بشكل دائم. يرجى تفعيل صلاحية الموقع من إعدادات التطبيق.";
      });
      return;
    }

    setState(() => status = "جارٍ تحديد موقعك الحالي...");

    try {
      final p = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // ✅ اهتزاز نجاح عند تحديد الموقع
      HapticFeedback.mediumImpact();

      setState(() {
        pos = p;
        loading = false;
        status = "تم تحديد موقعك بنجاح.";
      });
    } catch (e) {
      // ✅ اهتزاز تنبيه عند الخطأ
      HapticFeedback.vibrate();

      setState(() {
        loading = false;
        status = "حدث خطأ أثناء محاولة تحديد الموقع.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6FA),
        appBar: AppBar(
          title: const Text("الموقع الجغرافي الحالي"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 40,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        status,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (pos != null)
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _infoRow("خط العرض", pos!.latitude.toStringAsFixed(6)),
                        _infoRow("خط الطول", pos!.longitude.toStringAsFixed(6)),
                        _infoRow(
                          "دقة التحديد",
                          "${pos!.accuracy.toStringAsFixed(0)} متر",
                        ),
                      ],
                    ),
                  ),
                ),
              const Spacer(),

              // زر الموقع الحالي
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton.icon(
                  onPressed: getLocation,
                  icon: const Icon(Icons.gps_fixed, size: 26),
                  label: Text(
                    loading ? "جارٍ تحديد الموقع..." : "تحديد موقعي الحالي",
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D47A1),
                    foregroundColor: Colors.white,
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "$label:",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}